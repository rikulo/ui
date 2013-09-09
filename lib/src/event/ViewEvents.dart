// DO NOT EDIT
// Auto-generated
// Copyright (C) 2013 Potix Corporation. All Rights Reserved.
part of rikulo_event;

/** A map of [ViewEvent] stream providers.
 *
 * This may be used to capture DOM events:
 *
 *     EventStreams.keyDown.forTarget(element).listen(...);
 *
 * Otherwise, you can use `view.on.keyDown.listen(...)` instead (see [View]).
 */
class EventStreams {
  //View Event Streams//
  /** A broadcast event used to notify root views and any listeners of [Broadcaster] 
   * that a view or an element is *activated*.
   */
  static const ViewEventStreamProvider<ActivateEvent> activate
    = const ViewEventStreamProvider<ActivateEvent>('activate');
  static const ViewEventStreamProvider<ChangeEvent> change
    = const ViewEventStreamProvider<ChangeEvent>('change');
  /** Indicates a popup is about to be dismessed.
   * The event is sent to the popup being dismissed.
   */
  static const ViewEventStreamProvider<ViewEvent> dismiss
    = const ViewEventStreamProvider<ViewEvent>('dismiss');
  /** Indicates the layout of a view and all of its descendant views have been changed.
   *
   * See also [preLayout].
   */
  static const ViewEventStreamProvider<LayoutEvent> layout
    = const ViewEventStreamProvider<LayoutEvent>('layout');
  /// Indicates a view has been attached to a document.
  static const ViewEventStreamProvider<ViewEvent> mount
    = const ViewEventStreamProvider<ViewEvent>('mount');
  /** Indicates the layout of a view is going to be handled.
   * It is sent before handling this view and any of its descendant views.
   *
   * See also [layout].
   */
  static const ViewEventStreamProvider<LayoutEvent> preLayout
    = const ViewEventStreamProvider<LayoutEvent>('preLayout');
  /** Indicates a view has re-rendered itself because its data model has been changed.
   * It is used with views that support the data model, such as [DropDownList].
   *
   * Application usually listens to this event to invoke [View.requestLayout],
   * if the re-rending of a data model might change the layout.
   * For example, the height of [DropDownList] will be changed if
   * the multiple state is changed.
   */
  static const ViewEventStreamProvider<ViewEvent> render
    = const ViewEventStreamProvider<ViewEvent>('render');
  /// Indicates the end of a scrolling.
  static const ViewEventStreamProvider<ScrollEvent> scrollEnd
    = const ViewEventStreamProvider<ScrollEvent>('scrollEnd');
  /** Indicates the move of a scrolling. This event will be continuously
   * fired at each iteration where the scroll position is updated.
   */
  static const ViewEventStreamProvider<ScrollEvent> scrollMove
    = const ViewEventStreamProvider<ScrollEvent>('scrollMove');
  /// Indicates the start of a scrolling.
  static const ViewEventStreamProvider<ScrollEvent> scrollStart
    = const ViewEventStreamProvider<ScrollEvent>('scrollStart');
  /// Indicates the selection state of a view is changed.
  static const ViewEventStreamProvider<SelectEvent> select
    = const ViewEventStreamProvider<SelectEvent>('select');
  /// Indicates a view has been detached from a document.
  static const ViewEventStreamProvider<ViewEvent> unmount
    = const ViewEventStreamProvider<ViewEvent>('unmount');
  //DOM Event Proxy Streams//
  static const ViewEventStreamProvider<DomEvent> abort
    = const ViewEventStreamProvider<DomEvent>('abort');
  static const ViewEventStreamProvider<DomEvent> beforeCopy
    = const ViewEventStreamProvider<DomEvent>('beforeCopy');
  static const ViewEventStreamProvider<DomEvent> beforeCut
    = const ViewEventStreamProvider<DomEvent>('beforeCut');
  static const ViewEventStreamProvider<DomEvent> beforePaste
    = const ViewEventStreamProvider<DomEvent>('beforePaste');
  static const ViewEventStreamProvider<DomEvent> blur
    = const ViewEventStreamProvider<DomEvent>('blur');
  //DomEvent, change
  static const ViewEventStreamProvider<DomEvent> click
    = const ViewEventStreamProvider<DomEvent>('click');
  static const ViewEventStreamProvider<DomEvent> contextMenu
    = const ViewEventStreamProvider<DomEvent>('contextMenu');
  static const ViewEventStreamProvider<DomEvent> copy
    = const ViewEventStreamProvider<DomEvent>('copy');
  static const ViewEventStreamProvider<DomEvent> cut
    = const ViewEventStreamProvider<DomEvent>('cut');
  static const ViewEventStreamProvider<DomEvent> doubleClick
    = const ViewEventStreamProvider<DomEvent>('dblclick');
  static const ViewEventStreamProvider<DomEvent> drag
    = const ViewEventStreamProvider<DomEvent>('drag');
  static const ViewEventStreamProvider<DomEvent> dragEnd
    = const ViewEventStreamProvider<DomEvent>('dragEnd');
  static const ViewEventStreamProvider<DomEvent> dragEnter
    = const ViewEventStreamProvider<DomEvent>('dragEnter');
  static const ViewEventStreamProvider<DomEvent> dragLeave
    = const ViewEventStreamProvider<DomEvent>('dragLeave');
  static const ViewEventStreamProvider<DomEvent> dragOver
    = const ViewEventStreamProvider<DomEvent>('dragOver');
  static const ViewEventStreamProvider<DomEvent> dragStart
    = const ViewEventStreamProvider<DomEvent>('dragStart');
  static const ViewEventStreamProvider<DomEvent> drop
    = const ViewEventStreamProvider<DomEvent>('drop');
  static const ViewEventStreamProvider<DomEvent> error
    = const ViewEventStreamProvider<DomEvent>('error');
  static const ViewEventStreamProvider<DomEvent> focus
    = const ViewEventStreamProvider<DomEvent>('focus');
  static const ViewEventStreamProvider<DomEvent> input
    = const ViewEventStreamProvider<DomEvent>('input');
  static const ViewEventStreamProvider<DomEvent> invalid
    = const ViewEventStreamProvider<DomEvent>('invalid');
  static const ViewEventStreamProvider<DomEvent> keyDown
    = const ViewEventStreamProvider<DomEvent>('keyDown');
  static const ViewEventStreamProvider<DomEvent> keyPress
    = const ViewEventStreamProvider<DomEvent>('keyPress');
  static const ViewEventStreamProvider<DomEvent> keyUp
    = const ViewEventStreamProvider<DomEvent>('keyUp');
  static const ViewEventStreamProvider<DomEvent> load
    = const ViewEventStreamProvider<DomEvent>('load');
  static const ViewEventStreamProvider<DomEvent> mouseDown
    = const ViewEventStreamProvider<DomEvent>('mouseDown');
  static const ViewEventStreamProvider<DomEvent> mouseMove
    = const ViewEventStreamProvider<DomEvent>('mouseMove');
  static const ViewEventStreamProvider<DomEvent> mouseOut
    = const ViewEventStreamProvider<DomEvent>('mouseOut');
  static const ViewEventStreamProvider<DomEvent> mouseOver
    = const ViewEventStreamProvider<DomEvent>('mouseOver');
  static const ViewEventStreamProvider<DomEvent> mouseUp
    = const ViewEventStreamProvider<DomEvent>('mouseUp');
  static const ViewEventStreamProvider<DomEvent> mouseWheel
    = const ViewEventStreamProvider<DomEvent>('mouseWheel');
  static const ViewEventStreamProvider<DomEvent> paste
    = const ViewEventStreamProvider<DomEvent>('paste');
  static const ViewEventStreamProvider<DomEvent> reset
    = const ViewEventStreamProvider<DomEvent>('reset');
  static const ViewEventStreamProvider<DomEvent> scroll
    = const ViewEventStreamProvider<DomEvent>('scroll');
  static const ViewEventStreamProvider<DomEvent> search
    = const ViewEventStreamProvider<DomEvent>('search');
  //DomEvent, select
  static const ViewEventStreamProvider<DomEvent> selectStart
    = const ViewEventStreamProvider<DomEvent>('selectStart');
  static const ViewEventStreamProvider<DomEvent> submit
    = const ViewEventStreamProvider<DomEvent>('submit');
  static const ViewEventStreamProvider<DomEvent> touchCancel
    = const ViewEventStreamProvider<DomEvent>('touchCancel');
  static const ViewEventStreamProvider<DomEvent> touchEnd
    = const ViewEventStreamProvider<DomEvent>('touchEnd');
  static const ViewEventStreamProvider<DomEvent> touchEnter
    = const ViewEventStreamProvider<DomEvent>('touchEnter');
  static const ViewEventStreamProvider<DomEvent> touchLeave
    = const ViewEventStreamProvider<DomEvent>('touchLeave');
  static const ViewEventStreamProvider<DomEvent> touchMove
    = const ViewEventStreamProvider<DomEvent>('touchMove');
  static const ViewEventStreamProvider<DomEvent> touchStart
    = const ViewEventStreamProvider<DomEvent>('touchStart');
  static const ViewEventStreamProvider<DomEvent> transitionEnd
    = const ViewEventStreamProvider<DomEvent>('webkitTransitionEnd');
  static const ViewEventStreamProvider<DomEvent> fullscreenChange
    = const ViewEventStreamProvider<DomEvent>('webkitFullscreenChange');
  static const ViewEventStreamProvider<DomEvent> fullscreenError
    = const ViewEventStreamProvider<DomEvent>('webkitFullscreenError');
}

