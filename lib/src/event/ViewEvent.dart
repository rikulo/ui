//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri Jan 20 14:42:46 TST 2012
// Author: tomyeh
part of rikulo_event;

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
  /** Constructor for subclass. */
  ViewEvent._(this._type, View target): _stamp = 0 {
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
class DomEvent extends ViewEvent {
  factory DomEvent(Event cause, [String type, View target])
  => cause is MouseEvent ? new _MsEvent(cause, type, target):
    cause is KeyboardEvent ? new _KbEvent(cause, type, target):
    cause is UIEvent ? new _UiEvent(cause, type, target):
      new DomEvent._(cause, type, target);

  DomEvent._(Event cause, String type, View target):
  super._(type != null ? type: cause.type, target),
  this.cause = cause;

  /** The DOM event sent by the browser that causes this event to be fired.
   */
  final Event cause;

  /** The Unicode value of a character key pressed.
   */
  int get charCode => 0;
  /** The Unicode value of a non-character key pressed.
   */
  int get keyCode => 0;
  /** It normalizes [keyCode] and [charCode] if it is a keyboard event.
   * It is recommended to watch [which] for keyboard key input.
   * For more detail, read about [MDC](https://developer.mozilla.org/en-US/docs/DOM/event.which).
   *
   * It also normalizes button presses (mouseDown and mouseUp events),
   * reporting 1 for left button, 2 for middle, and 3 for right.
   */
  int get which => 0;
  /** Indicates whether Alt+Graph key was pressed when the event fire.d
   */
  bool get altGraphKey => false;
  /** Indicates whether the ALT key was pressed when the event fired.
   */
  bool get altKey => false;
  /** Indicates whether the CTRL key was pressed when the event fired.
   */
  bool get ctrlKey => false;
  /** Indicates whether the META key was pressed when the event fired.
   */
  bool get metaKey => false;
  /** Indicates whether the SHIFT key was pressed when the event fired.
   */
  bool get shiftKey => false;

  /** The offset relative to the whole document.
   */
  Offset get pageOffset => new Offset(0, 0);
  /** The object in the clipboard.
   */
  Clipboard get clipboardData => cause.clipboardData;
  /** The object used to transfer data, or null if not available.
   */
  Clipboard get dataTransfer => null;
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
  String toString() => "DomEvent($target,$cause)";
}

class _UiEvent extends DomEvent {
  _UiEvent(UIEvent cause, String type, View target):
  super._(cause, type, target);

  UIEvent get _uc => cause;

  int get charCode => _uc.$dom_charCode;
  int get keyCode => _uc.$dom_keyCode;
  int get which => _uc.which;
  Offset get pageOffset => new Offset(_uc.pageX, _uc.pageY);

  String toString() => "UiEvent($target,$cause)";
}
class _KbEvent extends _UiEvent {
  _KbEvent(KeyboardEvent cause, String type, View target):
  super(cause, type, target);

  KeyboardEvent get _kc => cause;

  int get charCode => _kc.charCode;
  int get keyCode => _kc.keyCode;
  bool get altGraphKey => _kc.altGraphKey;
  bool get altKey => _kc.altKey;
  bool get ctrlKey => _kc.ctrlKey;
  bool get metaKey => _kc.metaKey;
  bool get shiftKey => _kc.shiftKey;

  String toString() => "KeyboardEvent($target,$cause)";
}
class _MsEvent extends _UiEvent {
  _MsEvent(MouseEvent cause, String type, View target):
  super(cause, type, target);

  MouseEvent get _mc => cause;

  bool get altKey => _mc.altKey;
  bool get ctrlKey => _mc.ctrlKey;
  bool get metaKey => _mc.metaKey;
  bool get shiftKey => _mc.shiftKey;

  Clipboard get dataTransfer => _mc.dataTransfer;

  String toString() => "MouseEvent($target,$cause)";
}
