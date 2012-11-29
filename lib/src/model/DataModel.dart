//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  9:51:13 AM
// Author: tomyeh
part of rikulo_model;

/** A data model.
 */
class DataModel {
  DataEvents _on;
  Map<String, List<DataEventListener>> _listeners;

  DataModel() {
    _on = new DataEvents(this);
    _listeners = new Map();
  }

  /** Returns [DataEvents] for adding or removing event listeners.
   */
  DataEvents get on => _on;
  /** Adds an event listener.
   * `addEventListener("select", listener)` is the same as
   * `on.select.add(listener)`.
   */
  void addEventListener(String type, DataEventListener listener) {
    if (listener == null)
      throw new ArgumentError("listener");

    bool first = false;
    _listeners.putIfAbsent(type, () {
      first = true;
      return [];
    }).add(listener);
  }
  /** Removes an event listener.
   * `removeEventListener("select", listener)` is the same as
   * `on.select.remove(listener)`.
   */
  bool removeEventListener(String type, DataEventListener listener)
  => ListUtil.remove(_listeners[type], listener);
  /** Sends an event to this model.
   *
   * Example: `model.sendEvent(new ListDataEvent(model, "select"))</code>.
   */
  bool sendEvent(DataEvent event) {
    final bool
      b1 = _sendEvent(event, _listeners[event.type]),
      b2 = _sendEvent(event, _listeners['all']);
    return b1 || b2;
  }
  static bool _sendEvent(DataEvent event, List<DataEventListener> listeners) {
    bool dispatched = false;
    if (listeners != null) {
      //Note: we make a copy of listeners since listener might remove other listeners
      //It means the removing and adding of listeners won't take effect until next event
      for (final DataEventListener listener in new List.from(listeners)) {
        dispatched = true;
        listener(event);
      }
    }
    return dispatched;
  }
}

/** A model exception.
 */
class ModelError implements Error {
  final String message;

  ModelError(String this.message);
  String toString() => "ModelError($message)";
}

/**
 * Indicates a model that allows to open some of the objects.
 * It is a supplymental interface used with other models, such as [TreeModel].
 */
abstract class Opens<T> {
  /**
   * Returns the current list of nodes that are opened.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<T> get opens;
  /**
   * Replace the current list of node that are opened with the given set.
   *
   * Notice this method copies the content of [opens], so it is OK
   * to use it after the invocation.
   */
  void set opens(Collection<T> opens);

  /** Returns true if the node shall be opened.
   * That is, it tests if the given node is in the list of opened nodes.
   */
  bool isOpened(T node);
  /** Returns true if the list of opened nodes is empty.
   */
  bool get isOpensEmpty;

  /** Adds the given node to the list of opened nodes.
   */
  bool addToOpens(T node);
  /** Removes the given node from the list of opened nodes.
   */
  bool removeFromOpens(T node);
  /** Empties the list of opened nodes.
   */
  void clearOpens();
}

/**
 * Indicates a model that allows to disable some of the objects.
 * It is a supplymental interface used with other models, such as [ListModel].
 */
abstract class Disables<T> {
  /**
   * Returns the current list of disabled objects.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<T> get disables;
  /**
   * Replace the current list of disabled objects with the given set.
   *
   * Notice this method copies the content of [disables], so it is OK
   * to use it after the invocation.
   */
  void set disables(Collection<T> disables);

  /** Returns whether an object is disabled.
   */
  bool isDisabled(Object obj);
  /**
   * Returns true if the list of the disabled objects is currently empty.
   */
  bool get isDisablesEmpty;

  /**
   * Add the specified object into the current list of disabled objects.
   * It returns whether it has been added successfully.
   * Returns false if it is already disabled.
   */
  bool addToDisables(T obj);
  /**
   * Remove the specified object from the current list of disabled objects.
   * It returns whether it is removed successfully.
   * Returns false if it is not disabled.
   */
  bool removeFromDisables(Object obj);
  /**
   * Change the current list of disabled objects to the empty set.
   */
  void clearDisables();
}

/**
 * Indicates a model that allows selection.
 * It is a supplymental interface used with other models, such as [ListModel].
 */
abstract class Selection<T> {
  /**
   * Returns the first selected value, or null if none is selected.
   */
  T get selectedValue;
  /**
   * Returns the current selection.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<T> get selection;
  /**
   * Replace the current selection with the given set.
   *
   * Notice this method copies the content of [selection], so it is OK
   * to use it after the invocation.
   */
  void set selection(Collection<T> selection);
  /** Returns whether an object is selected.
   */
  bool isSelected(Object obj);
  
  /**
   * Returns true if the selection is currently empty.
   */
  bool get isSelectionEmpty;
  /**
   * Add the specified object into selection.
   * It returns whether it has been added successfully.
   * Returns false if it is already selected.
   */
  bool addToSelection(T obj);
  /**
   * Remove the specified object from selection.
   * It returns whether it is removed successfully.
   * Returns false if it is not selected.
   */
  bool removeFromSelection(Object obj);
  /**
   * Change the selection to the empty set.
   */
  void clearSelection();

  /**
   * Sets the selection mode to be multiple.
   */
  void set multiple(bool multiple);
  /**
   * Returns whether the current selection mode is multiple.
   */
  bool get multiple;
}
