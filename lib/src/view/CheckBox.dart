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
  bool _value; //we need it to detect if the value is changed (so onchange shall be fired)

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

  //@override
  String get className => "CheckBox"; //TODO: replace with reflection if Dart supports it

  /** Returns whether it is value.
   *
   * Default: false.
   */
  bool get value => _value;
  /** Sets whether it is value.
   */
  void set value(bool value) {
    _value = inputNode.checked = value;
  }

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled => inputNode.disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    inputNode.disabled = disabled;
  }

  /** Returns whether this button should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus => inputNode.autofocus;
  /** Sets whether this button should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    final inp = inputNode..autofocus = autofocus;
    if (autofocus && inDocument)
      inp.focus();
  }
  /** Returns the INPUT element in this view.
   */
  InputElement get inputNode => getNode("inp");

  /** Callback when the user changes [value].
   */
  void onChange_() {
    sendEvent(new ChangeEvent(_value));
  }

  //@override
  void updateInner_([String html]) {
    if (html == null) html = "";
    node.query("label").innerHTML = "$encodedText$html";
  }
  //@override
  Element render_() {
    final out = new StringBuffer("<div>");
    out.add('<input type="checkbox" id="').add(uuid).add('-inp"');

    if (_value)
      out.add(' checked');

    final node = new Element.html(
      out.add('/><label for="').add(uuid).add('-inp" class="')
        .add(viewConfig.classPrefix).add('inner">').add(encodedText).add('</label>')
        .add("</div>").toString());

    //note: we can't use getNode here since [node] is not available yet
    node.query("#$uuid-inp").on.click.add((Event event) {
      final InputElement n = event.srcElement;
      final bool cked = n.checked;
      if (_value != cked) {
        _value = cked;
        onChange_();
      }
    });
    return node;
  }
  String toString() => "$className($text, $value)";
}
