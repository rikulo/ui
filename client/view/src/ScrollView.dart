//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  3:21:34 PM
// Author: tomyeh

/**
 * A view container that can be scrolled by the user.
 */
class ScrollView extends View {
  Scroller _scroller;

  ScrollView() {
  }

  //@Override
  String get className() => "ScrollView"; //TODO: replace with reflection if Dart supports it

  /** Update the size of [innerNode].
   * [ScrollView] assumes [innerNode] shall cover all sub views. IN other words,
   * it is the total size that the user can scroll.
   *
   * Default: it iterates through all child views to calculate
   * the size. It could be slow if there are a lot of children.
   * However, depending on the application, it is usually to
   * calculate the content's size without iterating all children.
   * For example, it could be a fixed value multiplied with number of rows.
   * Therefore, it is strongly suggested to override this method to calculate
   * the content's size more efficiently.
   */
  void updateInnerSize_() {
    final Rectangle rect = ViewUtil.getRectangle(children);
    final style = innerNode.style;
    style.width = CSS.px(rect.right);
    style.height = CSS.px(rect.bottom);
  }

  /** Instantiates and returns the scroller.
   */
  Scroller newScroller_() => new Scroller(innerNode, 
    () => new DOMQuery(node).innerSize, () => new DOMQuery(innerNode).innerSize);

  void onLayout() {
    updateInnerSize_();
    super.onLayout();
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
  Element get innerNode() => getNode("inner");
}
