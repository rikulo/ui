Rikulo Changes
==============

**July 24, 2012**

* LinearPositionMotion is renamed to LinearPathMotion.

**July 23, 2012**

* HoldGesture, DragGesture and Scroller are move to the gesture package.
* RadioGroupRenderer is removed and generalized as HTMLRenderer.
* DropDownListRenderer is removed and generalized as StringRenderer.

**July 20, 2012**

* Rename Motion/Scroller's onMoving to onMove and moving to move.
* `ProfileDeclaration.anchor` is default to `parent` if `location` is specified.
* `Activity.onMount_` was removed. Please override `Activity.onCreate_` instead.
