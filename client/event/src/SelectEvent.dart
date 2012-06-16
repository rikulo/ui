//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  2:20:43 PM
// Author: tomyeh

/**
 * A select event. It is sent with [ViewEvents.select].
 */
class SelectEvent<E> extends ViewEvent {
  final Collection<E> _selectedValues;
  final int _selectedIndex;

  /** Constructor.
   *
   * + [selectedValues] is the set of selected values. It can't be null.
   * + [selectedIndex] is the index of the first selected value, or -1
   * if [selectedValues] is empty.
   */
  SelectEvent(View target, Collection<E> selectedValues, int selectedIndex, [String type="select"]):
  super(target, type), _selectedValues = selectedValues, _selectedIndex = selectedIndex;

  /** Returns the selected values.
   */
  Collection<E> get selectedValues() => _selectedValues;
  /** Returns the first selected value, or null if no selected value.
   */
  E get selectedValue() => ListUtil.first(_selectedValues);

  /** Returns the first selected index, or -1 if none is selected.
   *
   * Notice that [selectedIndex] is meaningless for [TreeModel].
   */
  int get selectedIndex() => _selectedIndex;

  String toString() => "SelectEvent($target, $selectedValues, $selectedIndex)";
}
