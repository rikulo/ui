//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends TextView {
  String _type = "button";
  bool _disabled = false, _autofocus = false;

  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  Button([String text]): super(text);
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  Button.fromHTML(String html): super.fromHTML(html);

  //@Override
  String get className => "Button"; //TODO: replace with reflection if Dart supports it

  /** Returns the button type.
   *
   * Default: "button".
   */
  String get type => _type;
  /** Sets the button type.
   *
   * + [type] can be either `button`, `submit` or `reset`.
   */
  void set type(String type) {
    _type = type == null || type.isEmpty() ? "button": type;

    if (inDocument)
      node.$dom_setAttribute('type', _type); //Chrome's type can't be assigned directly
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
      (node as ButtonElement).disabled = _disabled;
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
      (node as ButtonElement).focus();
  }

  void domAttrs_(StringBuffer out, [DOMAttrsCtrl ctrl]) {
    out.add(' type="').add(type).add('"');
    if (disabled)
      out.add(' disabled');
    if (autofocus)
      out.add(' autofocus');
    super.domAttrs_(out, ctrl);
  }
  /** Returns the HTML tag's name representing this widget.
   *
   * Default: `button`.
   */
  String get domTag_ => "button";
}
