#Rikulo Changes

##0.6.0

**October 26, 2012**

* View's lifecycle is simplified. First, draw() is removed and replaced with
  render_(). Second, the DOM element is rendered as soon as `node` is accessed.
* RadioGroup is removed and replaced with RadioButton.
* TextBox no longer supports multiline. Rather, MultilineBox is introduced.
* HTMLRenderer, StringRender and ViewRenderer are removed and replaced with Renderer.
* PopupView is removed. It can be implemented easily. Please refer to TestPopup1.dart.

**October 20, 2012**

* View.addToDocument() is changed to use named parameters
* Rename DOMQuery to DOMAgent
* Move printc() to the view library

**October 15, 2012**

* Activity and Application were removed. Use View.addToDocument() instead.
* View.addToDocument() was simplified.
* View.outerWidth and outerHeight were renamed to realWidth and realHeight
* DOMAgent.outerWidth, outerHeight and outerSize were renamed to width, height and size
* Cordova is moved to another repository, [rikulo_gap](https://github.com/rikulo/rikulo-gap).

##0.6.1

**September 25, 2012**

* Convert project structure to pub standard
* Remove autorun flag in Motion.

**September 11, 2012**

* Rename StringUtil.encodeXML/decodeXML to XMLUtil.encode/decode
* The content/src constructor of Style is renamed to fromContent/fromSrc, respectively
* The html constructor of TextView and HTMLFragment is renamed to fromHTML
* In EasingMotion, duration is renamed to period, repeat parameter is introduced, and mode is removed.
* DraggerMove's parameter updateElementPosition is renamed to defaultAction
* ScrollerMove's parameter updateScrollPosition is renamed to defaultAction

**August 31, 2012**

* Offset and Offset3d objects are made immutable.

**August 30, 2012**

* In EasingMotion, MotionAction now supplies MotionState in the arguments.
* In LinearPathMotion, the "move" argument takes an extra updateElementPosition() callback.  

**August 21, 2012**

* DragGesture is splitted into DragGesture and Dragger.
* Gesture models and APIs are organized and unified.

**August 14, 2012**

* View.hidden is renamed to View.visible.
* VectorUtil class is removed. norm() function is now a member function on Offset.

**August 8, 2012**

* View, by default, doesn't allow user-select, except TextView with HTML fragment.
* Rename log() function to printc() to avoid conflict with the math log function in dart:math.

**August 3, 2012**

* documentOffset is renamed to pageOffset (since it is more consistent to UIEvent.pageX)

**July 24, 2012**

* LinearPositionMotion is renamed to LinearPathMotion.

**July 23, 2012**

* HoldGesture, DragGesture and Scroller are moved to the gesture package.
* RadioGroupRenderer is removed and generalized as HTMLRenderer.
* DropDownListRenderer is removed and generalized as StringRenderer.

**July 20, 2012**

* Rename Motion/Scroller's onMoving to onMove and moving to move.
* `ProfileDeclaration.anchor` is default to `parent` if `location` is specified.
* `Activity.onMount_` was removed. Please override `Activity.onCreate_` instead.
