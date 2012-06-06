//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  3:21:34 PM
// Author: tomyeh

/**
 * A view container that can be scrolled by the user.
 */
class ScrollView extends View {
  Scroller _scroller;

  ScrollView() {
    vclass = "v-ScrollView";
  }

  /** Returns the size that the content occupies.
   * In other words, [ScrollView] assumes the content occupies
   * from the left-top corner of [innerNode] and up to the size
   * returned by this method.
   * <p>Default: it iterates through all child views to calculate
   * the size. It could be slow if there are a lot of children.
   * However, depending on the application, it is usually to
   * calculate the content's size without iterating all children.
   * For example, it could be a fixed value multiplied with number of rows.
   * Therefore, it is strongly suggested to override this method to calculate
   * the content's size more efficiently.
   */
  Size get contentSize() => ViewUtil.getRectangle(children);

  /** Instantiates and returns the scroller.
   */
  Scroller newScroller_() => new Scroller(innerNode, totalSize: () => contentSize);

  //@Override
  void enterDocument_() {
    super.enterDocument_();
    _scroller = newScroller_();
  }
  //@Override
  void exitDocument_() {
    _scroller.destroy();
    _scroller = null;
    super.enterDocument_();
  }
  //@Override
  void draw(StringBuffer out) {
    final String tag = domTag_;
    out.add('<').add(tag);
    domAttrs_(out);
    out.add('><div class="v-ScrollView-inner" style="${CSS.$('transform')}:translate3d(0px,0px,0px)" id="')
        //Note: we have to specify translate3d(0,0,0). otherwise, the offset will be wrong in Dartium (seems a bug)
      .add(uuid).add('-inner">');
    domInner_(out);
    out.add('</div></').add(tag).add('>');
  }
  //@Override
  Element get innerNode() => getNode("inner");
  //@Override
  void adjustInnerNode_([bool bLeft=false, bool bTop=false, bool bWidth=false, bool bHeight=false]) {
    //nothing to do since it is controlled by CSS (and handled by browser)
  }
}
