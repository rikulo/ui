//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  2:20:43 PM
// Author: tomyeh

/**
 * A select event. It is sent with [ViewEvents.select].
 */
class SelectEvent<Item extends View, E> extends ViewEvent {
  final Collection<Item> _selectedItems;
  final Collection<E> _selectedValues;

  /** Constructor.
   *
   * + [selectedItems] is the set of selected items. It is null if the selected values
   * are not associated with any view.
   * + [selectedValues] is the set of selected values. It cannot be null.
   */
  SelectEvent(Item target, Collection<Item> selectedItems, Collection<E> selectedValues, [String type="select"]):
  super(target, type), _selectedItems = selectedItems, _selectedValues = selectedValues;

  /** Returns the selected items (aka., [View]), or null if it is not associated
   * with any views.
   *
   * Note, unlike [selectedValues], this method might return null. It indicates
   * the selected values are not associated with any views.
   */
  Collection<Item> get selectedItems() => _selectedItems;
  /** Returns the first selected item, or null if no selected item.
   */
  Item get firstSelectedItem() => ListUtil.first(_selectedItems);

  /** Returns the selected values.
   */
  Collection<E> get selectedValues() => _selectedValues;
  /** Returns the first selected value, or null if no selected value.
   */
  E get firstSelectedValue() => ListUtil.first(_selectedValues);

  String toString() => "SelectEvent($target, ${selectedItems !== null ? selectedItems: selectedValues})";
}
