//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 03, 2012  1:15:40 PM
// Author: tomyeh

/**
 * A popup view is a floating UI element that appears on the top of the screen.
 * Unlike other views, it won't be cropped by its parent view, even if 
 * the parent view's CSS overflow is set.
 *
 * + A popup view won't be arranged by a layout, such as [LinearLayout].
 * + The z order among popup views all depends on the z-index of the CSS style.
 * In other words, a child popup view might appear under its parent popup or
 * other sibling views if z-index is not set correctly.
 * The default z-index for popup views is 1000.
 * + A popup view will be closed automatically when the user clicks an UI element
 * that is not a descendant view of the popup view if [dismissOnClickOutside]
 * is true).
 *
 * ##Events
 * 
 * + `dismiss` - sent when this popup is asked to dismiss because of user's activity,
 * such as clicking on a view other than this popup. By default, it will be hidden.
 * If you prefer to remove it, you can do as follows.
 *
 *     popup.on.dismiss.add((event) {
 *       popup.removeFromParent();
 *     });
 *
 * ##The associated DOM Element
 *
 * To make the DOM element appears on the top of all other views, [PopupView]
 * creates two DOM elements. One is called [mountNode]. It is used as
 * the *mounting node* to add to the parent's hierarchy of elements.
 * However, it is invisible and used only to form the hierarchy of elements
 *
 * The other element is called [node]. It is not part of the parent's hierarchy
 * of elements. When the view is added to the document,
 * [node] will be attached as a direct child element of [document.body].
 * Thus, it can appear on top of any view, and won't be cropped.
 * It is the visual representation of this popup view containing
 * child views.
 *
 * ###Why not using `position:fixed`
 *
 * The browser's support of `position:fixed` is too buggy.
 * Different browsers have different problems, such as
 * not supporting `transform:translate3d` (cropping and position incorrectly),
 * not supported in iOS 4 (and ealier), etc.
 */
class PopupView extends View {
  /** Whether to dismiss this popup view when the user clicks outside
   * of it.
   *
   * Default: true
   */
  final bool dismissOnClickOutside;
  /** The number of milliseconds to wait before dismissing it automatically.
   *
   * Default: 0 (means ignored; i.e., not to dismiss because of timeout)  
   * Unit: milliseconds
   */
  final int dismissTimeout;

  ViewEventListener _fnClickOutside;
  int _idDismissTimeout;
  //mounting node
  Element _mtnode; //don't access it (except in mountNode)

  /** Constructor.
   *
   * + [dismissTimeout] specifies whether to dismiss this popup view when
   * the user clicks outside of it
   * + [dismissOnClickOutside] specifies the number of milliseconds to wait
   * before dismissing it automatically.
   */
  PopupView([int this.dismissTimeout=0, bool this.dismissOnClickOutside=true]) {
    _mtnode = new Element.html('<div style="display:none"></div>');
    node = new Element.tag("div");
  }

  //@override
  String get className => "PopupView"; //TODO: replace with reflection if Dart supports it

  /** Dismisses the popup view.
   *
   * Default: sending the `dismiss` event to itself, and hide this view.
   *
   * To override the default behavior (hiding), you can listener to `dismiss` event
   * or overrides this method.
   */
  void dismiss() {
    sendEvent(new ViewEvent("dismiss"));
    visible = false;
  }

  //@override
  Element get mountNode => _mtnode;

  //@override
  void set visible(bool visible) {
    super.visible = visible;
    _startDismissTimeout();
  }
  //@override
  void set left(int left) {
    _left = left;

    if (inDocument) {
      if (parent != null)
        left = new DOMAgent(mountNode.parent).pageOffset.left + left;
      node.style.left = CSS.px(left);
    }
  }
  //@override
  void set top(int top) {
    _top = top;

    if (inDocument) {
      if (parent != null)
        top = new DOMAgent(mountNode.parent).pageOffset.top + top;
      node.style.top = CSS.px(top);
    }
  }

  //@override
  void mount_() {
    super.mount_();

    //move node to document.body on mount
    document.body.nodes.add(node);

    //fix the left/top of DOM (since it is in diff coordinates)
    if (parent != null) {
      final ofs = new DOMAgent(mountNode.parent).pageOffset;
      final style = node.style;
      style.left = CSS.px(ofs.left + left);
      style.top = CSS.px(ofs.top + top);
    }

    if (dismissOnClickOutside)
      broadcaster.on.popup.add(_fnClickOutside = (PopupEvent event) {
          if (visible && inDocument && event.shallClose(this))
            dismiss();
        });
    _startDismissTimeout();
  }
  //@override
  void unmount_() {
    node.remove(); //detach it

    if (_fnClickOutside != null) {
      broadcaster.on.popup.remove(_fnClickOutside);
      _fnClickOutside = null;
    }
    if (_idDismissTimeout != null) {
      window.clearTimeout(_idDismissTimeout);
      _idDismissTimeout = null;
    }

    super.unmount_();
  }
  void _startDismissTimeout() {
    if (_idDismissTimeout == null && dismissTimeout > 0
    && visible && inDocument) {
      _idDismissTimeout = window.setTimeout(() {
          _idDismissTimeout = null;
          if (visible && inDocument)
            dismiss();
        }, dismissTimeout);
    }
  }
}
