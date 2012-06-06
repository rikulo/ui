//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Apr 24, 2012  2:09:52 PM
// Author: tomyeh

/**
 * A check event. It is sent with [ViewEvents.check].
 */
class CheckEvent extends ViewEvent {
  final bool _checked;

  CheckEvent(View target, bool checked, [String type="check"]):
  super(target, type), _checked = checked;

  /** Returns whether it is checked.
   */
  bool get checked() => _checked;

  String toString() => "CheckEvent($target,$checked)";
}
