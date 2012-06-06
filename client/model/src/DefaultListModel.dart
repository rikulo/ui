//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jun 05, 2012  1:17:47 PM
// Author: tomyeh

/**
 * The default implementation of [ListModel].
 */
class DefaultListModel<E> extends AbstractListModel<E> {
  final List<E> _data;

  /** Constructor.
   * <p>Notice that once [data] is assigned to a list model, you shall not
   * modify the data directly. Rather, you shall invoke the methods of this
   * model, such as [add]. Otherwise, UI won't update the changes correctly.
   */
  DefaultListModel(List<E> data): _data = data;

  //@Override
  /** Returns the object of the given index.
   */
  E operator [](int index) => _data[index];
  //@Override
  /** Returns the length of the list.
   */
  int get length() => _data.length;

  //TODO: add/removeRange/... and other methods
  bool equals(var other) {
    return (other is DefaultListModel) && super.equals(other)
      && _data == other._data;
  }
  String toString() => "DefaultListModel($_data)";
}
