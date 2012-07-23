Rikulo Changes
==============

**July 23, 2012**

* RadioGroupRenderer is removed and generalized as HTMLRenderer.
* DropDownListRenderer is removed and generalized as StringRenderer.
* Rename Motion/Scroller's onMoving to onMove and moving to move.
* `ProfileDeclaration.anchor` is default to `parent` if `location` is specified.
* `Activity.onMount_` was removed. Please override `Activity.onCreate_` instead.
