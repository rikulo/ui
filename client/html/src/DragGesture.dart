//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012 11:37:32 AM
// Author: tomyeh

/** The DragGesture callback.
 *
 * ##Signature of possible callbacks##
 *
 * `bool start(int ofsX, int ofsY)`
 *
 * The callback when [DragGesture] tries to start the dragging.
 * If it returns false, the DragGesture won't be activated (i.e., ignored).
 * The ofsX and ofsY arguments provide the offset to the left-top corner
 * of the owner element.
 *
 * `void moving(int deltaX, int deltaY;)`
 *
 * The callback used to indicate the user is dragging (i.e., moving his
 * finger).
 * The deltaX and deltaY arguments provides the number of pixels
 * that a user has scrolled (since `start` was called).
 *
 * `void end(int deltaX, int deltaY);`
 *
 * The callback used to indicate the user finishes the dragging (i.e.,
 * leaving his finger off the screen).
 * The deltaX and deltaY arguments provides the number of pixels
 * that a user has scrolled (since `start` was called).
 */
typedef DragGestureCallback(Element touched, int deltaX, int deltaY);

/**
 * A touch-and-drag gesture handler
 */
interface DragGesture default _DragGesture {
  /** Constructor.
   *
   * + [owner] is the owner of this drag gesture.
   * + [end] is the callback when the dragging is ended. Unlike other callbacks,
   * it must be specified.
   * + [handle] specifies the element that the user can drag.
   * If not specified, [owner] is assumed.
   * + [start] is the callback before starting dragging.
   * If it returns false, the dragging won't be activated.
   */
  DragGesture(Element owner, [Element handle,
  DragGestureCallback start, DragGestureCallback end, DragGestureCallback moving]);

  /** Destroys the scroller.
   * It shall be called to clean up the scroller, if it is no longer used.
   */
  void destroy();

  /** The element that owns this scroller.
   */
  Element get owner();
  /** The element that the user can drag, or null if [owner] is assumed.
   */
  Element get handle();
  /** The element that the scrolling starts with, or null if the scrolling
   * is not taking place.
   */
  Element get touched();

  /** Returns the callback to call when the user starts dragging,
   * or null if not specified.
   */
  DragGestureCallback get start();
  /** Returns the callback that will be called when the dragging is ended,
   * or null if not specified.
   */
  DragGestureCallback get end();
  /** Returns the callback that will be called when the user is dragging
   * the content, or null if not specified.
   */
  DragGestureCallback get moving();
}

abstract class _DragGesture implements DragGesture {
  _DragGesture(Element owner, [Element handle,
  DragGestureCallback start, DragGestureCallback end, DragGestureCallback moving]);
}
