//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 15, 2012  5:26:05 PM
// Author: tomyeh

/**
 * Represents a HTML fragment.
 */
class HTMLFragment {
  final String _html;
  final bool _complete;

  /** Constructs with a plain text. For example,
   *
   *    new HTMLFragment(any_data); //any_data will be encoded to a string
   *    new HTMLFragment.fromHTML("<ul><li>HTML fragment</li></ul>");
   *
   * + [text] specifies the data that will be encoded as a plain text.
   * Notice that it will be encoded to be a valid HTML text.
   * ++ If it is null, it is encoded as an empty string.
   * ++ If it is [TreeNode], the data field will be used.
   * ++ If it is [Map] and it contains an entry named `"text"`, the entry
   * will be used.
   * + [mount], if specified, will be invoked after the fragment
   * has been added to the document.
   */
  HTMLFragment(var text, [AfterMount this.mount]):
  _html = getHTML(text), _complete = false;
  /** Constructs with a HTML fragment. For example
   *
   *    new HTMLFragment(any_data); //any_data will be encoded to a string
   *    new HTMLFragment.fromHTML("<ul><li>HTML fragment</li></ul>");
   *
   * + [html] specifies a HTML fragment.
   * Notice that it must be a valid HTML fragment. Otherwise, the result
   * is unpredictable.
   * ++ If it is null, it is encoded as an empty string.
   * + [mount], if specified, will be invoked after the fragment
   * has been added to the document.
   * + [complete] specifies whether this fragment contains all information.
   * The use depends on the receiver. However, it usually means that
   * the receiver doesn't have to wrap with additional HTML tags.
   */
  HTMLFragment.fromHTML(String html, [AfterMount this.mount, bool complete]):
  _html = html != null ? html: "", _complete = complete != null && complete;

  final AfterMount mount;

  /** Returns the HTML fragment stored in this object.
   */
  String get html => _html;

  /** Returns whether this fragment contains all information.
   * The use depends on the receiver. However, it usually means that
   * the receiver doesn't have to wrap with additional HTML tags.
   */
  bool isComplete() => _complete;

  String toString() => _html;

  /** Converts the given object to valid HTML text.
   *
   * + [encode] specifies whether to invoke [XMLUtil.encode].
   */
  static String getHTML(var text, [bool encode=true]) {
    if (text is TreeNode)
      text = text.data;
    if (text is Map && text.contains("text"))
      text = text["text"];
    return text != null ?
      encode != null && encode ? "${XMLUtil.encode(text)}": "$text": "";
  }
}
