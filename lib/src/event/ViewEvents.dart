// DO NOT EDIT
// Auto-generated
// Copyright (C) 2013 Potix Corporation. All Rights Reserved.
part of rikulo_event;

//View Event Streams//
const ViewEventStreamProvider<ActivateEvent> activateEvent = const ViewEventStreamProvider<ActivateEvent>('activate');
const ViewEventStreamProvider<ChangeEvent> changeEvent = const ViewEventStreamProvider<ChangeEvent>('change');
const ViewEventStreamProvider<ViewEvent> dismissEvent = const ViewEventStreamProvider<ViewEvent>('dismiss');
const ViewEventStreamProvider<LayoutEvent> layoutEvent = const ViewEventStreamProvider<LayoutEvent>('layout');
const ViewEventStreamProvider<ViewEvent> mountEvent = const ViewEventStreamProvider<ViewEvent>('mount');
const ViewEventStreamProvider<LayoutEvent> preLayoutEvent = const ViewEventStreamProvider<LayoutEvent>('preLayout');
const ViewEventStreamProvider<ViewEvent> renderEvent = const ViewEventStreamProvider<ViewEvent>('render');
const ViewEventStreamProvider<ScrollEvent> scrollEndEvent = const ViewEventStreamProvider<ScrollEvent>('scrollEnd');
const ViewEventStreamProvider<ScrollEvent> scrollMoveEvent = const ViewEventStreamProvider<ScrollEvent>('scrollMove');
const ViewEventStreamProvider<ScrollEvent> scrollStartEvent = const ViewEventStreamProvider<ScrollEvent>('scrollStart');
const ViewEventStreamProvider<SelectEvent> selectEvent = const ViewEventStreamProvider<SelectEvent>('select');
const ViewEventStreamProvider<ViewEvent> unmountEvent = const ViewEventStreamProvider<ViewEvent>('unmount');
//DOM Event Proxy Streams//
const ViewEventStreamProvider<DomEvent> abortEvent = const ViewEventStreamProvider<DomEvent>('abort');
const ViewEventStreamProvider<DomEvent> beforeCopyEvent = const ViewEventStreamProvider<DomEvent>('beforeCopy');
const ViewEventStreamProvider<DomEvent> beforeCutEvent = const ViewEventStreamProvider<DomEvent>('beforeCut');
const ViewEventStreamProvider<DomEvent> beforePasteEvent = const ViewEventStreamProvider<DomEvent>('beforePaste');
const ViewEventStreamProvider<DomEvent> blurEvent = const ViewEventStreamProvider<DomEvent>('blur');
//DomEvent, change
const ViewEventStreamProvider<DomEvent> clickEvent = const ViewEventStreamProvider<DomEvent>('click');
const ViewEventStreamProvider<DomEvent> contextMenuEvent = const ViewEventStreamProvider<DomEvent>('contextMenu');
const ViewEventStreamProvider<DomEvent> copyEvent = const ViewEventStreamProvider<DomEvent>('copy');
const ViewEventStreamProvider<DomEvent> cutEvent = const ViewEventStreamProvider<DomEvent>('cut');
const ViewEventStreamProvider<DomEvent> doubleClickEvent = const ViewEventStreamProvider<DomEvent>('dblclick');
const ViewEventStreamProvider<DomEvent> dragEvent = const ViewEventStreamProvider<DomEvent>('drag');
const ViewEventStreamProvider<DomEvent> dragEndEvent = const ViewEventStreamProvider<DomEvent>('dragEnd');
const ViewEventStreamProvider<DomEvent> dragEnterEvent = const ViewEventStreamProvider<DomEvent>('dragEnter');
const ViewEventStreamProvider<DomEvent> dragLeaveEvent = const ViewEventStreamProvider<DomEvent>('dragLeave');
const ViewEventStreamProvider<DomEvent> dragOverEvent = const ViewEventStreamProvider<DomEvent>('dragOver');
const ViewEventStreamProvider<DomEvent> dragStartEvent = const ViewEventStreamProvider<DomEvent>('dragStart');
const ViewEventStreamProvider<DomEvent> dropEvent = const ViewEventStreamProvider<DomEvent>('drop');
const ViewEventStreamProvider<DomEvent> errorEvent = const ViewEventStreamProvider<DomEvent>('error');
const ViewEventStreamProvider<DomEvent> focusEvent = const ViewEventStreamProvider<DomEvent>('focus');
const ViewEventStreamProvider<DomEvent> inputEvent = const ViewEventStreamProvider<DomEvent>('input');
const ViewEventStreamProvider<DomEvent> invalidEvent = const ViewEventStreamProvider<DomEvent>('invalid');
const ViewEventStreamProvider<DomEvent> keyDownEvent = const ViewEventStreamProvider<DomEvent>('keyDown');
const ViewEventStreamProvider<DomEvent> keyPressEvent = const ViewEventStreamProvider<DomEvent>('keyPress');
const ViewEventStreamProvider<DomEvent> keyUpEvent = const ViewEventStreamProvider<DomEvent>('keyUp');
const ViewEventStreamProvider<DomEvent> loadEvent = const ViewEventStreamProvider<DomEvent>('load');
const ViewEventStreamProvider<DomEvent> mouseDownEvent = const ViewEventStreamProvider<DomEvent>('mouseDown');
const ViewEventStreamProvider<DomEvent> mouseMoveEvent = const ViewEventStreamProvider<DomEvent>('mouseMove');
const ViewEventStreamProvider<DomEvent> mouseOutEvent = const ViewEventStreamProvider<DomEvent>('mouseOut');
const ViewEventStreamProvider<DomEvent> mouseOverEvent = const ViewEventStreamProvider<DomEvent>('mouseOver');
const ViewEventStreamProvider<DomEvent> mouseUpEvent = const ViewEventStreamProvider<DomEvent>('mouseUp');
const ViewEventStreamProvider<DomEvent> mouseWheelEvent = const ViewEventStreamProvider<DomEvent>('mouseWheel');
const ViewEventStreamProvider<DomEvent> pasteEvent = const ViewEventStreamProvider<DomEvent>('paste');
const ViewEventStreamProvider<DomEvent> resetEvent = const ViewEventStreamProvider<DomEvent>('reset');
const ViewEventStreamProvider<DomEvent> scrollEvent = const ViewEventStreamProvider<DomEvent>('scroll');
const ViewEventStreamProvider<DomEvent> searchEvent = const ViewEventStreamProvider<DomEvent>('search');
//DomEvent, select
const ViewEventStreamProvider<DomEvent> selectStartEvent = const ViewEventStreamProvider<DomEvent>('selectStart');
const ViewEventStreamProvider<DomEvent> submitEvent = const ViewEventStreamProvider<DomEvent>('submit');
const ViewEventStreamProvider<DomEvent> touchCancelEvent = const ViewEventStreamProvider<DomEvent>('touchCancel');
const ViewEventStreamProvider<DomEvent> touchEndEvent = const ViewEventStreamProvider<DomEvent>('touchEnd');
const ViewEventStreamProvider<DomEvent> touchEnterEvent = const ViewEventStreamProvider<DomEvent>('touchEnter');
const ViewEventStreamProvider<DomEvent> touchLeaveEvent = const ViewEventStreamProvider<DomEvent>('touchLeave');
const ViewEventStreamProvider<DomEvent> touchMoveEvent = const ViewEventStreamProvider<DomEvent>('touchMove');
const ViewEventStreamProvider<DomEvent> touchStartEvent = const ViewEventStreamProvider<DomEvent>('touchStart');
const ViewEventStreamProvider<DomEvent> transitionEndEvent = const ViewEventStreamProvider<DomEvent>('webkitTransitionEnd');
const ViewEventStreamProvider<DomEvent> fullscreenChangeEvent = const ViewEventStreamProvider<DomEvent>('webkitFullscreenChange');
const ViewEventStreamProvider<DomEvent> fullscreenErrorEvent = const ViewEventStreamProvider<DomEvent>('webkitFullscreenError');

