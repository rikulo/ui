//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Oct 26, 2012  4:15:41 PM
// Author: tomyeh
part of rikulo_view;

/** A multiline input box.
 *
 * For single line input box, please use [TextBox].
 */
class MultilineBox extends View implements Input<String> {
  MultilineBox([String value]) {
    if (value != null && !value.isEmpty)
      this.value = value;
  }

  //@override
  String get className => "MultilineBox"; //TODO: replace with reflection if Dart supports it

  /** Returns the TEXTAREA element in this view.
   */
  TextAreaElement get inputNode => node;

  /** Returns the name of the input element of this view.
   */
  String get name => inputNode.name;
  /** Sets the name of the input element of this view.
   */
  void set name(String name) {
    inputNode.name = name != null ? name: "";
  }

  /** Returns the value of this text box.
   */
  String get value => inputNode.value;
  /** Sets the value of this text box.
   *
   * Default: an empty string.
   */
  void set value(String value) {
    inputNode.value = value != null ? value: "";
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

  /** Returns whether this input should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus => inputNode.autofocus;
  /** Sets whether this input should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    final inp = inputNode..autofocus = autofocus;
    if (autofocus && inDocument)
      inp.focus();
  }

  /** Returns a short hint that describes this text box.
   * The hint is displayed in the text box when it is empty, and
   * disappears when it gets focus.
   *
   * Default: an empty string.
   */
  String get placeholder => inputNode.placeholder;
  /** Returns a short hint that describes this text box.
   *
   * Default: an empty string.
   */
  void set placeholder(String placeholder) {
    inputNode.placeholder = placeholder;
  }

  /** Returns the height of this text box in number of lines.
   */
  int get rows => inputNode.rows;
  /** Sets the height of this text box in number of lines.
   */
  void set rows(int rows) {
    inputNode.rows = rows;
  }
  /** Returns the width of this text box in average character width.
   */
  int get cols => inputNode.cols;
  /** Sets the width of this text box in average character width.
   */
  void set cols(int cols) {
    inputNode.cols = cols;
  }

  /** Returns the maximal allowed number of characters.
   */
  int get maxLength => inputNode.maxLength;
  /** Sets the maximal allowed number of characters.
   */
  void set maxLength(int maxLength) {
    inputNode.maxLength = maxLength;
  }

  //@override
  Element render_() => new Element.tag("textarea");

  //@override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool get isViewGroup => false;
  //@override
  String toString() => "$className('$value')";
}
