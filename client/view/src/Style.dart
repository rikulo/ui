//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  4:12:43 PM
// Author: tomyeh

/**
 * A CSS style.
 */
class Style extends View {
  //_src and _content cannot be non-null at the same time
  String _src, _content, _media;

  /** Constructs an empty style.
   */
  Style([String media]) {
    _visible = false; //so shallLayout_ will ignore it
    _media = media;
  }
  /** Constructs a style from the given CSS content.
   */
  Style.fromContent(String content, [String media]) {
    _content = content;
    _media = media;
  }
  /** Constructs a style from the given URL containing the CSS content.
   */
  Style.fromSrc(String src, [String media]) {
    _src = src;
    _media = media;
  }

  //@Override
  String get className => "Style"; //TODO: replace with reflection if Dart supports it

  /** Returns the URL of the CSS file, or null if no CSS file specified.
   */
  String get src => _src;
  /** Sets the URL of the CSS file.
   * If there is any content, it will be removed.
   * In other words, [get content] returns null after this method is called.
   */
  void set src(String src) {
    _content = null;
    if (_src !== src) {
      _src = src;
      invalidate();
    }
  }

  /** Returns the CSS content, or null if no content specified.
   *
   * Notice that this method returns the value returned of the
   * previous invocation of [set content]. It returns null
   * if the previous invocation is [set src].
   */
  String get content => _content;
  /** Sets the CSS content.
   * If there is any URI being assigned, it will be removed.
   * In other words, [get src] returns null after this method is called.
   */
  void set content(String content) {
    _src = null;
    if (_content != content) {
      _content = content;
      invalidate();
    }
  }

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
      invalidate();
    }
  }

  //@Override
  void draw(StringBuffer out) {
    out.add('<div id="').add(uuid).add('" style="display:none">');
    domInner_(out);
    out.add('</div>');
  }
  //@Override
  void domInner_(StringBuffer out) {
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
  }
  //@Override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isViewGroup() => false;
  //@Override
  String toString() => "$className('${src != null ? src: content}')";
}
