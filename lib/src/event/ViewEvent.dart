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

/** A event is actually triggered by a DOM event
* (such as `UIEvent`, `MouseEvent` and `KeyboardEvent`).
* The original DOM event can be found in [domEvent].
*/
class DOMEvent extends ViewEvent {
  final UIEvent _uiEvt;
  final _anyEvt;
  Offset _offset;

  DOMEvent(Event domEvent, [String type, View target]):
  super._super(type != null ? type: domEvent.type, target),
  this.domEvent = domEvent,
  _uiEvt = domEvent is UIEvent ? domEvent: null,
  _anyEvt = domEvent is KeyboardEvent || domEvent is MouseEvent ? domEvent: null;

  /** The DOM event that causes this view event.
   */
  final Event domEvent;
  /** The Unicode value of a character key pressed.
   */
  int get charCode => _uiEvt != null ? _uiEvt.charCode: 0;
  /** The Unicode value of a non-character key pressed.
   */
  int get keyCode => _uiEvt != null ? _uiEvt.keyCode: 0;
  /** The numeric [keyCode] of the key pressed, or the character code
   * ([charCode]) for an alphanumeric key pressed.
   */
  int get which => _uiEvt != null ? _uiEvt.which: 0;
  /** Indicates whether the ALT key was pressed when the event fired.
   */
  bool get altKey => _anyEvt != null && _anyEvt.altKey;
  /** Indicates whether the CTRL key was pressed when the event fired.
   */
  bool get ctrlKey => _anyEvt != null && _anyEvt.ctrlKey;
  /** Indicates whether the META key was pressed when the event fired.
   */
  bool get metaKey => _anyEvt != null && _anyEvt.metaKey;
  /** Indicates whether the SHIFT key was pressed when the event fired.
   */
  bool get shiftKey => _anyEvt != null && _anyEvt.shiftKey;
  /** The offset relative to [target]'s coordinate.
   */
  Offset get offset {
    if (_offset == null)
      _offset = _uiEvt == null ? new Offset(0, 0):
        new Offset(_uiEvt.pageX, _uiEvt.pageY) - new DOMAgent(target.node).pageOffset;
    return _offset;
  }
  /** The offset relative to the whole document.
   */
  Offset get pageOffset
  => _uiEvt != null ? new Offset(_uiEvt.pageX, _uiEvt.pageY): new Offset(0, 0);
  /** The object in the clipboard.
   */
  Clipboard get clipboardData => domEvent.clipboardData;
  /** The object used to transfer data, or null if not available.
   */
  Clipboard get dataTransfer
  => domEvent is MouseEvent ? (domEvent as MouseEvent).dataTransfer: null;
  /** Returns the time stamp.
   */
  int get timeStamp => domEvent.timeStamp;
  //@override
  void stopPropagation() {
    super.stopPropagation();
    domEvent.stopPropagation();
  }
  //@override
  void preventDefault() {
    domEvent.preventDefault();
  }
  //@override
  String toString() => "DOMEvent($target,$domEvent)";
}
