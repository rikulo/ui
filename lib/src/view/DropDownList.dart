//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  4:08:37 PM
// Author: tomyeh
part of rikulo_view;

/**
 * A drop-down list that the user can select an item from it.
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
  Renderer _renderer;
  bool _modelSelUpdating = false; //whether it's updating model's selection

  /** Constructor.
   */
  DropDownList({DataModel model, Renderer renderer}) {
    _renderer = renderer;
    this.model = model;
  }

  /** Returns the SELECT element in this view.
   */
  SelectElement get _selectNode => node;

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled => _selectNode.disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    _selectNode.disabled = _b(disabled);
  }

  /** Returns whether this button should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus => _selectNode.autofocus;
  /** Sets whether this button should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    final seln = _selectNode..autofocus = _b(autofocus);
    if (autofocus && inDocument)
      seln.focus();
  }

  /** Returns the number of visible rows.
   *
   * Default: 1
   */
  int get rows => _selectNode.size;
  /** Sets the number of visible rows.
   */
  void set rows(int rows) {
    _selectNode.size = rows;
  }

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
        throw new UiError("Selection required, $model");
      if (model is! ListModel && model is! TreeModel)
        throw new UiError("Only ListModel or TreeModel allowed, not $model");
    }

    if (!identical(_model, model)) { //Note: it is not !=
      if (_model != null)
        _model.on.all.remove(_dataListener);

      _model = model;

      if (_model != null) {
        _model.on.all.add(_initDataListener());
        _selectNode.multiple = (_model as Selection).multiple;
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
              final options = (node as SelectElement).options;
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
            break;
        }

        modelRenderer.queue(this);
      };
    }
    return _dataListener;
  }

  /** Returns the renderer used to render the given model ([model]), or null
   * if the default implementation is preferred.
   *
   * The default implementation converts the given data to OptionElement directly.
   */
  Renderer get renderer => _renderer;
  /** Sets the renderer used to render the given model ([model]).
   * If null, the default implementation is used.
   *
   * The renderer can return either a string or an instance of OptionElement.
   * Otherwise the result is unpredictable.
   */
  void set renderer(Renderer renderer) {
    if (!identical(_renderer, renderer)) {
      _renderer = renderer;
      if (_model != null)
        modelRenderer.queue(this);
    }
  }

  /** callback by [modelRenderer] to render the model into views.
   */
  void renderModel_() {
    //Note: when this method is called, _model might be null
    _renderOptions();
    sendEvent(new ViewEvent("render"));
  }
  static final Renderer _defRenderer = (ctx) => ctx.getDataAsString();

  //@override
  Element render_() {
    final node = new Element.tag("select");
    node.on.change.add((e) {
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
    return node;
  }

  void _renderOptions() {
    node.nodes.clear();
    if (_model == null)
      return;

    final renderer = _renderer != null ? _renderer: _defRenderer;
    if (_model is ListModel) {
      final ListModel<T> model = _model;
      final Selection<T> selmodel = _model as Selection;
      final multiple = selmodel.multiple;
      for (int i = 0, len = model.length; i < len; ++i) {
        final obj = model[i];
        final selected = selmodel.isSelected(obj);
        final disabled = _model is Disables && (_model as Disables).isDisabled(obj);
        var ret = renderer(new RenderContext(this, _model, obj, selected, disabled, i));
        if (ret == null) ret = "";
        OptionElement opt;
        if (ret is String)
          opt = new Element.html(
            '<option value="$i">${XmlUtil.encode(ret)}</option>');
          //Note: Firefox doesn't support <option label="xx">
        else if (ret is OptionElement)
          opt = ret;
        else
          throw new UiError("Neither String nor OptionElement, $ret");

        if (selected) opt.selected = true;
        if (disabled) opt.disabled = true;
        node.nodes.add(opt);
      }
    } else {
      final TreeModel model = _model;
      if (model.root != null)
        _renderTree(node, model, renderer, model.root, -1);
    }

    //Update DOM tree
    if ((_model as Selection).isSelectionEmpty)
      (node as SelectElement).selectedIndex = -1;
  }
  void _renderTree(Element parent, TreeModel<T> model,
  Renderer renderer, var parentData, int parentIndex) {
    final Selection<T> selmodel = _model as Selection;
    final bool multiple = selmodel.multiple;
    for (int i = 0, len = model.getChildCount(parentData); i < len; ++i) {
      final T child = model.getChild(parentData, i);
      final bool selected = selmodel.isSelected(child);
      final bool disabled = _model is Disables && (_model as Disables).isDisabled(child);
      var ret = renderer(new RenderContext(this, _model, child, selected, disabled, i));
      if (ret == null) ret = "";
      if (model.isLeaf(child)) {
        OptionElement opt;
        if (ret is String)
          opt = new Element.html('<option>${XmlUtil.encode(ret)}</option>');
          //Note: Firefox doesn't support <option label="xx">
        else if (ret is OptionElement)
          opt = ret;
        else
          throw new UiError("Neither String nor OptionElement, $ret");

        if (selected) opt.selected = true;
        if (disabled) opt.disabled = true;

        //store the path in value
        final out = new StringBuffer();
        if (parentIndex >= 0)
          out.add(parentIndex).add('.');
        opt.value = out.add(i).toString();

        parent.nodes.add(opt);
      } else {
        if (parentIndex >= 0)
          throw new UiError("Only two levels allowed, $model");

        OptGroupElement optg;
        if (ret is String)
          optg = new Element.html('<optgroup label="${XmlUtil.encode(ret)}"></optgroup>');
          //no matter what browser, it must be specified in 'label'
        else if (ret is OptGroupElement)
          optg = ret;
        else
          throw new UiError("Neither String nor OptGroupElement, $ret");

        if (disabled) optg.disabled = true;
        parent.nodes.add(optg);

        _renderTree(optg, model, renderer, child, i); //recursive
      }
    }
  }
  T _treeValueOf(OptionElement option) {
    final List<int> path = new List();
    for (final String v in option.value.split('.'))
      path.add(int.parse(v));

    final TreeModel<T> model = _model;
    return model.getChildAt(path);
  }
  static void _renderAttrs(StringBuffer out, bool selected, bool disabled) {
    if (selected)
      out.add(' selected');
    if (disabled)
      out.add(' disabled');
  }

  //@override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool get isViewGroup => false;
}
