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
 * ##The associated DOM Element ([node])
 *
 * To make the DOM element appears on the top of all other views, [PopupView] creates
 * two DOM elements. One (called [refNode]) is created as a child element of
 * the parent view's DOM element, like any other view does. However, it is invisible
 * and used only as a *reference* for inserting sibling views.
 *
 * The other element (called [node]) is created as a direct element of [document.body]
 * (or [Activity.container] if not null).
 * It is the real visual representation of this popup view.
 *
 * Notice that [node]'s `parent` is not the same as [parent]'s node.
 * Use it only if the first approach doesn't work well under your environment.
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

  /** Constructor.
   *
   * + [dismissTimeout] specifies whether to dismiss this popup view when
   * the user clicks outside of it
   * + [dismissOnClickOutside] specifies the number of milliseconds to wait
   * before dismissing it automatically.
   */
  PopupView([int this.dismissTimeout=0, bool this.dismissOnClickOutside=true]);

  //@Override
  String get className => "PopupView"; //TODO: replace with reflection if Dart supports it

  /** Returns the reference DOM element that is placed under its parent's DOM element.
   * It is used as a reference to insert a sibling.
   */
  Element get refNode => getNode("ref");
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

  /** Override to render only an invisible and empty element ([refNode]).
   * The real visual representation ([node]) is done in [mount_].
   */
  void draw(StringBuffer out) {
    out.add('<div id="').add(uuid).add('-ref" class="').add(viewConfig.classPrefix)
      .add('" style="display:none"></div>');
  }
  //@Override to change left/top of DOM (since it is in diff coordinates)
  void set left(int left) {
    _left = left;

    if (inDocument) {
      if (parent != null)
        left = new DOMQuery(refNode.parent).pageOffset.left + left;
      node.style.left = CSS.px(left);
    }
  }
  //@Override to change left/top of DOM (since it is in diff coordinates)
  void set top(int top) {
    _top = top;

    if (inDocument) {
      if (parent != null)
        top = new DOMQuery(refNode.parent).pageOffset.top + top;
      node.style.top = CSS.px(top);
    }
  }
  //@Override
  void mount_() {
    (activity.container != null ? activity.container: document.body)
      .insertAdjacentHTML("beforeEnd", _popupHTML());

    super.mount_();

    //fix the left/top of DOM (since it is in diff coordinates)
    if (parent != null) {
      final ofs = new DOMQuery(refNode.parent).pageOffset;
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
  String _popupHTML() {
    final out = new StringBuffer();
    super.draw(out);
    return out.toString();
  }
  //@Override to start dismissTimeout if necessary
  void set visible(bool visible) {
    super.visible = visible;

    _startDismissTimeout();
  }
  //@Override
  void unmount_() {
    refNode.remove();

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
