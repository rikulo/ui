//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
part of rikulo_view;

/** A button.
 */
class Button extends TextView {
  /** Instantiates with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  Button([String text]): super(text);
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notice it must be a valid HTML fragment. Otherwise, the result is
   * unpredictable.
   */
  Button.fromHtml(String html): super.fromHtml(html);

  /** Returns the INPUT element in this view.
   */
  ButtonElement get _buttonNode => node;

  /** Returns the button type.
   *
   * Default: "button".
   */
  String get type => _buttonNode.type;
  /** Sets the button type.
   *
   * + [type] can be either `button`, `submit` or `reset`.
   */
  void set type(String type) {
    node.$dom_setAttribute('type', type == null || type.isEmpty ? "button": type);
      //Chrome's type can't be assigned directly
  }
  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled => _buttonNode.disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    _buttonNode.disabled = _b(disabled);
  }

  /** Returns whether this button should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus => _buttonNode.autofocus;
  /** Sets whether this button should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    final btn = _buttonNode..autofocus = _b(autofocus);
    if (autofocus && inDocument)
      btn.focus();
  }

  //@override
  Element render_()
  => new Element.html("<button>$encodedText</button>");
}
