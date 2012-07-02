//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
//Author: simon

/**
 * The callback type that realizes an abstract position number. 
 */
typedef void MotionAction(num x);

/**
 * The control object of a linear MotionAction, which moves the element along a 
 * linear trajectory.
 */
class LinearMotionActionControl {
 
 final Element element;
 final Offset init, dest, diff;
 final MotionAction action;
 
 /**
  * Construct a control object of MotionAction which move the element along a 
  * linear trajectory from init to dest.
  */
 LinearMotionActionControl(Element element, Offset init, Offset dest) :
   this.element = element, this.init = init, this.dest = dest,
   this.diff = dest - init, this.action = _getAction(element, init, dest - init);
 
 static MotionAction _getAction(Element element, Offset init, Offset diff) => (num x) {
   Offset curr = diff * x + init;
   element.style.left = CSS.px(curr.left);
   element.style.top = CSS.px(curr.top);
 };
 
}
