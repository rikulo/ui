//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:02:46 PM
// Author: tomyeh

/** Renders the given data for the given [RadioGroup].
 * The implementaiton shall instantiate a radio button ([RadioButton])
 * and, optionally, other views.
 * Then add it to [group] and insert it before [before], if any.
 *
 * Notice that the value of the radio button ([ButtonRadio.value]) will be
 * assigned with [data]. Thus, the application shall not change it.
 */
typedef RadioButton RadioGroupRenderer(RadioGroup group, View before, var data, bool selected, int index);

/**
 * A radio group.
 *
 * ##Events##
 *
 * + check: an instance of [CheckEvent] indicates the check state is changed.
 * Notice that [CheckEvent.target] is an instance of [RadioButton] that has been checked.
 */
class RadioGroup<E> extends View {
  RadioButton _selItem;
  ListModel<E> _model;
  ListDataListener _dataListener;
  RadioGroupRenderer _renderer;
  bool _rendering = false, //whether it's rendering model
    _modelUpdating = false; //whether it's updating model (such as selection)

  RadioGroup([ListModel<E> model]) {
    this.model = model;
  }

  //@Override
  String get className() => "RadioGroup"; //TODO: replace with reflection if Dart supports it

  //Model//
  /** Returns the model.
   */
  ListModel<E> get model() => _model;
  /** Sets the model.
   */
  void set model(ListModel<E> model) {
    if (model !== null) {
      if (model is! Selection)
        throw new UIException("Selection required, $model");

      if (_model !== model) { //Note: it is not !=
        if (_model !== null)
          _model.removeListDataListener(_dataListener);

        _model = model;
        _model.addListDataListener(_initDataListener());
      }
      modelRenderer.queue(this); //queue for later operation (=> renderModel_)
    } else if (_model !== null) {
      _model.removeListDataListener(_dataListener);
      _model = null;
      children.clear();
    }
  }
  ListDataListener _initDataListener() {
    if (_dataListener === null) {
      _dataListener = (ListDataEvent event) {
        if (!_modelUpdating)
          modelRenderer.queue(this);
      };
    }
    return _dataListener;
  }
  /** Returns the renderer used to render the given model ([model]), or null
   * if the default implementation is preferred.
   *
   * The default implementation instantiates an instance of [RadioButton]
   * and assign the text by converting the given data to a string.
   */
  RadioGroupRenderer get renderer() => _renderer;
  /** Sets the renderer used to render the given model ([model]).
   * If null, the default implementation is used.
   */
  void set renderer(RadioGroupRenderer renderer) {
    if (_renderer !== renderer) {
      _renderer = renderer;
      if (_model !== null)
        modelRenderer.queue(this);
    }
  }
  /** callback by [modelRenderer] to render the model into views.
   */
  void renderModel_() {
    if (_model !== null) {
      _rendering = true;
      try {
        children.clear();

        final RadioGroupRenderer renderer =
          _renderer !== null ? _renderer: _defRenderer();
        for (int j = 0, len = _model.length; j < len; ++j) {
          final obj = _model[j];
          renderer(this, null, obj, _cast(_model).isSelected(obj), j)
            .value = obj;
        }
      } finally {
        _rendering = false;
      }

      requestLayout(true);
    }
  }
  static _cast(var v) => v; //TODO: replace with 'as' when Dart supports it
  static RadioGroupRenderer _defRenderer() {
    if (_$defRenderer === null)
      _$defRenderer = (RadioGroup group, View before, var data, bool selected, int index) {
        final btn = new RadioButton("$data");
        btn.checked = selected;
        group.addChild(btn, before);
        return btn;
      };
    return _$defRenderer;
  }
  static RadioGroupRenderer _$defRenderer;

  /** Returns the selected radio button, or null if none is selected.
   */
  RadioButton get selectedItem() => _selItem;
  //@Override
  Set<RadioButton> get selectedItems() {
    final Set<RadioButton> sels = new Set();
    if (_selItem !== null)
      sels.add(_selItem);
    return sels;
  }

  /** Handles the selected item when a radio button's check state is changed.
   */
  void _updateSelected(RadioButton changed, bool checked) { //called from RadioButton
    if (checked) {
      if (_selItem !== null)
        _selItem._setChecked(false, false);
      _selItem = changed;
    } else if (_selItem === changed) {
      _selItem = null;
    }

    if (!_rendering && _model !== null) {
      final List<E> sel = new List();
      if (_selItem !== null)
          sel.add(_selItem.value);

      _modelUpdating = true;
      try {
        _cast(_model).selection = sel;
      } finally {
        _modelUpdating = false;
      }
    }
  }
}
