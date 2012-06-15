//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 19, 2012 12:10:33 PM
// Author: tomyeh

/**
 * Displays plain text or a fragment of HTML content to the user.
 *
 * Notice that there are two kinds of text: plain text and HTML fragment.
 * You can specify the normal text with [text], and the HTML fragment with [html].
 * If both are specified, [text] will be shown in front of [html].
 */
class TextView extends View {
  String _text, _html;

  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  TextView([String text]) {
    _text = text != null ? text: "";
    _html = "";
  }
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  TextView.html(String html) {
    _html = html != null ? html: "";
    _text = "";
  }

  //@Override
  String get className() => "TextView"; //TODO: replace with reflection if Dart supports it

  /** Returns the text.
   */
  String get text() => this._text;
  /** Sets the text.
   */
  void set text(String text) {
    _text = text != null ? text: "";
    updateInner_();
  }
  /** Returns the HTML text.
   */
  String get html() => this._html;
  /** Sets the HTML text.
   */
  void set html(String html) {
    _html = html != null ? html: "";
    updateInner_();
  }

  /** Called to update the DOM element, when the content of this view
   * is changed.
   *
   * Default: invoke [innerHTML_] to retrieve the content
   * and then update [node]'s innerHTML.
   */
  void updateInner_() {
    if (inDocument)
      node.innerHTML = innerHTML_;
  }
  /** Returns the HTML content.
   *
   * Default: it is the concatenation of [encodedText] and [html].
   */
  String get innerHTML_() {
    return "$encodedText$html";
  }
  /** Returns the encodes the text ([text]).
   *
   * Default: it encodes [text] by replacing linefeed with <br/>, if any.
   */
  String get encodedText() => StringUtil.encodeXML(text, multiline:true);

  /** Outputs the inner content of this widget. It is everything
   *
   * Default: output [innerHTML_].
   */
  void domInner_(StringBuffer out) {
    out.add(innerHTML_);
  }

  //@Override
  /** Returns whether this view allows any child views.
   *
   * Default: false.
   */
  bool isChildable_() => false;
  //@Override
  int measureWidth_(MeasureContext mctx)
  => layoutManager.measureWidthByContent(mctx, this, true);
  //@Override
  int measureHeight_(MeasureContext mctx)
  => layoutManager.measureHeightByContent(mctx, this, true);
  //@Override
  String toString() => "$className('$text$html')";
}
