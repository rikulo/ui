//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 04, 2012  7:17:06 PM
// Author: tomyeh

/**
 * A skeletal implementation of [ListModel].
 * It handles the data events ([ListDataEvent]) and the selection ([Selection]).
 */
abstract class AbstractListModel<E> implements ListSelectionModel<E> {
  final List<ListDataListener> _listeners;
  Set<E> _selection;
  bool _multiple = false;

  AbstractListModel([Set<E> selection, bool multiple=false]): _listeners = new List() {
    _selection = selection != null ? selection: new Set();
    _multiple = multiple;
  }

  /** Fires [ListDataEvent] for all registered listener.
   */
  void sendEvent_(ListDataEvent event) {
    for (final ListDataListener listener in _listeners)
      listener(event);
  }
  void _sendSelectionChanged() {
    sendEvent_(new ListDataEvent.selectionChanged());
  }

  // -- ListModel --//
  //@Override
  void addListDataListener(ListDataListener l) {
    _listeners.add(l);
  }
  //@Override
  void removeListDataListener(ListDataListener l) {
    ListUtil.remove(_listeners, l);
  }

  //Selection//
  //@Override
  Set<E> get selection() => _selection;

  //@Override
  void set selection(Collection<E> selection) {
    if (_isSelectionChanged(selection)) {
      if (!_multiple && selection.length > 1)
        throw new IllegalArgumentException("Only one selection is allowed, $selection");
      _selection.clear();
      _selection.addAll(selection);
      _sendSelectionChanged();
    }
  }
  bool _isSelectionChanged(Collection<E> selection) {
    if (_selection.length != selection.length)
      return true;

    for (final E e in selection)
      if (!_selection.contains(e))
        return true;
    return false;
  }

  //@Override
  bool isSelected(Object obj)  => _selection.contains(obj);
  //@Override
  bool isSelectionEmpty() => _selection.isEmpty();

  //@Override
  bool addToSelection(E obj) {
    if (_selection.contains(obj))
      return false;

    _selection.add(obj);
    if (!_multiple) {
      _selection.clear();
      _selection.add(obj);
    }
    _sendSelectionChanged();
    return true;
  }
  //@Override
  bool removeFromSelection(Object obj) {
    if (_selection.remove(obj)) {
      _sendSelectionChanged();
      return true;
    }
    return false;
  }
  //@Override
  void clearSelection() {
    if (!_selection.isEmpty()) {
      _selection.clear();
      _sendSelectionChanged();
    }
  }

  //@Override
  bool get multiple() => _multiple;
  //@Override
  void set multiple(bool multiple) {
    if (_multiple != multiple) {
      _multiple = multiple;
      sendEvent_(new ListDataEvent.multipleChanged());

      if (!multiple && _selection.length > 1) {
        final E v = _selection.iterator().next();
        _selection.clear();
        _selection.add(v);
        _sendSelectionChanged();
      }
    }
  }

  //Additional API//
  /**Removes the selection of the given collection.
   */
  void removeAllSelection(Collection<Dynamic> c) {
    _selection.removeAll(c);
  }

  bool equals(var other) {
    return (other is AbstractListModel) && multiple == other.multiple
      && _selection == other._selection;
  }
}
