//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 14:52:22 TST 2012
// Author: tomyeh
part of rikulo_model;

/**
 * An event used to notify the listeners of a list model ([ListModel])
 * that the model has been changed.
 */
class ListDataEvent<T> extends DataEvent {
  /** Constructor.
   *
   * + [type]: `change`, `add` or `remove`.
   */
  ListDataEvent(ListModel<T> model, String type, [this.start, this.end])
  : super(model, type);

  /** The starting index of the change range (nonnegative).
   * It is null, if not applicable.
   */
  final int start;
  /** The ending index of the change range (excluded).
   * It is null, if not applicable.
   */
  final int end;
}

/**
 * A data model representing a list of data.
 *
 * Instead of implementing this interface, you can use [DefaultListModel]. It
 * is a concrete class that implements [ListModel], [SelectionModel] and [DisablesModel].
 *
 * Instead of implementing this interface from scratch, it is suggested
 * to extend from [AbstractListModel].
 */
abstract class ListModel<T> extends DataModel {
  /** Returns the value at the specified index.
   */
  T operator [](int index);
  /** Returns the length of the list.
   */
  int get length;
}

class Foo extends ListModel {
  String operator [](int index) => "";
  /** Returns the length of the list.
   */
  int get length=>0;
}
/**
 * A skeletal implementation of [ListModel].
 * It handles the data events ([ListDataEvent]) and the selection ([SelectionModel]).
 */
abstract class AbstractListModel<T> extends AbstractDataModel<T>
implements ListModel<T> {
  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  AbstractListModel({Set<T> selection, Set<T> disables, bool multiple:false}):
  super(selection: selection, disables: disables, multiple: multiple);
}

/**
 * The default implementation of [ListModel].
 */
class DefaultListModel<T> extends AbstractListModel<T> {
  /** The original data.
   * Don't modify it directly. Otherwise, UI won't be synchronized automatically.
   */
  final List<T> data;

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
  {Set<T> selection, Set<T> disables, bool multiple: false}):
  super(selection: selection, disables: disables, multiple: multiple),
  this.data = data;

  @override
  /** Returns the object of the given index.
   */
  T operator [](int index) => data[index];
  @override
  /** Returns the length of the list.
   */
  int get length => data.length;

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
  int indexOf(T value) => data.indexOf(value);

  /** Assigns a value to the given index.
   */
  void operator[]=(int index, T value) {
    final T old = data[index];
    data[index] = value;

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
    sendEvent(new ListDataEvent(this, 'change', index, index + 1));
  }
  /** Adds a value to the end of the list.
   */
  void add(T value) {
    data.add(value);
    sendEvent(new ListDataEvent(this, 'add', length - 1, length));
  }
  /** Removes the last value.
   */
  T removeLast() {
    final T value = data.removeLast();
    _selection.remove(value); //no need to fire select
    sendEvent(new ListDataEvent(this, 'remove', length, length + 1));
    return value;
  }
  /** Inserts a range of values to the given index.
   */
  void insert(int index, [T value]) {
    data.insert(index, value);
    sendEvent(new ListDataEvent(this, 'add', index, index + 1));
  }
  /** Removes a range of values starting at the given index.
   */
  void removeRange(int start, int end) {
    for (int i = start, len = end - start; --len >= 0;)
      _selection.remove(data[i++]); //no need to fire select
    data.removeRange(start, end);
    sendEvent(new ListDataEvent(this, 'remove', start, end));
  }
  void clear() {
    final len = data.length;
    if (len > 0) {
      _selection.clear(); //no need to fire select
      data.clear();
      sendEvent(new ListDataEvent(this, 'remove', 0, len));
    }
  }

  @override
  String toString() => "DefaultListModel($data)";
}
