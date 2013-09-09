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
 *
 * Notice that the event will bubble up through the hierarchy of views. It
 * is convenient if you'd like to handle the events of children. For example,
 * you can handle the click event for all child buttons as follows:
 *
 *     view.on.click((event) {
 *       switch (event.target.id) { //target is the view firing the event
 *         case "OK": //submit
 *         case "Cancel": //...
 *       }
 *     });
 *
 * Sometimes it might cause a problem. For example, [LayoutEvent] will be sent
 * to every views and then bubbles up. It means your `layout` listener usually
 * has to filter events not belonging to the target view. It can be done easily
 * by use `event.target == event.currentTarget'. For example,
 *
 *     view.on.layout((event) {
 *       if (event.target == event.currentTarget) {
 *          //handle event.target
 *       }
 *     })
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
  _type = type, _stamp = new DateTime.now().millisecondsSinceEpoch {
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
  @override
  String toString() => "ViewEvent($target,$type)";
}

/** A view event that proxies a DOM event sent by the browser
* (such as `Event`, `UIEvent`, `MouseEvent` and `KeyboardEvent` in `dart:html`).
* The original DOM event can be found in [cause].
*/
class DomEvent extends ViewEvent {
  factory DomEvent(Event cause, [String type, View target])
  => cause is MouseEvent ? new _MSEvent(cause, type, target):
    cause is KeyboardEvent ? new _KBEvent(cause, type, target):
    cause is UIEvent ? new _UIEvent(cause, type, target):
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

  /** The offset of the mouse pointer relative to the whole document.
   */
  Point get page => new Point(0, 0);
  /** The offset of the mouse pointer in the target node coordinate.
   * It is available only if [cause] is `MouseEvent`.
   *
   * This value may vary between platforms if the target node moves
   * after the event has fired or if the element has CSS transforms affecting it.
   */
  Point get offset => new Point(0, 0);
  /** The object in the clipboard.
   */
  DataTransfer get clipboardData => cause.clipboardData;
  /** The object used to transfer data, or null if not available.
   */
  DataTransfer get dataTransfer => null;
  /** Returns the time stamp.
   */
  int get timeStamp => cause.timeStamp;

  @override
  void stopPropagation() {
    super.stopPropagation();
    cause.stopPropagation();
  }
  @override
  void preventDefault() {
    cause.preventDefault();
  }
  @override
  String toString() => "DomEvent($target,$cause)";
}

class _UIEvent extends DomEvent {
  _UIEvent(UIEvent cause, String type, View target):
  super._(cause, type, target);

  UIEvent get _uc => cause;

  int get which => _uc.which;
  Point get page => _uc.page;

  String toString() => "UIEvent($target,$cause)";
}
class _KBEvent extends _UIEvent {
  _KBEvent(KeyboardEvent cause, String type, View target):
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
class _MSEvent extends _UIEvent {
  _MSEvent(MouseEvent cause, String type, View target):
  super(cause, type, target);

  MouseEvent get _mc => cause;

  bool get altKey => _mc.altKey;
  bool get ctrlKey => _mc.ctrlKey;
  bool get metaKey => _mc.metaKey;
  bool get shiftKey => _mc.shiftKey;

  Point get offset => _mc.offset;
  DataTransfer get dataTransfer => _mc.dataTransfer;

  String toString() => "MouseEvent($target,$cause)";
}

/**
 * An event to indicate activation.
 * It is a broadcast event used to notify root views and any listeners
 * that a view or an element is *activated*. By activated it means the view
 * or the element will become the *focal point* for users to interact with.
 * For example, it happens when the user clicks on a view or an element
 * (it is done automatically).
 * If the application wants to bring some view to the top, it can broadcast
 * this event too.
 *
 *     broadcaster.sendEvent(new ActivateEvent(activatedView));
 *
 * Views that acts as popups shall then dismiss themselves when receiving this event.
 * For example,
 *
 *     class Popup extends View {
 *       Popup() {
 *         on.activate.add((event) {
 *           if (event.shallClose(this))
 *             remove();
 *         });
 *       }
 *     }
 *
 * If the popup is not the root view, it has to register an event listener to
 * [broadcaster].
 *
 * > By popup we mean a UI object that is shown up
 * only in short period of time, and dismissed as soon as the user takes an action.
 * Typical examples include a popup menu and an information bubble.
 */
class ActivateEvent extends ViewEvent {
  final _source;

  /** Constructor.
   * The source parameter is either an instance of [View], a DOM element, or null.
   * If null, it means all pop ups shall be closed.
   */
  ActivateEvent(var source, [String type="activate"]):
  _source = source, super(type) {
  }
  /** Returns the UI object triggers this event.
   * It is either a view or a DOM element.
   */
  get source => _source;

  /** Whether the given view or element shall be closed.
   *
   * + [popup] is either a view or an element.
   */
  bool shallClose(popup) {
    if (source == null)
      return true;

    var srcNode, popNode;
    if (source is View) {
      if (popup is View)
        return !source.isDescendantOf(popup);
      srcNode = source.node;
      popNode = popup;
    } else {
      srcNode = source;
      popNode = popup is View ? popup.node: popup;
    }
    return !DomUtil.isDescendant(srcNode, popNode);
  }
}

/**
 * An event to indicate a view's value has been changed.
 * It is sent with [ViewEvents.change].
 */
class ChangeEvent<T> extends ViewEvent {
  final T _value;
  ChangeEvent(T value, [String type="change", View target]):
  super(type, target), _value = value;

  /** Returns the value.
   */
  T get value => _value;

  String toString() => "ChangeEvent($target,$value)";
}

/**
 * A layout event. It is sent with [ViewEvents.layout] and [ViewEvents.preLayout].
 */
class LayoutEvent extends ViewEvent {
  final MeasureContext _context;
  LayoutEvent(MeasureContext context, [String type="layout", View target]):
  super(type, target), _context = context;

  /** Returns the context.
   */
  MeasureContext get context => _context;

  String toString() => "LayoutEvent($target)";
}

/** Event representing scrolling.
 */
class ScrollEvent extends ViewEvent {
  
  final ScrollerState state;
  
  /** Constructor
   * 
   */
  ScrollEvent(String type, View target, this.state) : 
    super(type, target);
}

/**
 * A select event. It is sent with [ViewEvents.select].
 */
class SelectEvent<T> extends ViewEvent {
  final Iterable<T> _selectedValues;
  final int _selectedIndex;

  /** Constructor.
   *
   * + [selectedValues] is the set of selected values. It can't be null.
   * + [selectedIndex] is the index of the first selected value, or -1
   * if [selectedValues] is empty.
   */
  SelectEvent(Iterable<T> selectedValues, int selectedIndex, [String type="select", View target]):
  super(type, target), _selectedValues = selectedValues, _selectedIndex = selectedIndex;

  /** Returns the selected values.
   */
  Iterable<T> get selectedValues => _selectedValues;
  /** Returns the first selected value, or null if no selected value.
   */
  T get selectedValue => _selectedValues.isEmpty ? null: _selectedValues.first;

  /** Returns the first selected index, or -1 if none is selected.
   *
   * Notice that [selectedIndex] is meaningless for `TreeModel`.
   */
  int get selectedIndex => _selectedIndex;

  String toString() => "SelectEvent($target, $selectedValues, $selectedIndex)";
}

/**
 * A factory to expose [View]'s events as Streams.
 */
class ViewEventStreamProvider<T extends ViewEvent> extends StreamProvider<T> {
  const ViewEventStreamProvider(String eventType): super(eventType);
}
