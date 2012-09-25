//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Aug 01, 2012 11:14:35 AM
// Author: tomyeh

/**
 * A layout event. It is sent with [ViewEvents.layout] and [ViewEvents.preLayout].
 */
class LayoutEvent extends ViewEvent {
  final MeasureContext _context;
  LayoutEvent(MeasureContext context, [String type="layout", View target]):
  super(type, target), _context = context;

  /** Returns the context.
   */
  MeasureContext get context => _context;

  String toString() => "LayoutEvent($target)";
}
