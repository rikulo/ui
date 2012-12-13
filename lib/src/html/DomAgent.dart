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
  /** Returns the left-top position of this element relative to the top side of
   * its [offsetParent] element.
   */
  Offset get offset => new Offset(node.offsetLeft, node.offsetTop);

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
      left += el.offsetLeft;
      top += el.offsetTop;
    } while (el.style.position != "fixed" && (el = el.offsetParent) != null);

    //2. subtract cumulative scrollLeft/scrollTop
    el = node;
    do {
      final txofs = Css.offset3dOf(el.style.transform);
        //for performance reason it doesn't handle computed style
      left -= el.scrollLeft - txofs.left;
      top -= el.scrollTop - txofs.top;
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
    return new Rectangle(off.left, off.top, off.left + width, off.top + height);
  }
  
  /** Returns the final used values of all the CSS properties
   */
  CssStyleDeclaration get computedStyle 
  => window.$dom_getComputedStyle(node, "");

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
      Css.copy(dst, window.$dom_getComputedStyle(node, ""), Css.textNames);
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

  int get innerWidth => node.innerWidth;
  int get innerHeight => node.innerHeight;
  int get width => node.innerWidth;
  int get height => node.innerHeight;
  int get contentWidth => node.innerWidth;
  int get contentHeight => node.innerHeight;
  Element get offsetParent => null;
  int get offsetLeft => 0;
  int get offsetTop => 0;
  Offset get offset => new Offset(0, 0);
  Offset get pageOffset => offset;
  bool isDescendantOf(Element parent) => false;
  CssStyleDeclaration get computedStyle => new CssStyleDeclaration();
  void set visible(bool visible) {}
}
