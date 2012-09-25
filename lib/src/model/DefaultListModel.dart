//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jun 05, 2012  1:17:47 PM
// Author: tomyeh

/**
 * The default implementation of [ListModel].
 */
class DefaultListModel<T> extends AbstractListModel<T> {
  final List<T> _data;

  /** Constructor.
   *
   * Notice that once [data] is assigned to a list model, you shall not
   * modify the data directly. Rather, you shall invoke the methods of this
   * model, such as [add]. Otherwise, UI won't update the changes correctly.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  DefaultListModel(List<T> data,
  [Set<T> selection, Set<T> disables, bool multiple]):
  super(selection, disables, multiple != null && multiple), _data = data;

  //@Override
  /** Returns the object of the given index.
   */
  T operator [](int index) => _data[index];
  //@Override
  /** Returns the length of the list.
   */
  int get length => _data.length;

  //additional interface//
  /** Returns the index of the given data, or -1 if not found.
   *
   * The implementation uses `List.indexOf` to retrieve the index, so the
   * performance might not be good if the list is big.
   * If the list is sorted, you can override this method to utilize it.
   *
   * This method is designed for use in application. The impelmentation of a view
   * shall access API available in [TreeModel].
   */
  int indexOf(T value) => _data.indexOf(value);

  /** Assigns a value to the given index.
   */
  void operator[]=(int index, T value) {
    final T old = _data[index];
    _data[index] = value;

    //Note: no need to send 'select' since 1) 'change' will update UI
    //2) if app modifies model in 'select', a dead loop happens (if we send 'select')
    if (_selection.contains(old)) {
      _selection.remove(old);
      _selection.add(value);
    }
    if (_disables.contains(old)) {
      _disables.remove(old);
      _disables.add(value);
    }
    sendEvent(new ListDataEvent(this, 'change', index, 1));
  }
  /** Adds a value to the end of the list.
   */
  void add(T value) {
    _data.add(value);
    sendEvent(new ListDataEvent(this, 'add', length - 1, 1));
  }
  /** Removes the last value.
   */
  T removeLast() {
    final T value = _data.removeLast();
    _selection.remove(value); //no need to fire select
    sendEvent(new ListDataEvent(this, 'remove', length, 1));
    return value;
  }
  /** Inserts a range of values to the given index.
   */
  void insertRange(int start, int length, [T value]) {
    _data.insertRange(start, length, value);
    sendEvent(new ListDataEvent(this, 'add', start, length));
  }
  /** Removes a range of values starting at the given index.
   */
  void removeRange(int start, int length) {
    for (int i = start, len = length; --len >= 0;)
      _selection.remove(_data[i++]); //no need to fire select
    _data.removeRange(start, length);
    sendEvent(new ListDataEvent(this, 'remove', start, length));
  }
  void clear() {
    final int len = _data.length;
    if (len > 0) {
      _selection.clear(); //no need to fire select
      _data.clear();
      sendEvent(new ListDataEvent(this, 'remove', 0, len));
    }
  }

  bool equals(var other) {
    return (other is DefaultListModel) && super.equals(other)
      && _data == other._data;
  }
  String toString() => "DefaultListModel($_data)";
}
