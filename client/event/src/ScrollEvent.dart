//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jul 19, 2012  11:00:12 PM
//Author: simon

/** Event representing scrolling.
 */
class ScrollEvent extends ViewEvent {
  
  final ScrollerState state;
  
  /** Constructor
   * 
   */
  ScrollEvent(String type, View target, this.state) : 
    super(type, target: target);
  
}
