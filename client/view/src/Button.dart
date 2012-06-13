//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends TextView {
  String _type = "button";
  bool _disabled = false, _autofocus = false;

  Button([String text="", String html=""]):
  super(text, html) {
  }

  //@Override
  String get className() => "Button"; //TODO: replace with reflection if Dart supports it

  /** Returns the button type.
   *
   * Default: "button".
   */
  String get type() => _type;
  /** Sets the button type.
   *
   * + [type] can be either `button`, `submit` or `reset`.
   */
  void set type(String type) {
    _type = type == null || type.isEmpty() ? "button": type;
    ButtonElement n = node;
    if (n != null)
      n.$dom_setAttribute('type', _type); //Chrome's type can't be assigned directly
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
    final ButtonElement n = node;
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
      final ButtonElement n = node;
      if (n != null)
        n.focus();
    }
  }

  void domAttrs_(StringBuffer out,
  [bool noId=false, bool noStyle=false, bool noClass=false]) {
    out.add(' type="').add(type).add('"');
    if (disabled)
      out.add(' disabled="disabled"');
    if (autofocus)
      out.add(' autofocus="autofocus"');
    super.domAttrs_(out, noId, noStyle, noClass);
  }
  /** Returns the HTML tag's name representing this widget.
   *
   * Default: `button`.
   */
  String get domTag_() => "button";

  /** Returns whether this view allows any child views.
   *
   * Default: false.
   */
  bool isChildable_() => false;
}
