#Rikulo Changes

##0.6.6

*Upgrade Notes*

* ListDataEvent replace index and length with start and end (to be consistent with Dart SDK)
* Use Iterable instead of Collection because of Dart SDK changes.

##0.6.5

*Upgrade Notes*

* Change `packages/rikulo_ui/resource/css/default/view.css` to `packages/rikulo_ui/css/default/view.css`.

##0.6.4

* Offset and Rectangle are removed. Use Point and Rect of dart:html instead.
* Offset3d is renamed to Point3D.
* View.pageOffset is renamed to View.page

##0.6.3

* View event stream is supported. Use Steam.listen() instead. For example, view.on.click.listen((event){}).
* Data event stream is supported. Use Stream.listen() instead. For example, model.on.select.listen((event){}).
* UiError is renamed to UIError to follow Dart naming convention

##0.6.2

**Changes**

* The signature of View's sendEvent and postEvent are changed.
* `util.dart` is moved to Rikulo Commons

**Features**

* ListModel also implements Sequence
* DropDownList accepts both DataModel and List
* ViewEvent will, by default, bubble up the hierarchy of views.

##0.6.1

December 14, 2012

**Changes**

* MultilineBox is renamed to TextArea
* LayoutAmountInfo and LayoutSideInfo are renamed to AmountInfo and SideInfo
* View.tag() is simplified
* Overriding View.className is optional. It will return the class name correctly.
* View.fellows returns a map instead of a collection, and View.getFellow is removed.
* Browser.innerSize and innerOffset are removed since they are useless.

**Features:**

* 18: ProfileDeclaration supports margin to adjust the location and dimension after anchored
* Link is added for displaying and manipulating the hyperlink.

**Bugs:**

* 16: event.target may not be Element in _ViewImpl: _domEvtDisp(String)

##0.6.0

November 06, 2012

* AnimatorTask signature changed: elapsed time is not supplied.
* PopupView is removed. It can be implemented easily. Please refer to TestPopup1.dart.
* PopupEvent is renamed to ActivateEvent for broader meaning.
* View.remvoeFromDocument and removeFromParent are removed and replaced with View.remove.
* Follows Dart M2 naming convention for isXxx and similar.
* View's lifecycle is simplified. First, draw() is removed and replaced with
  render_(). Second, the DOM element is rendered as soon as `node` is accessed.
* RadioGroup is removed and replaced with RadioButton.
* TextBox no longer supports multiline. Rather, MultilineBox is introduced.
* HTMLRenderer, StringRender and ViewRenderer are removed and replaced with Renderer.
* View.addToDocument() is changed to use named parameters
* Rename DOMQuery to DOMAgent
* Move printc() to the view library
* Activity and Application were removed. Use View.addToDocument() instead.
* View.addToDocument() was simplified.
* View.outerWidth and outerHeight were renamed to realWidth and realHeight
* DOMAgent.outerWidth, outerHeight and outerSize were renamed to width, height and size
* Cordova is moved to another repository, [rikulo_gap](https://github.com/rikulo/gap).

##0.5.0

October 12, 2012

* Convert project structure to pub standard
* Remove autorun flag in Motion.
* Rename StringUtil.encodeXML/decodeXML to XMLUtil.encode/decode
* The content/src constructor of Style is renamed to fromContent/fromSrc, respectively
* The html constructor of TextView and HTMLFragment is renamed to fromHTML
* In EasingMotion, duration is renamed to period, repeat parameter is introduced, and mode is removed.
* DraggerMove's parameter updateElementPosition is renamed to defaultAction
* ScrollerMove's parameter updateScrollPosition is renamed to defaultAction
* Offset and Offset3d objects are made immutable.
* In EasingMotion, MotionAction now supplies MotionState in the arguments.
* In LinearPathMotion, the "move" argument takes an extra updateElementPosition() callback.  
* DragGesture is splitted into DragGesture and Dragger.
* Gesture models and APIs are organized and unified.
* View.hidden is renamed to View.visible.
* VectorUtil class is removed. norm() function is now a member function on Offset.
* View, by default, doesn't allow user-select, except TextView with HTML fragment.
* Rename log() function to printc() to avoid conflict with the math log function in dart:math.
* documentOffset is renamed to pageOffset
* LinearPositionMotion is renamed to LinearPathMotion.
* HoldGesture, DragGesture and Scroller are moved to the gesture package.
* RadioGroupRenderer is removed and generalized as HTMLRenderer.
* DropDownListRenderer is removed and generalized as StringRenderer.
* Rename Motion/Scroller's onMoving to onMove and moving to move.
* `ProfileDeclaration.anchor` is default to `parent` if `location` is specified.
