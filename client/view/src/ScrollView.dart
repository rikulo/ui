//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  3:21:34 PM
// Author: tomyeh

/**
 * A view container that can be scrolled by the user.
 */
class ScrollView extends View {
  final Dir direction;
  Scroller _scroller;
  Size _contentSize;
  
  /** Construct a ScrollView.
   * + [direction] specifies allowed scrolling direction.
   */
  ScrollView([Dir direction = Dir.BOTH]) : this.direction = direction,
  _contentSize = new Size(0, 0);

  //@Override
  String get className() => "ScrollView"; //TODO: replace with reflection if Dart supports it

  /** Returns the total size of the content.
   * It shall cover all sub views (excluding invisible, anchored views).
   * In other words, it is the total size that the user can scroll.
   *
   * Default: it iterates through all child views to calculate
   * the size. It could be slow if there are a lot of children.
   * On the other hand, depending on the application, it is usually
   * able to calculate the content's size without iterating all children.
   *
   * For example, it could be a fixed value multiplied with number of rows.
   * Therefore, it is strongly suggested to override this method to calculate
   * the content's size more efficiently.
   */
  Size get contentSize() {
    if (_contentSize === null) {
      final r = ViewUtil.getRectangle(children);
      _contentSize = new Size(r.width, r.height);
    }
    return _contentSize;
  }

  /** Instantiates and returns the scroller.
   */
  Scroller newScroller_() => new Scroller(contentNode, 
    () => new DOMQuery(node).innerSize, () => contentSize,
    direction: direction);

  Element get contentNode() => getNode("inner");

  //@Override
  void doLayout_(MeasureContext ctx) {
    //we have to decide the content size before layout, since its child
    //might depend on it
    _contentSize = null; //force the calculation
    final Size sz = contentSize;
    final style = contentNode.style;
    style.width = CSS.px(sz.width);
    style.height = CSS.px(sz.height);

    super.doLayout_(ctx);
  }
  //@Override
  void mount_() {
    super.mount_();
    _scroller = newScroller_();
  }
  //@Override
  void unmount_() {
    _scroller.destroy();
    _scroller = null;
    super.mount_();
  }
  //@Override
  void draw(StringBuffer out) {
    final String tag = domTag_;
    out.add('<').add(tag);
    domAttrs_(out);
    out.add('><div class="v-inner" style="${CSS.name('transform')}:translate3d(0px,0px,0px)" id="')
        //Note: we have to specify translate3d(0,0,0). otherwise, the offset will be wrong in Dartium (seems a bug)
      .add(uuid).add('-inner">');
    domInner_(out);
    out.add('</div></').add(tag).add('>');
  }
  //@Override
  void insertChildToDocument_(View child, var childInfo, View beforeChild) {
    if (beforeChild === null)
      super.insertChildToDocument_(child, childInfo, beforeChild);
    else if (childInfo is Element)
      contentNode.$dom_appendChild(childInfo); //note: Firefox not support insertAdjacentElement
    else
      contentNode.insertAdjacentHTML("beforeEnd", childInfo);
  }
}
