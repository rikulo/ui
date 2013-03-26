//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh
part of rikulo_html;

/**
 * A DOM query agent used to provide the additional utilities
 * for handling DOM.
 */
class DomAgent {
  /** The DOM element in query. */
  final node;

  DomAgent(Element this.node);
  DomAgent.query(String s): this(document.query(s));
  DomAgent._as(this.node);
  
  /** Returns the inner width of the given element, including padding
   * but not including border, margin and scroll bar.
   *
   * Note for JavaScript programmers, it is called clientWidth in JavaScript.
   */
  int get innerWidth => node.clientWidth;
  /** Returns the inner height of the given element, including padding
   * but not including border, margin and scroll bar.
   *
   * Note for JavaScript programmers, it is called clientHeight in JavaScript.
   */
  int get innerHeight => node.clientHeight;
  /** Returns the inner size of the given element, including padding
   * but not border.
   */
  Size get innerSize => new Size(innerWidth, innerHeight);

  /** Returns the (outer) width of the given element, including padding,
   * border and margin.
   */
  int get width => node.offsetWidth;
  /** Returns the (outer) width of the given element, including padding,
   * border and margin.
   */
  int get height => node.offsetHeight;
  /** Returns the (outer) size of the given element, including padding,
   * border and margin.
   */
  Size get size => new Size(width, height);

  /** Returns the total width of the given element's content, including padding
   * but not including border, margin and scroll bar.
   *
   * Note: it includes every child elements (no matter that belongs to
   * the anchored views or not)
   *
   * Note for JavaScript programmers, it is called scrollWidth in JavaScript.
   */
  int get contentWidth => node.scrollWidth;
  /** Returns the total height of the given element's content, including padding
   * but not including border, margin and scroll bar.
   *
   * Note: it includes every child elements (no matter that belongs to
   * the anchored views or not)
   *
   * Note for JavaScript programmers, it is called scrollHeight in JavaScript.
   */
  int get contentHeight => node.scrollHeight;
  /** Returns the total size of the given element's content, including padding
   * but not including border, margin and scroll bar.
   */
  Size get contentSize => new Size(contentWidth, contentHeight);

  /** Returns the closest ancestor element in the DOM hierarchy from
   * which the position of the current element is calculated, or null
   * if it is the topmost element.
   *
   * Use [offsetLeft] and [offsetTop] to retrieve the position of
   * the top-left corner of an object relative to the top-left corner
   * of its offset parent object.
   */
  Element get offsetParent => node.offsetParent;
  /** Returns the left position of this element relative to the left side of
   * its [offsetParent] element.
   */
  int get offsetLeft => node.offsetLeft;
  /** Returns the top position of this element relative to the top side of
   * its [offsetParent] element.
   */
  int get offsetTop => node.offsetTop;
  /** Returns the position and dimension of this element relative to the top side of
   * its [offsetParent] element.
   */
  Rect get offset => node.offset;
  /** Returns the position of this element relative to the top side of
   * its [offsetParent] element.
   */
  Point get position => new Point(offsetLeft, offsetTop);

  /** Returns the offset of this node relative to the document.
   * It takes into account any horizontal scrolling and the `transform` style.
   *
   * Notice that, for sake of performance, it checks only the `transform` property
   * defined in the DOM element's style. It doesn't check the *computed* style
   * (i.e., the style defined in CSS rules).
   *
   * In additions, it ignores the translation in z axis (i.e., it ignores
   * the third argument of `translate3d`).
   */
  Point get page {
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
      final txofs = Css.point3DOf(el.style.transform);
        //for performance reason it doesn't handle computed style
      left -= el.scrollLeft - txofs.x;
      top -= el.scrollTop - txofs.y;
    } while ((el = el.parent) != null && el is! Document);

