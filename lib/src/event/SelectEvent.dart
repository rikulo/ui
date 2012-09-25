//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  2:20:43 PM
// Author: tomyeh

/**
 * A select event. It is sent with [ViewEvents.select].
 */
class SelectEvent<T> extends ViewEvent {
  final Collection<T> _selectedValues;
  final int _selectedIndex;

  /** Constructor.
   *
   * + [selectedValues] is the set of selected values. It can't be null.
   * + [selectedIndex] is the index of the first selected value, or -1
   * if [selectedValues] is empty.
   */
  SelectEvent(Collection<T> selectedValues, int selectedIndex, [String type="select", View target]):
  super(type, target), _selectedValues = selectedValues, _selectedIndex = selectedIndex;

  /** Returns the selected values.
   */
  Collection<T> get selectedValues => _selectedValues;
  /** Returns the first selected value, or null if no selected value.
   */
  T get selectedValue => ListUtil.first(_selectedValues);

  /** Returns the first selected index, or -1 if none is selected.
   *
   * Notice that [selectedIndex] is meaningless for [TreeModel].
   */
  int get selectedIndex => _selectedIndex;

  String toString() => "SelectEvent($target, $selectedValues, $selectedIndex)";
}
