//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 05, 2012 11:25:25 AM
// Author: tomyeh

/**
 * A DOM query agent used to provide the additional utilities
 * for handling DOM.
 */
class DOMQuery {
  /** The DOM element in query. */
  final node;

  factory DOMQuery(var v) {
    v = v is View ? v.node: v is String ? document.query(v): v;
    return v is Window ? new _WndQuery(v):
      v != null ? new DOMQuery._init(v): new _NullQuery();
  }
  
  DOMQuery._init(this.node);
  
  /** Returns the inner width of the given element, including padding
   * but not including border, margin and scroll bar.
   *
   * Note for JavaScript programmers, it is called clientWidth in JavaScript.
   */
  int get innerWidth => node.$dom_clientWidth;
  /** Returns the inner height of the given element, including padding
   * but not including border, margin and scroll bar.
   *
   * Note for JavaScript programmers, it is called clientHeight in JavaScript.
   */
  int get innerHeight => node.$dom_clientHeight;
  /** Returns the inner size of the given element, including padding
   * but not border.
   */
  Size get innerSize => new Size(innerWidth, innerHeight);

  /** Returns the outer width of the given element, including padding,
   * border and margin.
   */
  int get outerWidth => node.$dom_offsetWidth;
  /** Returns the outer width of the given element, including padding,
   * border and margin.
   */
  int get outerHeight => node.$dom_offsetHeight;
  /** Returns the outer size of the given element, including padding,
   * border and margin.
   */
  Size get outerSize => new Size(outerWidth, outerHeight);

  /** Returns the total width of the given element's content, including padding
   * but not including border, margin and scroll bar.
   *
   * Note: it includes every child elements (no matter that belongs to
   * the anchored views or not)
   *
   * Note for JavaScript programmers, it is called scrollWidth in JavaScript.
   */
  int get contentWidth => node.$dom_scrollWidth;
  /** Returns the total height of the given element's content, including padding
   * but not including border, margin and scroll bar.
   *
   * Note: it includes every child elements (no matter that belongs to
   * the anchored views or not)
   *
   * Note for JavaScript programmers, it is called scrollHeight in JavaScript.
   */
  int get contentHeight => node.$dom_scrollHeight;
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
  int get offsetLeft => node.$dom_offsetLeft;
  /** Returns the top position of this element relative to the top side of
   * its [offsetParent] element.
   */
  int get offsetTop => node.$dom_offsetTop;
  /** Returns the left-top position of this element relative to the top side of
   * its [offsetParent] element.
   */
  Offset get offset => new Offset(node.$dom_offsetLeft, node.$dom_offsetTop);

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
  Offset get pageOffset {
    //1. adds up cumulative offsetLeft/offsetTop
    int left = 0, top = 0;
    Element el = node;
    do {
      left += el.$dom_offsetLeft;
      top += el.$dom_offsetTop;
    } while (el.style.position != "fixed" && (el = el.offsetParent) != null);

    //2. subtract cumulative scrollLeft/scrollTop
    el = node;
    do {
      final txofs = CSS.offset3dOf(el.style.transform);
        //for performance reason it doesn't handle computed style
      left -= el.$dom_scrollLeft - txofs.left;
      top -= el.$dom_scrollTop - txofs.top;
    } while ((el = el.parent) != null && el is! Document);

    //3. add the browser's scroll offset
    left += window.pageXOffset;
    top += window.pageYOffset;
    return new Offset(left, top);
  }
  
  /** Return the rectangular range of the node relative to the document.
   */
  Rectangle get rectangle {
    final Offset off = pageOffset;
    return new Rectangle(off.left, off.top, off.left + outerWidth, off.top + outerHeight);
  }
  
  /** Returns the final used values of all the CSS properties
   */
  CSSStyleDeclaration get computedStyle 
  => window.$dom_getComputedStyle(node, "");

  /** Returns if a DOM element is a descendant of this element or
   * it is identical to this element.
   */
  bool isDescendantOf(Element parent) {
    for (Element n = node; n != null; n = n.parent) {
      if (n === parent)
        return true;
    }
    return false;
  }
  
  /** Return true if the element is input.
   */
  bool isInput() => node.tagName == 'INPUT' || node.tagName == 'TEXTAREA';
  
  /** Returns the size of the padding at left.
   */
  int get paddingLeft => CSS.intOf(computedStyle.paddingLeft);
  /** Returns the size of the padding at right.
   */
  int get paddingRight => CSS.intOf(computedStyle.paddingRight);
  /** Returns the size of the padding at top.
   */
  int get paddingTop => CSS.intOf(computedStyle.paddingTop);
  /** Returns the size of the padding at bottom.
   */
  int get paddingBottom => CSS.intOf(computedStyle.paddingBottom);

  /** Measure the size of the given text.
   *
   * If [node] is not null, the size will be based on it CSS style and
   * the optional [style]. If [node] is null, the size is based only
   * only [style].
   *
   *    new DOMQuery(node_text_will_be_assigned).measureText(s);
   *    new DOMQuery(null).measureText(s, style);
   */
  Size measureText(String text, [CSSStyleDeclaration style]) {
    if (_txtdiv == null) {
      _txtdiv = new DivElement();
      _txtdiv.style.cssText =
        "left:-1000px;position:absolute;visibility:hidden;border:none";
      document.body.nodes.add(_txtdiv);
    }

    final CSSStyleDeclaration dst = _txtdiv.style;
    _txtdiv.innerHTML = text;
    if (node != null)
      CSS.cpTextStyles(dst, window.$dom_getComputedStyle(node, ""));
    if (style != null)
      CSS.cpTextStyles(dst, style);

    final Size sz = new Size(_txtdiv.$dom_offsetWidth, _txtdiv.$dom_offsetHeight);
    _txtdiv.innerHTML = "";
    return sz;
  }
  static Element _txtdiv;
  
  /// show the element.
  void show() {
    visible = true;
  }
  
  /// hide the element.
  void hide() {
    visible = false;
  }
  
  /// set the visiblility of element
  void set visible(bool visible) {
    if (browser.msie)
      node.style.display = visible ? "": "none";
    else
      node.hidden = !visible;
  }
  
}
class _WndQuery extends DOMQuery {
  _WndQuery(var v): super._init(v);
  
  int get innerWidth => node.innerWidth;
  int get innerHeight => node.innerHeight;
  int get outerWidth => node.outerWidth;
  int get outerHeight => node.outerHeight;
  int get contentWidth => node.innerWidth;
  int get contentHeight => node.innerHeight;
  Element get offsetParent => null;
  int get offsetLeft => 0;
  int get offsetTop => 0;
  Offset get offset => new Offset(0, 0);
  Offset get pageOffset => offset;
  bool isDescendantOf(Element parent) => false;
  CSSStyleDeclaration get computedStyle => new CSSStyleDeclaration();
  void set visible(bool visible) {}
}
class _NullQuery extends _WndQuery {
  _NullQuery(): super(null);
  int get innerWidth => 0;
  int get innerHeight => 0;
  int get outerWidth => 0;
  int get outerHeight => 0;
  int get contentWidth => 0;
  int get contentHeight => 0;
}
