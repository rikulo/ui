//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  4:08:37 PM
// Author: tomyeh

/**
 * Represents a view that allows the user to select a single item
 * from a drop-down list.
 *
 * ##Events
 *
 * + select: an instance of [SelectEvent] indicates the selected item has been changed.
 * Notice that [SelectEvent.selectedItems] is always null. Use [SelectEvent.selectedValues]
 * instead.
 */
class DropDownList<T> extends View {
  DataModel _model;
  DataEventListener _dataListener;
  StringRenderer _renderer;
  int _rows = 1;
  EventListener _onChange;
  bool _modelSelUpdating = false; //whether it's updating model's selection
  bool _disabled = false, _autofocus = false;

  DropDownList([DataModel model, StringRenderer renderer]) {
    _renderer = renderer;
    this.model = model;
  }

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled => _disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    _disabled = disabled;

    if (inDocument)
      (node as SelectElement).disabled = _disabled;
  }

  /** Returns the number of visible rows.
   *
   * Default: 1
   */
  int get rows => _rows;
  /** Sets the number of visible rows.
   */
  void set rows(int rows) {
    _rows = rows;

    if (inDocument)
      (node as SelectElement).size = _rows;
  }

  /** Returns whether this button should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus => _autofocus;
  /** Sets whether this button should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    _autofocus = autofocus;
    if (autofocus && inDocument)
      (node as SelectElement).focus();
  }

  //@Override
  String get className => "DropDownList"; //TODO: replace with reflection if Dart supports it

  /** Returns the model.
   */
  DataModel get model => _model;
  /** Sets the model.
   * The model must be an instance of [ListModel] or [TreeModel].
   *
   * ##Note of Using [TreeModel]
   *
   * + The non-leaf node ([TreeModel.isLeaf] is false) can't be selected.
   * + [TreeModel.root] won't be rendered (so it can be anything)
   * + Only `root`'s children and grand-children nodes will be rendered.
   * In other words, it renders only two levels of nodes.
   */
  void set model(DataModel model) {
    if (model != null) {
      if (model is! Selection)
        throw new UIException("Selection required, $model");
      if (model is! ListModel && model is! TreeModel)
        throw new UIException("Only ListModel or TreeModel allowed, not $model");
    }

    if (_model !== model) { //Note: it is not !=
      if (_model != null)
        _model.on.all.remove(_dataListener);

      _model = model;

      if (_model != null) {
        _model.on.all.add(_initDataListener());

        if (inDocument)
          (node as SelectElement).multiple = (_model as Selection).multiple;
      }

      modelRenderer.queue(this); //queue even if _model is null (since cleanup is a bit tricky)
    }
  }
  DataEventListener _initDataListener() {
    if (_dataListener == null) {
      _dataListener = (event) {
        switch (event.type) {
          case 'multiple':
            (node as SelectElement).multiple = (_model as Selection).multiple;
            sendEvent(new ViewEvent("render")); //send it since the look might be changed
            return; //no need to rerender
          case 'select':
            if (_modelSelUpdating)
              return;
            if (_model is ListModel) { //not easy/worth to optimize handling of TreeModel
              final HTMLOptionsCollection options = (node as SelectElement).options;
              final ListModel<T> model = _model as ListModel;
              final Selection<T> selmodel = _model as Selection;
              final bool multiple = selmodel.multiple;
              for (int i = 0, len = model.length; i < len; ++i) {
                final bool seled = (options[i] as OptionElement).selected = selmodel.isSelected(model[i]);
                if (!multiple && seled)
                  return; //done
              }
              return;
            }
        }

        modelRenderer.queue(this);
      };
    }
    return _dataListener;
  }

  /** Returns the renderer used to render the given model ([model]), or null
   * if the default implementation is preferred.
   *
   * The default implementation converts the given data to a string directly.
   */
  StringRenderer get renderer => _renderer;
  /** Sets the renderer used to render the given model ([model]).
   * If null, the default implementation is used.
   */
  void set renderer(StringRenderer renderer) {
    if (_renderer !== renderer) {
      _renderer = renderer;
      if (_model != null)
        modelRenderer.queue(this);
    }
  }

  /** callback by [modelRenderer] to render the model into views.
   */
  void renderModel_() {
    //Note: when this method is called, _model might be null
    if (browser.msie) { //IE/FF doesn't handle innerHTML well
      invalidate(true);
    } else {
      _renderInner();
      sendEvent(new ViewEvent("render"));
    }
  }
  static StringRenderer _defRenderer() {
    if (_$defRenderer == null)
      _$defRenderer = (RenderContext context) 
        => HTMLFragment.getHTML(context.data, false); //handles TreeNode/Map; don't encode
    return _$defRenderer;
  }
  static StringRenderer _$defRenderer;

  //@Override
  void mount_() {
    super.mount_();

    node.on.change.add(_onChange = (e) {
      final List<T> selValues = new List();
      int selIndex = -1;
      if (_model != null) {
        final SelectElement n = node;
        selIndex = n.selectedIndex;
        final ListModel model = _model is ListModel ? _model: null;
        if ((_model as Selection).multiple) {
          for (OptionElement opt in n.options) {
            if (opt.selected) {
              if (model != null) {
                selValues.add(model[opt.index]);
              } else {
                selValues.add(_treeValueOf(opt));
              }
            }
          }
        } else {
          if (selIndex >= 0) {
            if (model != null) {
              selValues.add(model[selIndex]);
            } else {
              selValues.add(_treeValueOf(n.options[selIndex]));
            }
          }
        }

        _modelSelUpdating = true;
        try {
          (_model as Selection).selection = selValues;
        } finally {
          _modelSelUpdating = false;
        }
      }

      sendEvent(new SelectEvent(selValues, selIndex));
    });
  }
  void unmount_() {
    node.on.change.remove(_onChange);
    super.unmount_();
  }

  //@Override
  void domAttrs_(StringBuffer out, [DOMAttrsCtrl ctrl]) {
    out.add(' size="').add(rows).add('"');
    if (disabled)
      out.add(' disabled');
    if (autofocus)
      out.add(' autofocus');
    if (_model != null && (_model as Selection).multiple)
      out.add(' multiple="multiple"');
    super.domAttrs_(out, ctrl);
  }
  //@Override
  void domInner_(StringBuffer out) {
    modelRenderer.queue(this);
      //defer to renderModel_ so _renderInner will be called only once
  }

  void _renderInner() {
    if (_model == null) {
      node.innerHTML = "";
      return;
    }

    final StringBuffer out = new StringBuffer();
    if (_model is ListModel) {
      final StringRenderer renderer =
        _renderer != null ? _renderer: _defRenderer();
      final ListModel<T> model = _model;
      final Selection<T> selmodel = _model as Selection;
      final bool multiple = selmodel.multiple;
      for (int i = 0, len = model.length; i < len; ++i) {
        final obj = model[i];
        final bool selected = selmodel.isSelected(obj);
        final bool disabled = _model is Disables && (_model as Disables).isDisabled(obj);
        out.add('<option');
        _renderAttrs(out, selected, disabled);
        out.add('>')
          .add(XMLUtil.encode(renderer(
            new RenderContext(this, _model, obj, selected, disabled, i))))
          .add('</option>');
        //Note: Firefox doesn't support <option label="xx">
      }
    } else {
      final TreeModel model = _model;
      if (model.root != null)
        _renderTree(out, model,
          _renderer != null ? _renderer: _defRenderer(), model.root, -1);
    }

    //Update DOM tree
    node.innerHTML = out.toString();
    if ((_model as Selection).isSelectionEmpty())
      (node as SelectElement).selectedIndex = -1;
  }
  void _renderTree(StringBuffer out, TreeModel<T> model,
  StringRenderer renderer, var node, int parentIndex) {
    final Selection<T> selmodel = _model as Selection;
    final bool multiple = selmodel.multiple;
    for (int i = 0, len = model.getChildCount(node); i < len; ++i) {
      final T child = model.getChild(node, i);
      final bool selected = selmodel.isSelected(child);
      final bool disabled = _model is Disables && (_model as Disables).isDisabled(child);
      final String label = XMLUtil.encode(renderer(
        new RenderContext(this, _model, child, selected, disabled, i)));
      if (model.isLeaf(child)) {
        out.add('<option');
        _renderAttrs(out, selected, disabled);

        //store the path in value
        out.add(' value="');
        if (parentIndex >= 0)
          out.add(parentIndex).add('.');
        out.add(i).add('">').add(label).add('</option>');
      } else {
        if (parentIndex >= 0)
          throw new UIException("Only two levels allowed, $model");

        out.add('<optgroup');
        _renderAttrs(out, selected, disabled);
        out.add(' label="').add(label).add('">');

        _renderTree(out, model, renderer, child, i);

        out.add('</optgroup>');
      }
    }
  }
  T _treeValueOf(OptionElement option) {
    final List<int> path = new List();
    for (final String v in option.value.split('.'))
      path.add(parseInt(v));

    final TreeModel<T> model = _model;
    return model.getChildAt(path);
  }
  static void _renderAttrs(StringBuffer out, bool selected, bool disabled) {
    if (selected)
      out.add(' selected');
    if (disabled)
      out.add(' disabled');
  }

  //@Override
  /** Returns the HTML tag's name representing this view.
   *
   * Default: `select`.
   */
  String get domTag_ => "select";
  //@Override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isViewGroup() => false;
}
