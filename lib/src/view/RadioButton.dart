//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Oct 27, 2012 11:14:11 AM
// Author: tomyeh

/**
 * A radio button. The radio buttons are grouped by [name]
 */
class RadioButton extends CheckBox {
  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  RadioButton([String text, bool value]): super(text, value);
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  RadioButton.fromHTML(String html, [bool value]): super.fromHTML(html, value);

  //@override
  String get className => "RadioButton"; //TODO: replace with reflection if Dart supports it
  //@override
  String get type => "radio";
}
