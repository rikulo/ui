//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  4:12:43 PM
// Author: tomyeh
part of rikulo_view;

/**
 * An invisible UI element to define the CSS style information (aka., CSS rules).
 */
class Style extends View {
  String _media;

  /** Constructs a style.
   *
   * Notice: you can specify either [content] or [src] (or none) but
   * not both
   */
  Style({String content, String src, String media}) {
    _media = media;
    visible = false;
    _updateInner(content, src);
  }

  /** Returns the style sheet, or null if not available.
   */
  StyleSheet get sheet {
    var n;
    if ((n = _linkNode) != null)
      return n.sheet;
    if ((n = _styleNode) != null)
      return n.sheet;
  }
  /** Returns the URL of the CSS file, or null if no CSS file specified.
   */
  String get src {
    final n = _linkNode;
    return n != null ? n.href: null;
  }
  /** Sets the URL of the CSS file.
   * If there is any content, it will be removed.
   * In other words, [get content] returns null after this method is called.
   */
  void set src(String src) {
    _updateInner(null, src);
  }

  /** Returns the CSS content, or null if no content specified.
   *
   * Notice that this method returns the value returned of the
   * previous invocation of [set content]. It returns null
   * if the previous invocation is [set src].
   */
  String get content {
    final n = _styleNode;
    return n != null ? n.innerHtml: null;
  }
  /** Sets the CSS content.
   * If there is any URI being assigned, it will be removed.
   * In other words, [get src] returns null after this method is called.
   */
  void set content(String content) {
    _updateInner(content, null);
  }

  LinkElement get _linkNode => node.query("link");
  StyleElement get _styleNode => node.query("style");

  /** Returns the CSS media, or null if no media specified.
   *
   * Default: null (no media).
   */
  String get media => _media;
  /** Sets the CSS media.
   */
  void set media(String media) {
    if (_media != media) {
      _media = media;
      var n;
      if ((n = _linkNode) != null)
        n.media = _s(media);
      else if ((n = _styleNode) != null)
        n.media = _s(media);
    }
  }

  void _updateInner(String content, String src) {
    final out = new StringBuffer();
    if (src != null)
      out.add('<link rel="stylesheet" type="text/css" href="').add(src).add('"');
    else
      out.add('<style');

    if (media != null)
      out.add(' media="').add(media).add('"');

    if (src != null) {
      out.add('/>');
    } else {
      out.add('>');
      if (content != null)
        out.add(content);
      out.add('</style>');
    }
    node.innerHtml = out.toString();
  }
  /** Returns false to indicate this view doesn't allow any child views.
   */
  //@override
  bool get isViewGroup => false;
  //@override
  String toString() => "$className($src)";
}
