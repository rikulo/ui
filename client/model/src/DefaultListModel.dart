//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jun 05, 2012  1:17:47 PM
// Author: tomyeh

/**
 * The default implementation of [ListModel].
 */
class DefaultListModel<E> extends AbstractListModel<E> {
  final List<E> _data;

  /** Constructor.
   *
   * Notice that once [data] is assigned to a list model, you shall not
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

  //additional interface//
  /** Assigns a value to the given index.
   */
  void operator[]=(int index, E value) {
    _data[index] = value;
    sendEvent_(DataEventType.CONTENT_CHANGED, index, 1);
  }
  /** Adds a value to the end of the list.
   */
  void add(E value) {
    _data.add(value);
    sendEvent_(DataEventType.INTERVAL_ADDED, length - 1, 1);
  }
  /** Removes the last value.
   */
  E removeLast() {
    final E value = _data.removeLast();
    sendEvent_(DataEventType.INTERVAL_REMOVED, length, 1);
    return value;
  }
  /** Inserts a range of values to the given index.
   */
  void insertRange(int start, int length, [E value]) {
    _data.insertRange(start, length, value);
    sendEvent_(DataEventType.INTERVAL_ADDED, start, length);
  }
  /** Removes a range of values starting at the given index.
   */
  void removeRange(int start, int length) {
    _data.removeRange(start, length);
    sendEvent_(DataEventType.INTERVAL_REMOVED, start, length);
  }
  void clear() {
    if (!_data.isEmpty()) {
      _data.clear();
      sendEvent_(DataEventType.CONTENT_CHANGED, 0, -1);
    }
  }

  //TODO: add/removeRange/... and other methods
  bool equals(var other) {
    return (other is DefaultListModel) && super.equals(other)
      && _data == other._data;
  }
  String toString() => "DefaultListModel($_data)";
}
