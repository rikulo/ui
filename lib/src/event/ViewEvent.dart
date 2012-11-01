//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri Jan 20 14:42:46 TST 2012
// Author: tomyeh

/** A listener for handling [ViewEvent].
 */
typedef void ViewEventListener(ViewEvent event);

/**
 * A view event.
 * The event received by [View]'s event listener must be an instance of this class.
 */
class ViewEvent {
  final String _type;
  final int _stamp;
  bool _propStop = false;

  /** Constructor.
   *
   * + [type] is the event type, such as click.
   * + [target] is the view that this event is targeting. If not specified, it will
   * be assigned automatically when the sendEvent method is called.
   */
  ViewEvent(String type, [View target]):
  _type = type, _stamp = new Date.now().millisecondsSinceEpoch {
    this.target = currentTarget = target;
  }
  /** Constructor for subclassing. */
  ViewEvent._super(this._type, View target): _stamp = 0 {
    this.target = currentTarget = target;
  }


  /** Returns the view that this event is targeting  to.
   */
  View target;
  /** The view that is handling this event currently.
   */
  View currentTarget;

  /** Returns the time stamp.
   */
  int get timeStamp => _stamp;
  /** Returns the event's type. */
  String get type => _type;

  /** Returns whether this event's propagation is stopped.
   *
   * Default: false.
   *
   * It becomes true if [stopPropagation] is called,
   * and then all remaining event listeners are ignored.
   */
  bool get isPropagationStopped => _propStop;
  /** Stops the propagation.
   *Once called, all remaining event listeners, if any, are ignored.
   */
  void stopPropagation() {
    _propStop = true;
  }
  /** Prevents the browser's default behavior.
   */
  void preventDefault() {
  }
  //@override
  String toString() => "ViewEvent($target,$type)";
}

/** A view event that proxies a DOM event sent by the browser
* (such as `Event`, `UIEvent`, `MouseEvent` and `KeyboardEvent` in `dart:html`).
* The original DOM event can be found in [cause].
*/
class DOMEvent extends ViewEvent {
  final UIEvent _uic;
  final _keyInf;

  DOMEvent(Event cause, [String type, View target]):
  super._super(type != null ? type: cause.type, target),
  this.cause = cause,
  _uic = cause is UIEvent ? cause: null,
  _keyInf = cause is MouseEvent || cause is KeyboardEvent ? cause: null;

  /** The DOM event sent by the browser that causes this event to be fired.
   */
  final Event cause;
  /** The Unicode value of a character key pressed.
   */
  int get charCode => _uic != null ? _uic.charCode: 0;
  /** The Unicode value of a non-character key pressed.
   */
  int get keyCode => _uic != null ? _uic.keyCode: 0;
  /** The numeric [keyCode] of the key pressed, or the character code
   * ([charCode]) for an alphanumeric key pressed.
   */
  int get which => _uic != null ? _uic.which: 0;
  /** Indicates whether the ALT key was pressed when the event fired.
   */
  bool get altKey => _keyInf != null && _keyInf.altKey;
  /** Indicates whether the CTRL key was pressed when the event fired.
   */
  bool get ctrlKey => _keyInf != null && _keyInf.ctrlKey;
  /** Indicates whether the META key was pressed when the event fired.
   */
  bool get metaKey => _keyInf != null && _keyInf.metaKey;
  /** Indicates whether the SHIFT key was pressed when the event fired.
   */
  bool get shiftKey => _keyInf != null && _keyInf.shiftKey;

  /** The offset relative to the whole document.
   */
  Offset get pageOffset
  => _uic != null ? new Offset(_uic.pageX, _uic.pageY): new Offset(0, 0);
  /** The object in the clipboard.
   */
  Clipboard get clipboardData => cause.clipboardData;
  /** The object used to transfer data, or null if not available.
   */
  Clipboard get dataTransfer
  => cause is MouseEvent ? (cause as MouseEvent).dataTransfer: null;
  /** Returns the time stamp.
   */
  int get timeStamp => cause.timeStamp;
  //@override
  void stopPropagation() {
    super.stopPropagation();
    cause.stopPropagation();
  }
  //@override
  void preventDefault() {
    cause.preventDefault();
  }
  //@override
  String toString() => "DOMEvent($target,$cause)";
}
