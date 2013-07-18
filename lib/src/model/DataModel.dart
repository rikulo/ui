//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  9:51:13 AM
// Author: tomyeh
part of rikulo_model;

/** A data model.
 */
class DataModel implements StreamTarget<DataEvent> {
  DataEvents _on;
  final Map<String, List<DataEventListener>> _listeners = new HashMap();

  DataModel() {
    _on = new DataEvents._(this);
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
  void removeEventListener(String type, DataEventListener listener) {
    final list = _listeners[type];
    if (list != null)
      list.remove(listener);
  }
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
class ModelError extends Error {
  final String message;

  ModelError(this.message);
  String toString() => "ModelError($message)";
}

/**
 * Indicates a model that allows to open some of the objects.
 * It is a supplymental interface used with other models, such as [TreeModel].
 */
abstract class OpensModel<T> {
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
  void set opens(Iterable<T> opens);

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
abstract class DisablesModel<T> {
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
  void set disables(Iterable<T> disables);

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
abstract class SelectionModel<T> {
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
  void set selection(Iterable<T> selection);
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

/**
 * A skeletal implementation of [DataModel], [SelectionModel] and [DisablesModel].
 */
class AbstractDataModel<T> extends DataModel
implements SelectionModel<T>, DisablesModel<T> {
  Set<T> _selection, _disables;
  bool _multiple = false;
  /** Constructor.
   *
   * + [selection]: if not null, it will be used to hold the selection.
   * Unlike [set selection], it won't make a copy.
   * + [disables]: if not null, it will be used to hold the list of disabled items.
   * Unlike [set disables], it won't make a copy.
   */
  AbstractDataModel({Set<T> selection, Set<T> disables, bool multiple:false}) {
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

  //SelectionModel//
  T get selectedValue => _selection.isEmpty ? null: _selection.first;
  Set<T> get selection => _selection;

  void set selection(Iterable<T> selection) {
    if (!_equals(_selection, selection)) {
      if (!_multiple && selection.length > 1)
        throw new ModelError("Only one selection is allowed, $selection");
      _selection.clear();
      _selection.addAll(selection);
      _sendSelect();
    }
  }

  @override
  bool isSelected(Object obj)  => _selection.contains(obj);
  @override
  bool get isSelectionEmpty => _selection.isEmpty;

  @override
  bool addToSelection(T obj) {
    if (_selection.contains(obj))
      return false;

    if (!_multiple)
      _selection.clear();
    _selection.add(obj);
    _sendSelect();
    return true;
  }
  @override
  bool removeFromSelection(Object obj) {
    if (_selection.remove(obj)) {
      _sendSelect();
      return true;
    }
    return false;
  }
  @override
  void clearSelection() {
    if (!_selection.isEmpty) {
      _selection.clear();
      _sendSelect();
    }
  }

  @override
  bool get multiple => _multiple;
  @override
  void set multiple(bool multiple) {
    if (_multiple != multiple) {
      _multiple = multiple;
      sendEvent(new DataEvent(this, 'multiple'));

      if (!multiple && _selection.length > 1) {
        final T v = _selection.first;
        _selection.clear();
        _selection.add(v);
        _sendSelect();
      }
    }
  }

  //DisablesModel//
  Set<T> get disables => _disables;
  void set disables(Iterable<T> disables) {
    if (!_equals(_disables, disables)) {
      _disables.clear();
      _disables.addAll(disables);
      _sendDisable();
    }
  }
  bool isDisabled(Object obj)  => _disables.contains(obj);
  bool get isDisablesEmpty => _disables.isEmpty;
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
    if (!_disables.isEmpty) {
      _disables.clear();
      _sendDisable();
    }
  }

  //Additional API//
  /**Removes the given collection from the selection.
   */
  void removeAllSelection(Iterable c) {
    final int oldlen = _selection.length;
    _selection.removeAll(c);
    if (oldlen != _selection.length)
      _sendSelect();
  }
  /**Removes the given collection from the list of disabled object.
   */
  void removeAllDisables(Iterable c) {
    final int oldlen = _disables.length;
    _disables.removeAll(c);
    if (oldlen != _disables.length)
      _sendDisable();
  }

  /** Compares a set with a collection.
   */
  static bool _equals(Set set, Iterable col) {
    if (set.length != col.length)
      return false;

    for (final e in col)
      if (!set.contains(e))
        return false;
    return true;
  }
}

/**
 * The render context used to render [DataModel].
 *
 * Note: Which renderer to use depends on the view.
 * See also [Renderer].
 */
class RenderContext<T> {
  RenderContext(this.view, this.model, this.data, this.selected, this.disabled,
    [this.index = -1, this.column, this.columnIndex = -1]);

  /** The view that renders the model. */
  final View view;
  /** The model. */
  final DataModel model;
  /** The data being rendered.
   */
  final T data;
  /** The index of data, or -1 if not applicable.
   */
  final int index;
  /** Whether the data is selected, or false if not applicable.
   */
  final bool selected;
  /** Whetehr the data is disabled, or false if not applicable.
   */
  final bool disabled;

  /** The column index, or -1 if not applicable.
   * It is used only if the view is a grid-type UI and it supports the render-on-demand
   * at the horizontal direction. In other words, [data] is the data representing
   * the whole row, while [columnIndex] specifies which part of the data to render.
   *
   * Please refer to the views that support this field.
   */
  final int columnIndex;
  /** The column's name, or null if not applicable.
   * Like [columnIndex], it is used only if the view is a grid-type UI and
   * it supports the render-on-demand at the horizontal direction.
   * In other words, [data] is the data representing
   * the whole row, while [column] specifies which part of the data to render.
   *
   * Note: dependong on the view, [column] might not be supported, even if
   * supports [columnIndex].
   *
   * Please refer to the views that support this field.
   */
  final String column;

  /** Converts the given object to a string.
   *
   * + [encode] specifies whether to invoke [XmlUtil.encode].
   */
  String getDataAsString([bool encode=false]) {
    var val = data;
    if (val is TreeNode)
      val = (val as TreeNode).data;
    if (val is Map && (val as Map).containsKey("text"))
      val = val["text"];
    return val != null ? encode ? "${XmlUtil.encode(val)}": val.toString(): "";
  }
}
/** Renders the given data into a string or an element.
 * The return value depends on the view you are using.
 */
typedef Renderer(RenderContext context);
