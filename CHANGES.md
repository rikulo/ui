#Rikulo Changes

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
