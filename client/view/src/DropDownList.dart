//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  4:08:37 PM
// Author: tomyeh

/** Renders the given data for the given [DropDownList].
 */
typedef String DropDownListRenderer(
  DropDownList ddlist, var data, bool selected, bool disabled, int index);

/**
 * Represents a view that allows the user to select a single item
 * from a drop-down list.
 *
 * ##Events##
 *
 * + select: an instance of [SelectEvent] indicates the selected item has been changed.
 * Notice that [SelectEvent.selectedItems] is always null. Use [SelectEvent.selectedValues]
 * instead.
 */
class DropDownList<E> extends View {
  DataModel _model;
  DataEventListener _dataListener;
  DropDownListRenderer _renderer;
  bool _rendering = false, //whether it's rendering model
    _modelUpdating = false; //whether it's updating model (such as selection)
  bool _disabled = false, _autofocus = false;

  DropDownList([DataModel model, DropDownListRenderer renderer]) {
    _renderer = renderer;
    this.model = model;
  }

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled() => _disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    _disabled = disabled;

    if (inDocument) {
      final SelectElement n = node;
      n.disabled = _disabled;
    }
  }

  /** Returns whether this button should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus() => _autofocus;
  /** Sets whether this button should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    _autofocus = autofocus;
    if (autofocus && inDocument) {
      final SelectElement n = node;
      n.focus();
    }
  }

  //@Override
  String get className() => "DropDownList"; //TODO: replace with reflection if Dart supports it

  /** Returns the model.
   */
  DataModel get model() => _model;
  /** Sets the model.
   * The model must be an instance of [ListModel] or [TreeModel].
   *
   * ##Note of Using [TreeModel]##
   *
   * + The non-leaf node ([TreeModel.isLeaf] is false) can't be selected.
   * + [TreeModel.root] won't be rendered (so it can be anything)
   * + Only `root`'s children and grand-children nodes will be rendered.
   * In other words, it renders only two levels of nodes.
   */
  void set model(DataModel model) {
    if (model !== null) {
      if (model is! Selection)
        throw new UIException("Selection required, $model");
      if (model is! ListModel && model is! TreeModel)
        throw new UIException("Only ListModel or TreeModel allowed, not $model");
    }

    if (_model !== model) { //Note: it is not !=
      if (_model !== null)
        _model.on.all.remove(_dataListener);

      _model = model;

      if (_model !== null) {
        _model.on.all.add(_initDataListener());

        if (inDocument) {
          final SelectElement n = node;
          n.multiple = _cast(_model).multiple;
        }
      }

      modelRenderer.queue(this); //queue even if _model is null (since cleanup is a bit tricky)
    }
  }
  static _cast(var v) => v; //TODO: replace with 'as' when Dart supports it
  DataEventListener _initDataListener() {
    if (_dataListener === null) {
      _dataListener = (event) {
        if (!_modelUpdating)
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
  DropDownListRenderer get renderer() => _renderer;
  /** Sets the renderer used to render the given model ([model]).
   * If null, the default implementation is used.
   */
  void set renderer(DropDownListRenderer renderer) {
    if (_renderer !== renderer) {
      _renderer = renderer;
      if (_model !== null)
        modelRenderer.queue(this);
    }
  }

  /** callback by [modelRenderer] to render the model into views.
   */
  void renderModel_() {
    //Note: when this method is called, _model might be null
    _rendering = true;
    try {
      if (browser.msie) { //IE/FF doesn't handle innerHTML well
        invalidate(true);
      } else {
        final StringBuffer out = new StringBuffer();
        domInner_(out);
        node.innerHTML = out.toString();
        _fixIndex();
      }
    } finally {
      _rendering = false;
    }
  }
  static DropDownListRenderer _defListRenderer() {
    if (_$defListRenderer === null)
      _$defListRenderer = (DropDownList ddlist, var data, bool selected, bool disabled, int index)
        => "$data";
    return _$defListRenderer;
  }
  static DropDownListRenderer _$defListRenderer;
  static DropDownListRenderer _defTreeRenderer() {
    if (_$defTreeRenderer === null)
      _$defTreeRenderer = (DropDownList ddlist, var data, bool selected, bool disabled, int index)
        => data is TreeNode ? "${data.data}": "$data";
    return _$defTreeRenderer;
  }
  static DropDownListRenderer _$defTreeRenderer;

  //@Override
  void enterDocument_() {
    super.enterDocument_();

    node.on.change.add((e) {
      final List<E> selValues = new List();
      if (_model !== null) {
        final SelectElement n = node;
        if (_cast(_model).multiple) {
          for (OptionElement opt in n.selectedOptions) {
            if (_model is ListModel) {
              final ListModel model = _model;
              selValues.add(model[opt.index]);
            } else {
              selValues.add(_treeValueOf(opt));
            }
          }
        } else {
          final int i = n.selectedIndex;
          if (i >= 0) {
            if (_model is ListModel) {
              final ListModel model = _model;
              selValues.add(model[i]);
            } else {
              selValues.add(_treeValueOf(n.options[i]));
            }
          }
        }

        _modelUpdating = true;
        try {
          _cast(_model).selection = selValues;
        } finally {
          _modelUpdating = false;
        }
      }

      sendEvent(new SelectEvent(this, null, selValues));
    });

     _fixIndex();
  }
  void _fixIndex() { //it assumes inDocument
    if (_model !== null && _cast(_model).isSelectionEmpty()) {
      final SelectElement n = node;
      n.selectedIndex = -1;
    }
  }

  //@Override
  void domAttrs_(StringBuffer out,
  [bool noId=false, bool noStyle=false, bool noClass=false]) {
    if (disabled)
      out.add(' disabled="disabled"');
    if (autofocus)
      out.add(' autofocus="autofocus"');
    if (_model !== null && _cast(_model).multiple)
      out.add(' multiple="multiple" size="1"');
    super.domAttrs_(out, noId, noStyle, noClass);
  }
  //@Override
  void domInner_(StringBuffer out) {
    if (_model === null)
      return; //nothing to do

    if (_model is ListModel) {
      final DropDownListRenderer renderer =
        _renderer !== null ? _renderer: _defListRenderer();
      final ListModel model = _model;
      for (int j = 0, len = model.length; j < len; ++j) {
        final obj = model[j];
        final bool selected = _cast(_model).isSelected(obj);
        final bool disabled = _model is Disables && _cast(_model).isDisabled(obj);
        out.add('<option');
        _renderAttrs(out, selected, disabled);
        out.add('>')
          .add(StringUtil.encodeXML(renderer(this, obj, selected, disabled, j)))
          .add('</option>');
        //Note: Firefox doesn't support <option label="xx">
      }
    } else {
      final TreeModel model = _model;
      _renderTree(out, model,
        _renderer !== null ? _renderer: _defTreeRenderer(), model.root, -1);
    }
  }
  void _renderTree(StringBuffer out, TreeModel<E> model,
  DropDownListRenderer renderer, var node, int parentIndex) {
    for (int j = 0, len = model.getChildCount(node); j < len; ++j) {
      final E child = model.getChild(node, j);
      final bool selected = _cast(_model).isSelected(child);
      final bool disabled = _model is Disables && _cast(_model).isDisabled(child);
      final String label =
        StringUtil.encodeXML(renderer(this, child, selected, disabled, j));
      if (model.isLeaf(child)) {
        out.add('<option');
        _renderAttrs(out, selected, disabled);

        //store the path in value
        out.add(' value="');
        if (parentIndex >= 0)
          out.add(parentIndex).add('.');
        out.add(j).add('">').add(label).add('</option>');
      } else {
        if (parentIndex >= 0)
          throw new UIException("Only two levels allowed, $model");

        out.add('<optgroup');
        _renderAttrs(out, selected, disabled);
        out.add(' label="').add(label).add('">');

        _renderTree(out, model, renderer, child, j);

        out.add('</optgroup>');
      }
    }
  }
  E _treeValueOf(OptionElement option) {
    final List<int> path = new List();
    for (final String v in option.value.split('.'))
      path.add(Math.parseInt(v));

    final TreeModel<E> model = _model;
    return model.getChildAt(path);
  }
  static void _renderAttrs(StringBuffer out, bool selected, bool disabled) {
    if (selected)
      out.add(' selected="selected"');
    if (disabled)
      out.add(' disabled="disabled"');
  }

  //@Override
  /** Returns the HTML tag's name representing this view.
   *
   * Default: `select`.
   */
  String get domTag_() => "select";
  //@Override
  /** Returns whether this view allows any child views.
   *
   * Default: false.
   */
  bool isChildable_() => false;
  //@Override
  int measureWidth_(MeasureContext mctx)
  => layoutManager.measureWidthByContent(mctx, this, true);
  //@Override
  int measureHeight_(MeasureContext mctx)
  => layoutManager.measureHeightByContent(mctx, this, true);
}