    //3. add the browser's scroll offset
    left += window.pageXOffset;
    top += window.pageYOffset;
    return new Point(left, top);
  }
  
  /** Returns if a DOM element is a descendant of this element or
   * it is identical to this element.
   */
  bool isDescendantOf(Element parent) {
    for (Element n = node; n != null; n = n.parent) {
      if (identical(n, parent))
        return true;
    }
    return false;
  }
  
  /** Return true if the element is input.
   */
  bool get isInput => node.tagName == 'INPUT' || node.tagName == 'TEXTAREA';

  /** Returns if there is non-empty node in this element.
   */
  bool get hasContent => _hasContent(node);
  static bool _hasContent(Node node) {
    if (node is Text && !node.text.trim().isEmpty)
      return true;

    if (node is Element)
      switch ((node as Element).tagName.toLowerCase()) {
        case "input":
        case "option":
        case "textarea":
          return true;
      }

    for (final n in node.nodes)
      if (_hasContent(n))
        return true;
    return false;
  }

  /// Sum over horizontal sizes of given properties.
  int sumWidth({bool margin: false, bool border: false, bool padding: false})
    => _sum(false, margin, border, padding);
  /// Sum over vertical sizes of given properties.
  int sumHeight({bool margin: false, bool border: false, bool padding: false})
    => _sum(true, margin, border, padding);
  int _sum(bool ver, bool margin, bool border, bool padding) {
    int sum = 0;
    final s = node.getComputedStyle();
    if (margin)
      sum += ver ? Css.intOf(s.marginTop) + Css.intOf(s.marginBottom) :
          Css.intOf(s.marginLeft) + Css.intOf(s.marginRight);
    if (border)
      sum += ver ? Css.intOf(s.borderTopWidth) + Css.intOf(s.borderBottomWidth) :
        Css.intOf(s.borderLeftWidth) + Css.intOf(s.borderRightWidth);
        //Note: borderWidth is supported only by Chrome
    if (padding)
      sum += ver ? Css.intOf(s.paddingTop) + Css.intOf(s.paddingBottom) :
        Css.intOf(s.paddingLeft) + Css.intOf(s.paddingRight);
    return sum;
  }

  /** Measure the size of the given text.
   *
   * If [node] is not null, the size will be based on it CSS style and
   * the optional [style]. If [node] is null, the size is based only
   * only [style].
   *
   *     new DomAgent(node_text_will_be_assigned).measureText(s);
   *     new DomAgent(null).measureText(s, style);
   */
  Size measureText(String text, [CssStyleDeclaration style]) {
    if (_txtdiv == null) {
      _txtdiv = new DivElement();
      _txtdiv.style.cssText =
        "left:-1000px;position:absolute;visibility:hidden;border:none";
      document.body.nodes.add(_txtdiv);
    }

    final dst = _txtdiv.style;
    _txtdiv.innerHtml = text;
    if (node != null)
      Css.copy(dst, node.getComputedStyle(), Css.textNames);
    if (style != null)
      Css.copy(dst, style, Css.textNames);

    final Size sz = new Size(_txtdiv.offsetWidth, _txtdiv.offsetHeight);
    _txtdiv.innerHtml = "";
    return sz;
  }
  static Element _txtdiv;

  /** show the element.
   *
   * Notice that this method actually *resets* `Element`'s `style.display`
   * to empty. In other words, if the CSS rules associated with the given node
   * are specified with `display:none`, the element is still not visible.
   */
  void show() {
    node.style.display = "";
  }
  /// hide the element.
  void hide() {
    node.style.display = "none";
  }
}

/**
 * A window query agent used to provide the additional utilities
 * for handling window.
 */
class WindowAgent extends DomAgent {
  WindowAgent(Window w): super._as(w);

  @override
  int get innerWidth => node.innerWidth;
  @override
  int get innerHeight => node.innerHeight;
  @override
  int get width => node.innerWidth;
  @override
  int get height => node.innerHeight;
  @override
  int get contentWidth => node.innerWidth;
  @override
  int get contentHeight => node.innerHeight;
  @override
  Element get offsetParent => null;
  @override
  int get offsetLeft => 0;
  @override
  int get offsetTop => 0;
  @override
  Rect get offset => new Rect(0, 0, 0, 0);
  @override
  Point get page => new Point(0, 0);
  @override
  bool isDescendantOf(Element parent) => false;
  @override
  bool get isInput => false;
  @override
  bool get hasContent => true;
  @override
  int sumWidth({bool margin: false, bool border: false, bool padding: false}) => 0;
  @override
  int sumHeight({bool margin: false, bool border: false, bool padding: false}) => 0;
  @override
  void show() {
  }
  @override
  void hide() {
  }
}
