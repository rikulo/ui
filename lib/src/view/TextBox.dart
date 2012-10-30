//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, May 22, 2012 10:46:08 AM
// Author: tomyeh

/**
 * A text box to get input from the user or to to display text.
 *
 * For multiline input, please use [MultilineBox] instead.
 */
class TextBox extends View implements Input<String> {
  TextBox([String value, String type]) {
    if (value != null && !value.isEmpty)
      this.value = value;
    if (type != null && !type.isEmpty)
      this.type = type;
  }

  //@override
  String get className => "TextBox"; //TODO: replace with reflection if Dart supports it

  /** Returns the INPUT element in this view.
   */
  InputElement get inputNode => node;

  /** Returns the name of the input element of this view.
   */
  String get name => inputNode.name;
  /** Sets the name of the input element of this view.
   */
  void set name(String name) {
    inputNode.name = name;
  }

  /** Returns the type of data being placed in this text box.
   */
  String get type => inputNode.type;
  /** Sets the type of data being placed in this text box.
   *
   * Default: text.
   *
   * Allowed values:
   * 
   * + text - plain text
   * + password - 
   * + number - 
   * + color - 
   * + range - 
   * + date - 
   * + url - 
   * + tel - 
   * + email - 
   */
  void set type(String type) {
    inputNode.type = type;
  }

  /** Returns the value of this text box.
   */
  String get value => inputNode.value;
  /** Sets the value of this text box.
   *
   * Default: an empty string.
   */
  void set value(String value) {
    inputNode.value = value;
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

  /** Returns whether to predict the value based on ealier typed value.
   * When a user starts to type in,
   * a list of options will be  displayed to fill the box, based on
   * ealier typed values
   *
   * Default: true (enabled).
   */
  bool get autocomplete => inputNode.autocomplete == "on";
  /** Sets whether to predict the value based on ealier typed value.
   */
  void set autocomplete(bool autocomplete) {
    inputNode.autocomplete = autocomplete ? "on": "off";
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

  /** Returns the width of this text box in average character width.
   */
  int get cols => inputNode.size;
  /** Sets the width of this text box in average character width.
   */
  void set cols(int cols) {
    inputNode.size = cols;
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
  Element render_() => new Element.tag("input");

  //@override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isViewGroup() => false;
  //@override
  String toString() => "$className('$value')";
}
