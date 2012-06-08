//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 04, 2012  7:17:06 PM
// Author: tomyeh

/**
 * A skeletal implementation of [ListModel].
 * It handles the data events ([ListDataEvent]) and the selection ([Selectable]).
 */
abstract class AbstractListModel<E> implements SelectableListModel<E> {
  final List<ListDataListener> _listeners;
  Set<E> _selection;
  bool _multiple = false;

  AbstractListModel([Set<E> selection, bool multiple=false]): _listeners = new List() {
    _selection = selection != null ? selection: new Set();
    _multiple = multiple;
  }

  /** Fires [ListDataEvent] for all registered listener.
   */
  void sendEvent_(DataEventType type, int index0, int index1) {
    final ListDataEvent evt = new ListDataEvent(type, index0, index1);
    for (final ListDataListener listener in _listeners)
      listener(evt);
  }
  void _sendSelectionChanged() {
    sendEvent_(DataEventType.SELECTION_CHANGED, 0, -1);
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

  //Selectable//
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
  bool isSelected(Object obj) {
    return !isSelectionEmpty()
        && (_selection.length == 1 ? _selection.iterator().next() == obj
             : _selection.contains(obj));
  }
  //@Override
  bool isSelectionEmpty() {
    return _selection.isEmpty();
  }

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
      sendEvent_(DataEventType.SELECTION_CHANGED, 0, -1);
      return true;
    }
    return false;
  }
  //@Override
  void clearSelection() {
    if (!_selection.isEmpty()) {
      _selection.clear();
      sendEvent_(DataEventType.SELECTION_CHANGED, 0, -1);
    }
  }

  //@Override
  bool get multiple() => _multiple;
  //@Override
  void set multiple(bool multiple) {
    if (_multiple != multiple) {
      _multiple = multiple;
      sendEvent_(DataEventType.MULTIPLE_CHANGED, 0, -1);

      if (!multiple && _selection.length > 1) {
        E v = _selection.iterator().next();
        _selection.clear();
        _selection.add(v);
        sendEvent_(DataEventType.SELECTION_CHANGED, 0, -1);
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
