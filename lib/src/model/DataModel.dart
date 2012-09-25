//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 14, 2012  9:51:13 AM
// Author: tomyeh

/** A data model.
 */
interface DataModel {
  /** Returns [DataEvents] for adding or removing event listeners.
   */
  DataEvents get on;
  /** Adds an event listener.
   * `addEventListener("select", listener)` is the same as
   * `on.select.add(listener)`.
   */
  void addEventListener(String type, DataEventListener listener);

  /** Removes an event listener.
   * `removeEventListener("select", listener)` is the same as
   * `on.select.remove(listener)`.
   */
  bool removeEventListener(String type, DataEventListener listener);
  /** Sends an event to this model.
   *
   * Example: `model.sendEvent(new ListDataEvent(model, "select"))</code>.
   */
  bool sendEvent(DataEvent event);
}

/** A model exception.
 */
class ModelException implements Exception {
  final String message;

  const ModelException(String this.message);
  String toString() => "ModelException($message)";
}

/**
 * A skeletal implementation of [DataModel], [Selection] and [Disables].
 */
//abstract
class AbstractDataModel implements DataModel {
  DataEvents _on;
  Map<String, List<DataEventListener>> _listeners;

  AbstractDataModel() {
    _on = new DataEvents(this);
    _listeners = new Map();
  }

  //Event Handling//
  DataEvents get on => _on;

  void addEventListener(String type, DataEventListener listener) {
    if (listener == null)
      throw const ModelException("listener required");

    bool first = false;
    _listeners.putIfAbsent(type, () {
      first = true;
      return [];
    }).add(listener);
  }
  bool removeEventListener(String type, DataEventListener listener)
  => ListUtil.remove(_listeners[type], listener);

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
