//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:02:21 PM
// Author: tomyeh

/**
 * A check box is a two-state button.
 *
 * ##Events##
 *
 * + check: an instance of [CheckEvent] indicates the check state is changed.
 */
class CheckBox<E> extends TextView {
  /** The value associated with this view.
   *
   * If it is used with a model (such as [RadioGroup.model]), the value is
   * assigned with the data from the model. Furthermore, you can't change it.
   *
   * If it is *not* used with a model, you can assign any value you like.
   */
  E value;
  bool _checked = false, _disabled = false, _autofocus = false;
  EventListener _onInputClick;

  CheckBox([String text="", String html="", bool checked=false, E this.value]):
  super(text, html), _checked = checked {
    _onInputClick = (Event event) {
      final InputElement n = event.srcElement;
      final bool cked = n.checked;
      if (_checked != cked) {
        _checked = cked;
        onCheck_();
      }
    };
  }

  //@Override
  String get className() => "CheckBox"; //TODO: replace with reflection if Dart supports it

  /** Returns whether it is checked.
   *
   * Default: false.
   */
  bool get checked() => _checked;
  /** Sets whether it is checked.
   */
  void set checked(bool checked) {
    _checked = checked;
    InputElement n = inputNode;
    if (n != null)
      n.checked = _checked;
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
    InputElement n = inputNode;
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
      InputElement n = inputNode;
      if (n != null)
        n.focus();
    }
  }
  /** Returns the INPUT element in this view.
   */
  InputElement get inputNode() => getNode("inp");

  /** Callback when user's click changes [checked].
   */
  void onCheck_() {
    sendEvent(new CheckEvent(this, _checked));
  }

  //@Override
  void enterDocument_() {
    super.enterDocument_();

    inputNode.on.click.add(_onInputClick);
  }
  //@Override
  void exitDocument_() {
    inputNode.on.click.remove(_onInputClick);

    super.exitDocument_();
  }
  //@Override
  void updateInner_() {
    final Element n = node.query("label");
    if (n != null)
      n.innerHTML = innerHTML_;
  }
  //@Override
  void domInner_(StringBuffer out) {
    out.add('<input type="').add(domInputType_)
      .add('" id="').add(uuid).add('-inp"');

    String s = domInputName_;
    if (s != null)
      out.add(' name="').add(s).add('"');
    if (_checked)
      out.add(' checked="checked"');
    if (_disabled)
      out.add(' disabled="disabled"');
    if (_autofocus)
      out.add(' autofocus="autofocus"');
    out.add('/><label for="').add(uuid).add('-inp" class="')
      .add(viewConfig.classPrefix).add('inner">').add(innerHTML_).add('</label>');
  }
  /** Returns the input's type.
   *
   * Default: checkbox.
   */
  String get domInputType_() => "checkbox";
  /** Returns the input's name.
   *
   * Default: null (means ignored)
   */
  String get domInputName_() => null;
  String toString() => "$className('$text$html', $checked)";
}
