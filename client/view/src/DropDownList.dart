//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 13, 2012  4:08:37 PM
// Author: tomyeh

/** Renders the given data for the given [DropDownList].
 */
typedef String DropDownListRenderer(DropDownList ddlist, var data, bool selected, int index);

/**
 * Represents a view that allows the user to select a single item
 * from a drop-down list.
 */
class DropDownList<E> extends View {
  var _model, _dataListener;
  DropDownListRenderer _renderer;
  bool _rendering = false, //whether it's rendering model
    _modelUpdating = false; //whether it's updating model (such as selection)
  bool _disabled = false, _autofocus = false;

  DropDownList([var model]) {
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
    final SelectElement n = node;
    if (n != null)
      n.disabled = _disabled;
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
    if (autofocus) {
      final SelectElement n = node;
      if (n != null)
        n.focus();
    }
  }

  //@Override
  String get className() => "DropDownList"; //TODO: replace with reflection if Dart supports it

  /** Returns the model.
   */
  get model() => _model;
  /** Sets the model.
   * The model must be an instance of [ListModel] or [TreeModel].
   */
  void set model(var model) {
    if (model !== null && model is! Selection)
      throw new UIException("Selection required, $model");

    if (_model !== model) { //Note: it is not !=
      if (_model is ListModel)
        _model.removeListDataListener(_dataListener);
      else if (_model is TreeModel)
        _model.removeTreeDataListener(_dataListener);

      _model = model;

      if (_model !== null) {
        _initDataListener();
        if (_model is ListModel)
          _model.addListDataListener(_dataListener);
        else if (_model is TreeModel)
          _model.addTreeDataListener(_dataListener);
        else
          throw new UIException("Only ListModel or TreeModel allowed, not $_model");

        final SelectElement n = node;
        if (n !== null)
          n.multiple = _model.multiple;
      }

      modelRenderer.queue(this); //queue even if _model is null (since cleanup is a bit tricky)
    }
  }
  void _initDataListener() {
    if (_dataListener === null) {
      _dataListener = (ListDataEvent event) {
        if (!_modelUpdating)
          modelRenderer.queue(this);
      };
    }
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
  static DropDownListRenderer _defRenderer() {
    if (_$defRenderer === null)
      _$defRenderer = (DropDownList ddlist, var data, bool selected, int index) => "$data";
    return _$defRenderer;
  }
  static DropDownListRenderer _$defRenderer;

  //@Override
  void enterDocument_() {
    super.enterDocument_();

    node.on.change.add((e) {
      if (_model !== null) {
        final List<E> sel = new List();
        final SelectElement n = node;
        final int i = n.selectedIndex;
        if (i >= 0) {
          if (_model is ListModel) {
            final ListModel model = _model;
            sel.add( model[i]);
          } else {
            final TreeModel model = _model;
            //TODO
          }
        }

        _modelUpdating = true;
        try {
          _model.selection = sel;
        } finally {
          _modelUpdating = false;
        }
      }
    });

     _fixIndex();
  }
  void _fixIndex() { //it assumes inDocument
    if (_model !== null && _model.isSelectionEmpty()) {
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
    if (_model !== null && _model.multiple)
      out.add(' multiple="multiple"');
    super.domAttrs_(out, noId, noStyle, noClass);
  }
  //@Override
  void domInner_(StringBuffer out) {
    if (_model === null)
      return; //nothing to do

    final DropDownListRenderer renderer =
      _renderer !== null ? _renderer: _defRenderer();
    if (_model is ListModel) {
      final ListModel model = _model;
      for (int j = 0, len = model.length; j < len; ++j) {
        out.add('<option');
        final obj = model[j];
        final bool selected = _model.isSelected(obj);
        if (selected)
          out.add(' selected="selected"');
        out.add('>')
         .add(StringUtil.encodeXML(renderer(this, obj, selected, j)))
         .add('</option>');
         //Note: Firefox doesn't support <option label="xx">
      }
    } else {
      final TreeModel model = _model;
      //TODO
    }
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
