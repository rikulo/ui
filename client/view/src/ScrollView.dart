//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 03, 2012  3:21:34 PM
// Author: tomyeh

/**
 * A view container that can be scrolled by the user.
 */
class ScrollView extends View {
  final Function _snap;
  final Dir direction;
  Scroller _scroller;
  Size _contentSizeValue, _contentSize;
  
  /** Construct a ScrollView.
   * + [direction] specifies allowed scrolling direction.
   */
  ScrollView([Dir direction = Dir.BOTH, Offset snap(Offset off), Size contentSize]) : 
  this.direction = direction, _snap = snap, 
  _contentSizeValue = contentSize, _contentSize = contentSize;

  //@Override
  String get className => "ScrollView"; //TODO: replace with reflection if Dart supports it
  
  /** Return the view port size, which is determined by the inner size of the
   * node.
   */
  Size get viewPortSize => new DOMQuery(node).innerSize;
  
  /** Returns the total size of the content.
   * It shall cover all sub views (excluding invisible, anchored views).
   * In other words, it is the total size that the user can scroll.
   *
   * If [contentSize] is set or is given in the constructor, the value
   * is used; otherwise it iterates through all child views to calculate
   * the size. In the latter case, it could be slow if there are a lot of 
   * children. Thus, if possible, it is encouraged to provide the content size.
   */
  Size get contentSize {
    if (_contentSize == null) {
      if (_contentSizeValue != null)
        _contentSize = _contentSizeValue;
      else {
        final r = ViewUtil.getRectangle(children);
        _contentSize = new Size(r.width, r.height);
      }
    }
    return _contentSize;
  }
  
  /** Set the content size, which shall cover all the children. If null, the 
   * ScrollView will determine content size by the range of its children.
   */
  void set contentSize(Size size) {
    _contentSizeValue = _contentSize = size;
  }
  
  /** Instantiates and returns the scroller.
   */
  Scroller newScroller_() => new Scroller(contentNode, 
    () => viewPortSize, () => contentSize,
    direction: direction, snap: _snap, 
    start: onScrollStart_, move: onScrollMove_, end: onScrollEnd_);
  
  /** Retrieve content node.
   */
  Element get contentNode => getNode("inner");
  
  /** Called when scrolling starts.
   */
  bool onScrollStart_(ScrollerState state) {
    sendEvent(new ScrollEvent("scrollStart", this, state));
    return true;
  }
  
  /** Called during scrolling.
   */
  bool onScrollMove_(ScrollerState state, void defaultAction()) {
    defaultAction();
    sendEvent(new ScrollEvent("scrollMove", this, state));
    return true;
  }
  
  /** Called when scrolling ends.
   */
  void onScrollEnd_(ScrollerState state) {
    sendEvent(new ScrollEvent("scrollEnd", this, state));
  }
  
  /** Return the [Scroller] associated with this scroll view. It is available
   * after mount.
   */
  Scroller get scroller => _scroller;
  
  //@Override
  void onPreLayout_(MeasureContext mctx) {
    //we have to decide the content size here, since its children might depend on it
    _contentSize = null; //force the calculation
    final Size sz = contentSize;
    final style = contentNode.style;
    style.width = CSS.px(sz.width);
    style.height = CSS.px(sz.height);

    super.onPreLayout_(mctx);
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
  void domInner_(StringBuffer out) {
    out.add('<div class="v-inner" id="').add(uuid).add('-inner">');
    super.domInner_(out);
    out.add('</div>');
  }
  //@Override
  void insertChildToDocument_(View child, var childInfo, View beforeChild) {
    if (beforeChild != null)
      super.insertChildToDocument_(child, childInfo, beforeChild);
    else if (childInfo is Element)
      contentNode.$dom_appendChild(childInfo); //note: Firefox not support insertAdjacentElement
    else
      contentNode.insertAdjacentHTML("beforeEnd", childInfo);
  }
}
