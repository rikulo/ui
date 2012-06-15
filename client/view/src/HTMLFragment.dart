//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 15, 2012  5:26:05 PM
// Author: tomyeh

typedef void EnterDocument(Element node);

/**
 * Represents a HTML fragment.
 */
class HTMLFragment {
  final String _html;

  /** Constructs with a plain text. For example,
   *
   *    new HTMLFragment(any_data); //any_data will be encoded to a string
   *    new HTMLFragment.html("<ul><li>HTML fragment</li></ul>");
   *
   * + [text] specifies the data that will be encoded as a plain text.
   * Notice that it will be encoded to be a valid HTML text.
   * ++ If it is null, it is encoded as an empty string.
   * ++ If it is [TreeNode], the data field will be used.
   * ++ If it is [Map] and it contains an entry named `"text"`, the entry
   * will be used.
   * + [enterDocument], if specified, will be invoked after the text
   * has been added to the document.
   */
  HTMLFragment(var text, [EnterDocument this.enterDocument]):
  _html = getHTML(text);
  /** Constructs with a HTML fragment. For example
   *
   *    new HTMLFragment(any_data); //any_data will be encoded to a string
   *    new HTMLFragment.html("<ul><li>HTML fragment</li></ul>");
   *
   * + [html] specifies a HTML fragment.
   * Notice that it must be a valid HTML fragment. Otherwise, the result
   * is unpredictable.
   * ++ If it is null, it is encoded as an empty string.
   * + [enterDocument], if specified, will be invoked after the html
   * has been added to the document.
   */
  HTMLFragment.html(String html, [EnterDocument this.enterDocument]):
  _html = html !== null ? html: "";

  final EnterDocument enterDocument;

  /** Returns the HTML fragment stored in this object.
   */
  String get html() => _html;
  String toString() => _html;

  /** Converts the given object to valid HTML text.
   *
   * + [encode] specifies whether to invoke [StringUtil.encodeXML].
   */
  static String getHTML(var text, [bool encode=true]) {
    if (text is TreeNode)
      text = text.data;
    if (text is Map && text.contains("text"))
      text = text["text"];
    return text !== null ?
      encode !== null && encode ? "${StringUtil.encodeXML(text)}": "$text": "";
  }
}
