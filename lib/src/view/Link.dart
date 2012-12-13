//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Nov 22, 2012  4:51:15 PM
// Author: tomyeh
part of rikulo_view;

/**
 * A link view for displaying and manipulating the hyperlink (aka., link).
 */
class Link extends TextView {
  /** Instantiates with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  Link([String text]): super(text);
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notice it must be a valid HTML fragment. Otherwise, the result is
   * unpredictable.
   */
  Link.fromHtml(String html): super.fromHtml(html);

  /** Returns the INPUT element in this view.
   */
  AnchorElement get _anchorNode => node;

  /** The URL of the page the link goes to.
   */
  String get href => _anchorNode.href;
  /** The URL of the page the link goes to.
   */
  void set href(String href) {
    _anchorNode.href = _s(href);
  }

  /** The language of the linked document.
   */
  String get hreflang => _anchorNode.hreflang;
  /** The language of the linked document.
   */
  void set hreflang(String hreflang) {
    _anchorNode.hreflang = _s(hreflang);
  }

  /** Specifies whether to open the linked document.
   */
  String get target => _anchorNode.target;
  /** Specifies whether to open the linked document.
   */
  void set target(String target) {
    _anchorNode.target = _s(target);
  }

  /** The MIME type of the linked document.
   */
  String get type => _anchorNode.type;
  /** The MIME type of the linked document.
   */
  void set type(String type) {
    _anchorNode.type = _s(type);
  }

  /** The relationship between the current document and the linked document.
   */
  String get rel => _anchorNode.rel;
  /** The relationship between the current document and the linked document.
   *
   * Allowed values: `alternate`, `author`, `bookmark`, `help`, `license`,
   * `next`, `nofollow`, `noreferrer`, `prefetch`, `prev`, `search` and `tag`.
   */
  void set rel(String rel) {
    _anchorNode.rel = _s(rel);
  }

  //@override
  Element render_()
  => new Element.html("<a>$encodedText</a>");
}
