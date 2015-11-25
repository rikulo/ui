//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh
part of rikulo_html;

/** The browser.
 */
class Browser extends bwr.Browser {
  /** Returns the URL of this page.
   * For example, "http://www.yourserver.com" and "file://".
   */
  String get url {
    final l = window.location;
    final sb = new StringBuffer();
    sb..write(l.protocol)..write("//")..write(l.hostname);
    if (l.port != "80" && !l.port.isEmpty)
      sb..write(':')..write(l.port);
    return sb.toString();
  }
  @override
  String get userAgent => window.navigator.userAgent;
}
/** The browser information.
 */
final Browser browser = new Browser();

/**
 * DOM utilities
 */
class DomUtil {
  /** Returns the inner size of the window, i.e., `window.innerWidth` and `window.innerHeight`.
   */
  static Size get windowSize => new Size(window.innerWidth, window.innerHeight);

  /** Returns the client size (aka., the inner size) of the given element, including padding
   * but not border.
   *
   * It is a shortcut of `new Size(node.clientWidth, node.clientHeight)`.
   */
  static Size clientSize(Element node) => new Size(node.clientWidth, node.clientHeight);
  /** Returns the offset size (aka., the outer size) of the given element, including padding
   * but not border.
   *
   * It is a shortcut of `new Size(node.offsetWidth, node.offsetHeight)`.
   */
  static Size offsetSize(Element node) => new Size(node.offsetWidth, node.offsetHeight);
  /** Returns the scroll size (aka., the total size) of the given element's content,
   * including padding but not including border, margin and scroll bar.
   *
   * It is a shortcut of `new Size(node.scrollWidth, node.scrollHeight)`.
   */
  static Size scrollSize(Element node) => new Size(node.scrollWidth, node.scrollHeight);

  /** Returns the position of this element relative to the top side of
   * its `offsetParent` element.
   *
   * It is a shortcut of `new Point(node.offsetLeft, node.offsetTop)`.
   *
   * Notice: to get an instance of `Rect`, use `node.offset` instead.
   */
  static Point position(Element node) => new Point(node.offsetLeft, node.offsetTop);
  /** Returns the offset of the given element relative to the document (aka., page offset).
   * It takes into account any horizontal scrolling and the `transform` style.
   *
   * Notice that, for sake of performance, it checks only the `transform` property
   * defined in the DOM element's style. It doesn't check the *computed* style
   * (i.e., the style defined in CSS rules).
   *
   * In additions, it ignores the translation in z axis (i.e., it ignores
   * the third argument of `translate3d`).
   */
  static Point page(Element node) {
    //1. adds up cumulative offsetLeft/offsetTop
    int left = 0, top = 0;
    Element el = node;
    do {
      left += el.offsetLeft;
      top += el.offsetTop;
    } while (el.style.position != "fixed" && (el = el.offsetParent) != null);

    //2. subtract cumulative scrollLeft/scrollTop
    el = node;
    do {
      final txofs = CssUtil.point3DOf(el.style.transform);
        //for performance reason it doesn't handle computed style
      left -= el.scrollLeft - txofs.x;
      top -= el.scrollTop - txofs.y;
    } while ((el = el.parent) != null && el is! Document);

    //3. add the browser's scroll offset
    left += window.pageXOffset;
    top += window.pageYOffset;
    return new Point(left, top);
  }
  
  /** Returns if the given element (`node`) is a descendant of
   * `parent`.
   */
  static bool isDescendant(Element node, Element parent) {
    for (Element n = node; n != null; n = n.parent) {
      if (identical(n, parent))
        return true;
    }
    return false;
  }
  
  /** Return true if the element is input.
   */
  static bool isInput(Element node) => node.tagName == 'INPUT' || node.tagName == 'TEXTAREA';

  /** Returns if there is non-empty node in this element.
   */
  static bool hasContent(Element node) {
    if (node is Text && !node.text.trim().isEmpty)
      return true;

    if (node is Element)
      switch (node.tagName.toLowerCase()) {
        case "input":
        case "option":
        case "textarea":
          return true;
      }

    for (final n in node.nodes)
      if (hasContent(n))
        return true;
    return false;
  }

  /// Sum over horizontal sizes of given properties.
  static int sumWidth(Element node, {bool margin: false, bool border: false, bool padding: false})
    => _sum(node, false, margin, border, padding);
  /// Sum over vertical sizes of given properties.
  static int sumHeight(Element node, {bool margin: false, bool border: false, bool padding: false})
    => _sum(node, true, margin, border, padding);
  static int _sum(Element node, bool ver, bool margin, bool border, bool padding) {
    int sum = 0;
    final s = node.getComputedStyle();
    if (margin)
      sum += ver ? CssUtil.intOf(s.marginTop) + CssUtil.intOf(s.marginBottom) :
          CssUtil.intOf(s.marginLeft) + CssUtil.intOf(s.marginRight);
    if (border)
      sum += ver ? CssUtil.intOf(s.borderTopWidth) + CssUtil.intOf(s.borderBottomWidth) :
        CssUtil.intOf(s.borderLeftWidth) + CssUtil.intOf(s.borderRightWidth);
        //Note: borderWidth is supported only by Chrome
    if (padding)
      sum += ver ? CssUtil.intOf(s.paddingTop) + CssUtil.intOf(s.paddingBottom) :
        CssUtil.intOf(s.paddingLeft) + CssUtil.intOf(s.paddingRight);
    return sum;
  }

  /** Measure the size of the given text.
   *
   * If [node] is not null, the size will be based on it CSS style and
   * the optional [style]. If [node] is null, the size is based only
   * only [style].
   *
   *     DomUtil.measureText(node_text_will_be_assigned, s);
   *     DomUtil.measureText(null, s, style);
   */
  static Size measureText(Element node, String text, [CssStyleDeclaration style]) {
    final DivElement txtdiv = new DivElement();
    txtdiv.style.cssText =
      "left:-1000px;position:absolute;visibility:hidden;border:none";
    document.body.nodes.add(txtdiv);

    final dst = txtdiv.style;
    txtdiv.nodes.add(new Text(text));
    if (node != null)
      CssUtil.copy(node.getComputedStyle(), dst, CssUtil.textNames);
    if (style != null)
      CssUtil.copy(style, dst, CssUtil.textNames);

    final Size sz = new Size(txtdiv.offsetWidth, txtdiv.offsetHeight);
    txtdiv.remove();
    return sz;
  }

  /** Show the element.
   *
   * It is a shortcut of `node.style.display = ""`.
   *
   * Notice that this method actually *resets* `Element`'s `style.display`
   * to empty. In other words, if the CSS rules associated with the given node
   * are specified with `display:none`, the element is still not visible.
   */
  static void show(Element node) {
    node.style.display = "";
  }
  /** Hide the element.
   *
   * It is a shortcut of `node.style.display = "none"`.
   */
  static void hide(Element node) {
    node.style.display = "none";
  }
}
