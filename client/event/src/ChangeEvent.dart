//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 24, 2012 12:05:08 PM
// Author: tomyeh

/**
 * A change event. It is sent with [ViewEvents.change].
 */
class ChangeEvent<Value> extends ViewEvent {
  final Value _value;
  ChangeEvent(View target, Value value, [String type="change"]):
  super(target, type), _value = value;

  /** Returns the value.
   */
  Value get value() => _value;

  String toString() => "ChangeEvent($target,$value)";
}
