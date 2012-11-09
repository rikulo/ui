//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:02:21 PM
// Author: tomyeh
part of rikulo_view;

/**
 * A check box is a two-state button.
 *
 * ##Events
 *
 * + change: an instance of [ChangeEvent] indicates the check state is changed.
 */
class CheckBox extends TextView implements Input<bool> {
  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  CheckBox([String text, bool value]): super(text) {
    if (value != null && value)
      this.value = true;
  }
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  CheckBox.fromHTML(String html, [bool value]): super.fromHTML(html) {
    if (value != null && value)
      this.value = true;
  }

  /** Returns the name of the input element of this view.
   */
  String get name => inputNode.name;
  /** Sets the name of the input element of this view.
   */
  void set name(String name) {
    inputNode.name = name != null ? name: "";
  }

  /** Returns whether it is value.
   *
   * Default: false.
   */
  bool get value => inputNode.checked;
  /** Sets whether it is value.
   */
  void set value(bool value) {
    inputNode.checked = value != null && value;
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

  //@override
  void updateInner_([String html]) {
    if (html == null) html = "";
    node.query("label").innerHTML = "$encodedText$html";
  }
  //@override
  Element render_()
  => new Element.html(
  '<div><input type="$type" id="$uuid-inp"/><label for="$uuid-inp" class="${viewConfig.classPrefix}inner"></label></div>');

  /** Returns the type of the INPUT element.
   */
  String get type => "checkbox";
  //@override
  String toString() => "$className($text, $value)";
}
