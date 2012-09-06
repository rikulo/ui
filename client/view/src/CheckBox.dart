//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:02:21 PM
// Author: tomyeh

/**
 * A check box is a two-state button.
 *
 * ##Events
 *
 * + change: an instance of [ChangeEvent] indicates the check state is changed.
 */
class CheckBox extends TextView implements Input<bool> {
  bool _value = false, _disabled = false, _autofocus = false;
  EventListener _onInputClick;

  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  CheckBox([String text, bool value]): super(text) {
    _value = value != null && value;
  }
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  CheckBox.fromHTML(String html, [bool value]): super.fromHTML(html) {
    _value = value != null && value;
  }

  //@Override
  String get className => "CheckBox"; //TODO: replace with reflection if Dart supports it

  /** Returns whether it is value.
   *
   * Default: false.
   */
  bool get value => _value;
  /** Sets whether it is value.
   */
  void set value(bool value) {
    _value = value;

    if (inDocument)
      inputNode.checked = _value;
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
      inputNode.disabled = _disabled;
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
      inputNode.focus();
  }
  /** Returns the INPUT element in this view.
   */
  InputElement get inputNode => getNode("inp");

  /** Callback when the user changes [value].
   */
  void onChange_() {
    sendEvent(new ChangeEvent(_value));
  }

  //@Override
  void mount_() {
    super.mount_();

    inputNode.on.click.add(_onInputClick = (Event event) {
      final InputElement n = event.srcElement;
      final bool cked = n.checked;
      if (_value != cked) {
        _value = cked;
        onChange_();
      }
    });
  }
  //@Override
  void unmount_() {
    inputNode.on.click.remove(_onInputClick);

    super.unmount_();
  }
  //@Override
  void updateInner_() {
    final Element n = node.query("label");
    if (n != null)
      n.innerHTML = innerHTML_;
  }
  //@Override
  void domInner_(StringBuffer out) {
    out.add('<input type="checkbox" id="').add(uuid).add('-inp"');

    if (_value)
      out.add(' checked');
    if (_disabled)
      out.add(' disabled');
    if (_autofocus)
      out.add(' autofocus');
    out.add('/><label for="').add(uuid).add('-inp" class="')
      .add(viewConfig.classPrefix).add('inner">').add(innerHTML_).add('</label>');
  }
  String toString() => "$className('$text$html', $value)";
}