///A map of [ViewEvent] streams
class ViewEvents {
  final StreamTarget<ViewEvent> _owner;
  ViewEvents(this._owner);

  //View Event Streams//
  /** A broadcast event used to notify root views and any listeners of [Broadcaster] 
   * that a view or an element is *activated*.
   */
  Stream<ActivateEvent> get activate => EventStreams.activate.forTarget(_owner);
  Stream<ChangeEvent> get change => EventStreams.change.forTarget(_owner);
  /** Indicates a popup is about to be dismessed.
   * The event is sent to the popup being dismissed.
   */
  Stream<ViewEvent> get dismiss => EventStreams.dismiss.forTarget(_owner);
  /** Indicates the layout of a view and all of its descendant views have been changed.
   *
   * See also [preLayout].
   */
  Stream<LayoutEvent> get layout => EventStreams.layout.forTarget(_owner);
  /// Indicates a view has been attached to a document.
  Stream<ViewEvent> get mount => EventStreams.mount.forTarget(_owner);
  /** Indicates the layout of a view is going to be handled.
   * It is sent before handling this view and any of its descendant views.
   *
   * See also [layout].
   */
  Stream<LayoutEvent> get preLayout => EventStreams.preLayout.forTarget(_owner);
  /** Indicates a view has re-rendered itself because its data model has been changed.
   * It is used with views that support the data model, such as [DropDownList].
   *
   * Application usually listens to this event to invoke [View.requestLayout],
   * if the re-rending of a data model might change the layout.
   * For example, the height of [DropDownList] will be changed if
   * the multiple state is changed.
   */
  Stream<ViewEvent> get render => EventStreams.render.forTarget(_owner);
  /// Indicates the end of a scrolling.
  Stream<ScrollEvent> get scrollEnd => EventStreams.scrollEnd.forTarget(_owner);
  /** Indicates the move of a scrolling. This event will be continuously
   * fired at each iteration where the scroll position is updated.
   */
  Stream<ScrollEvent> get scrollMove => EventStreams.scrollMove.forTarget(_owner);
  /// Indicates the start of a scrolling.
  Stream<ScrollEvent> get scrollStart => EventStreams.scrollStart.forTarget(_owner);
  /// Indicates the selection state of a view is changed.
  Stream<SelectEvent> get select => EventStreams.select.forTarget(_owner);
  /// Indicates a view has been detached from a document.
  Stream<ViewEvent> get unmount => EventStreams.unmount.forTarget(_owner);
  //DOM Event Proxy Streams//
  Stream<DomEvent> get abort => EventStreams.abort.forTarget(_owner);
  Stream<DomEvent> get beforeCopy => EventStreams.beforeCopy.forTarget(_owner);
  Stream<DomEvent> get beforeCut => EventStreams.beforeCut.forTarget(_owner);
  Stream<DomEvent> get beforePaste => EventStreams.beforePaste.forTarget(_owner);
  Stream<DomEvent> get blur => EventStreams.blur.forTarget(_owner);
  //DomEvent, change
  Stream<DomEvent> get click => EventStreams.click.forTarget(_owner);
  Stream<DomEvent> get contextMenu => EventStreams.contextMenu.forTarget(_owner);
  Stream<DomEvent> get copy => EventStreams.copy.forTarget(_owner);
  Stream<DomEvent> get cut => EventStreams.cut.forTarget(_owner);
  Stream<DomEvent> get doubleClick => EventStreams.doubleClick.forTarget(_owner);
  Stream<DomEvent> get drag => EventStreams.drag.forTarget(_owner);
  Stream<DomEvent> get dragEnd => EventStreams.dragEnd.forTarget(_owner);
  Stream<DomEvent> get dragEnter => EventStreams.dragEnter.forTarget(_owner);
  Stream<DomEvent> get dragLeave => EventStreams.dragLeave.forTarget(_owner);
  Stream<DomEvent> get dragOver => EventStreams.dragOver.forTarget(_owner);
  Stream<DomEvent> get dragStart => EventStreams.dragStart.forTarget(_owner);
  Stream<DomEvent> get drop => EventStreams.drop.forTarget(_owner);
  Stream<DomEvent> get error => EventStreams.error.forTarget(_owner);
  Stream<DomEvent> get focus => EventStreams.focus.forTarget(_owner);
  Stream<DomEvent> get input => EventStreams.input.forTarget(_owner);
  Stream<DomEvent> get invalid => EventStreams.invalid.forTarget(_owner);
  Stream<DomEvent> get keyDown => EventStreams.keyDown.forTarget(_owner);
  Stream<DomEvent> get keyPress => EventStreams.keyPress.forTarget(_owner);
  Stream<DomEvent> get keyUp => EventStreams.keyUp.forTarget(_owner);
  Stream<DomEvent> get load => EventStreams.load.forTarget(_owner);
  Stream<DomEvent> get mouseDown => EventStreams.mouseDown.forTarget(_owner);
  Stream<DomEvent> get mouseMove => EventStreams.mouseMove.forTarget(_owner);
  Stream<DomEvent> get mouseOut => EventStreams.mouseOut.forTarget(_owner);
  Stream<DomEvent> get mouseOver => EventStreams.mouseOver.forTarget(_owner);
  Stream<DomEvent> get mouseUp => EventStreams.mouseUp.forTarget(_owner);
  Stream<DomEvent> get mouseWheel => EventStreams.mouseWheel.forTarget(_owner);
  Stream<DomEvent> get paste => EventStreams.paste.forTarget(_owner);
  Stream<DomEvent> get reset => EventStreams.reset.forTarget(_owner);
  Stream<DomEvent> get scroll => EventStreams.scroll.forTarget(_owner);
  Stream<DomEvent> get search => EventStreams.search.forTarget(_owner);
  //DomEvent, select
  Stream<DomEvent> get selectStart => EventStreams.selectStart.forTarget(_owner);
  Stream<DomEvent> get submit => EventStreams.submit.forTarget(_owner);
  Stream<DomEvent> get touchCancel => EventStreams.touchCancel.forTarget(_owner);
  Stream<DomEvent> get touchEnd => EventStreams.touchEnd.forTarget(_owner);
  Stream<DomEvent> get touchEnter => EventStreams.touchEnter.forTarget(_owner);
  Stream<DomEvent> get touchLeave => EventStreams.touchLeave.forTarget(_owner);
  Stream<DomEvent> get touchMove => EventStreams.touchMove.forTarget(_owner);
  Stream<DomEvent> get touchStart => EventStreams.touchStart.forTarget(_owner);
  Stream<DomEvent> get transitionEnd => EventStreams.transitionEnd.forTarget(_owner);
  Stream<DomEvent> get fullscreenChange => EventStreams.fullscreenChange.forTarget(_owner);
  Stream<DomEvent> get fullscreenError => EventStreams.fullscreenError.forTarget(_owner);
}

///A list of DOM events
const List<String> domEvents = const ['change', 'abort', 'beforeCopy', 'beforeCut', 'beforePaste', 'blur', 'click', 'contextMenu', 'copy', 'cut', 'dblclick', 'drag', 'dragEnd', 'dragEnter', 'dragLeave', 'dragOver', 'dragStart', 'drop', 'error', 'focus', 'input', 'invalid', 'keyDown', 'keyPress', 'keyUp', 'load', 'mouseDown', 'mouseMove', 'mouseOut', 'mouseOver', 'mouseUp', 'mouseWheel', 'paste', 'reset', 'scroll', 'search', 'selectStart', 'submit', 'touchCancel', 'touchEnd', 'touchEnter', 'touchLeave', 'touchMove', 'touchStart', 'webkitTransitionEnd', 'webkitFullscreenChange', 'webkitFullscreenError'];