///A list of DOM events
const List<String> domEvents = const ['change', 'abort', 'beforeCopy', 'beforeCut', 'beforePaste', 'blur', 'click', 'contextMenu', 'copy', 'cut', 'dblclick', 'drag', 'dragEnd', 'dragEnter', 'dragLeave', 'dragOver', 'dragStart', 'drop', 'error', 'focus', 'input', 'invalid', 'keyDown', 'keyPress', 'keyUp', 'load', 'mouseDown', 'mouseMove', 'mouseOut', 'mouseOver', 'mouseUp', 'mouseWheel', 'paste', 'reset', 'scroll', 'search', 'selectStart', 'submit', 'touchCancel', 'touchEnd', 'touchEnter', 'touchLeave', 'touchMove', 'touchStart', 'webkitTransitionEnd', 'webkitFullscreenChange', 'webkitFullscreenError'];

///A map of [ViewEvent] streams
class ViewEvents {
  final ViewEventTarget _owner;
  ViewEvents(ViewEventTarget owner): _owner = owner;

  Stream<ActivateEvent> get activate => activateEvent.forTarget(_owner);
  Stream<ChangeEvent> get change => changeEvent.forTarget(_owner);
  Stream<ViewEvent> get dismiss => dismissEvent.forTarget(_owner);
  Stream<LayoutEvent> get layout => layoutEvent.forTarget(_owner);
  Stream<ViewEvent> get mount => mountEvent.forTarget(_owner);
  Stream<LayoutEvent> get preLayout => preLayoutEvent.forTarget(_owner);
  Stream<ViewEvent> get render => renderEvent.forTarget(_owner);
  Stream<ScrollEvent> get scrollEnd => scrollEndEvent.forTarget(_owner);
  Stream<ScrollEvent> get scrollMove => scrollMoveEvent.forTarget(_owner);
  Stream<ScrollEvent> get scrollStart => scrollStartEvent.forTarget(_owner);
  Stream<SelectEvent> get select => selectEvent.forTarget(_owner);
  Stream<ViewEvent> get unmount => unmountEvent.forTarget(_owner);
  Stream<DomEvent> get abort => abortEvent.forTarget(_owner);
  Stream<DomEvent> get beforeCopy => beforeCopyEvent.forTarget(_owner);
  Stream<DomEvent> get beforeCut => beforeCutEvent.forTarget(_owner);
  Stream<DomEvent> get beforePaste => beforePasteEvent.forTarget(_owner);
  Stream<DomEvent> get blur => blurEvent.forTarget(_owner);
  Stream<DomEvent> get click => clickEvent.forTarget(_owner);
  Stream<DomEvent> get contextMenu => contextMenuEvent.forTarget(_owner);
  Stream<DomEvent> get copy => copyEvent.forTarget(_owner);
  Stream<DomEvent> get cut => cutEvent.forTarget(_owner);
  Stream<DomEvent> get doubleClick => doubleClickEvent.forTarget(_owner);
  Stream<DomEvent> get drag => dragEvent.forTarget(_owner);
  Stream<DomEvent> get dragEnd => dragEndEvent.forTarget(_owner);
  Stream<DomEvent> get dragEnter => dragEnterEvent.forTarget(_owner);
  Stream<DomEvent> get dragLeave => dragLeaveEvent.forTarget(_owner);
  Stream<DomEvent> get dragOver => dragOverEvent.forTarget(_owner);
  Stream<DomEvent> get dragStart => dragStartEvent.forTarget(_owner);
  Stream<DomEvent> get drop => dropEvent.forTarget(_owner);
  Stream<DomEvent> get error => errorEvent.forTarget(_owner);
  Stream<DomEvent> get focus => focusEvent.forTarget(_owner);
  Stream<DomEvent> get input => inputEvent.forTarget(_owner);
  Stream<DomEvent> get invalid => invalidEvent.forTarget(_owner);
  Stream<DomEvent> get keyDown => keyDownEvent.forTarget(_owner);
  Stream<DomEvent> get keyPress => keyPressEvent.forTarget(_owner);
  Stream<DomEvent> get keyUp => keyUpEvent.forTarget(_owner);
  Stream<DomEvent> get load => loadEvent.forTarget(_owner);
  Stream<DomEvent> get mouseDown => mouseDownEvent.forTarget(_owner);
  Stream<DomEvent> get mouseMove => mouseMoveEvent.forTarget(_owner);
  Stream<DomEvent> get mouseOut => mouseOutEvent.forTarget(_owner);
  Stream<DomEvent> get mouseOver => mouseOverEvent.forTarget(_owner);
  Stream<DomEvent> get mouseUp => mouseUpEvent.forTarget(_owner);
  Stream<DomEvent> get mouseWheel => mouseWheelEvent.forTarget(_owner);
  Stream<DomEvent> get paste => pasteEvent.forTarget(_owner);
  Stream<DomEvent> get reset => resetEvent.forTarget(_owner);
  Stream<DomEvent> get scroll => scrollEvent.forTarget(_owner);
  Stream<DomEvent> get search => searchEvent.forTarget(_owner);
  Stream<DomEvent> get selectStart => selectStartEvent.forTarget(_owner);
  Stream<DomEvent> get submit => submitEvent.forTarget(_owner);
  Stream<DomEvent> get touchCancel => touchCancelEvent.forTarget(_owner);
  Stream<DomEvent> get touchEnd => touchEndEvent.forTarget(_owner);
  Stream<DomEvent> get touchEnter => touchEnterEvent.forTarget(_owner);
  Stream<DomEvent> get touchLeave => touchLeaveEvent.forTarget(_owner);
  Stream<DomEvent> get touchMove => touchMoveEvent.forTarget(_owner);
  Stream<DomEvent> get touchStart => touchStartEvent.forTarget(_owner);
  Stream<DomEvent> get transitionEnd => transitionEndEvent.forTarget(_owner);
  Stream<DomEvent> get fullscreenChange => fullscreenChangeEvent.forTarget(_owner);
  Stream<DomEvent> get fullscreenError => fullscreenErrorEvent.forTarget(_owner);
}
