//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012 11:11:43 AM
// Author: tomyeh

/**
 * A skeletal implementation of [DataModel], [Selection] and [Disables].
 */
//abstract
class AbstractSelectionModel<T> extends AbstractDataModel
implements Selection<T>, Disables<T> {
  Set<T> _selection, _disables;
  bool _multiple = false;
  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  AbstractSelectionModel([Set<T> selection, Set<T> disables, bool multiple=false]) {
    _selection = selection != null ? selection: new Set();
    _disables = disables != null ? disables: new Set();
    _multiple = multiple;
  }

  //Event Handling//
  void _sendSelect() {
    sendEvent(new DataEvent(this, 'select'));
  }
  void _sendDisable() {
    sendEvent(new DataEvent(this, 'disable'));
  }

  //Selection//
  T get selectedValue => ListUtil.first(_selection);
  Set<T> get selection => _selection;

  void set selection(Collection<T> selection) {
    if (!_equals(_selection, selection)) {
      if (!_multiple && selection.length > 1)
        throw new ModelException("Only one selection is allowed, $selection");
      _selection.clear();
      _selection.addAll(selection);
      _sendSelect();
    }
  }

  //@Override
  bool isSelected(Object obj)  => _selection.contains(obj);
  //@Override
  bool isSelectionEmpty() => _selection.isEmpty();

  //@Override
  bool addToSelection(T obj) {
    if (_selection.contains(obj))
      return false;

    if (!_multiple)
      _selection.clear();
    _selection.add(obj);
    _sendSelect();
    return true;
  }
  //@Override
  bool removeFromSelection(Object obj) {
    if (_selection.remove(obj)) {
      _sendSelect();
      return true;
    }
    return false;
  }
  //@Override
  void clearSelection() {
    if (!_selection.isEmpty()) {
      _selection.clear();
      _sendSelect();
    }
  }

  //@Override
  bool get multiple => _multiple;
  //@Override
  void set multiple(bool multiple) {
    if (_multiple != multiple) {
      _multiple = multiple;
      sendEvent(new DataEvent(this, 'multiple'));

      if (!multiple && _selection.length > 1) {
        final T v = _selection.iterator().next();
        _selection.clear();
        _selection.add(v);
        _sendSelect();
      }
    }
  }

  //Disables//
  Set<T> get disables => _disables;
  void set disables(Collection<T> disables) {
    if (!_equals(_disables, disables)) {
      _disables.clear();
      _disables.addAll(disables);
      _sendDisable();
    }
  }
  bool isDisabled(Object obj)  => _disables.contains(obj);
  bool isDisablesEmpty() => _disables.isEmpty();
  bool addToDisables(T obj) {
    if (_disables.contains(obj))
      return false;

    _disables.add(obj);
    _sendDisable();
    return true;
  }
  bool removeFromDisables(Object obj) {
    if (_disables.remove(obj)) {
      _sendDisable();
      return true;
    }
    return false;
  }
  void clearDisables() {
    if (!_disables.isEmpty()) {
      _disables.clear();
      _sendDisable();
    }
  }

  //Additional API//
  /**Removes the given collection from the selection.
   */
  void removeAllSelection(Collection<Dynamic> c) {
    final int oldlen = _selection.length;
    _selection.removeAll(c);
    if (oldlen != _selection.length)
      _sendSelect();
  }
  /**Removes the given collection from the list of disabled object.
   */
  void removeAllDisables(Collection<Dynamic> c) {
    final int oldlen = _disables.length;
    _disables.removeAll(c);
    if (oldlen != _disables.length)
      _sendDisable();
  }

  bool equals(var other) {
    return (other is AbstractSelectionModel) && multiple == other.multiple
      && _selection == other._selection && _disables == other._disables;
  }

  /** Compares a set with a collection.
   */
  static bool _equals(Set set, Collection col) {
    if (set.length != col.length)
      return false;

    for (final e in col)
      if (!set.contains(e))
        return false;
    return true;
  }
}
