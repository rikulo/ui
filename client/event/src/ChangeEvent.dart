//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 24, 2012 12:05:08 PM
// Author: tomyeh

/**
 * A change event. It is sent with [ViewEvents.change].
 */
class ChangeEvent<E> extends ViewEvent {
  final E _value;
  ChangeEvent(E value, [String type="change", View target]):
  super(type, target), _value = value;

  /** Returns the value.
   */
  E get value() => _value;

  String toString() => "ChangeEvent($target,$value)";
}
