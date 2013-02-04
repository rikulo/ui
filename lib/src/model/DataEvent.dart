//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 15:10:39 TST 2012
// Author: tomyeh
part of rikulo_model;

/** A listener for handling [DataEvent].
 */
typedef void DataEventListener(DataEvent event);

/** A data event.
 */
class DataEvent {
  final DataModel _model;
  final String _type;

  DataEvent(DataModel model, String type): _model = model, _type = type;

  /** Returns the type of this event.
   */
  String get type => _type;
  /** Returns the data model of this event.
   */
  DataModel get model => _model;
  String toString() => "$type()";
}

/**
 * A factory to expose [DataModel]'s events as Streams.
 */
class DataEventStreamProvider<T extends DataEvent> extends StreamProvider<T> {
  const DataEventStreamProvider(String eventType): super(eventType);
}

const DataEventStreamProvider<DataEvent> allEvent = const DataEventStreamProvider<DataEvent>('all');
const DataEventStreamProvider<DataEvent> addEvent = const DataEventStreamProvider<DataEvent>('add');
const DataEventStreamProvider<DataEvent> removeEvent = const DataEventStreamProvider<DataEvent>('remove');
const DataEventStreamProvider<DataEvent> structureEvent = const DataEventStreamProvider<DataEvent>('structure');
const DataEventStreamProvider<DataEvent> selectEvent = const DataEventStreamProvider<DataEvent>('select');
const DataEventStreamProvider<DataEvent> multipleEvent = const DataEventStreamProvider<DataEvent>('multiple');
const DataEventStreamProvider<DataEvent> disableEvent = const DataEventStreamProvider<DataEvent>('disable');
const DataEventStreamProvider<DataEvent> openEvent = const DataEventStreamProvider<DataEvent>('open');

/** A map of [DataEvent] listeners that [View] accepts.
 */
class DataEvents {
  final StreamTarget<DataEvent> _owner;
  DataEvents._(this._owner);

  /** Identifies listeners for all kind of data event type.
   * Listeners added here will be invoked no matter what [DataEvent] is received.
   */
  Stream<DataEvent> get all => allEvent.forTarget(_owner);
  /** Identifies the addition of one or more contiguous items to the model.
   *
   * The event is an instance of [ListDataEvent] or [TreeDataEvent], depending
   * on the model.
   */
  Stream<DataEvent> get add => addEvent.forTarget(_owner);
  /** Identifies the removal of one or more contiguous items from the model.
   *
   * The event is an instance of [ListDataEvent] or [TreeDataEvent], depending
   * on the model.
   */
  Stream<DataEvent> get remove => removeEvent.forTarget(_owner);
  /** Identifies the structure of the lists has changed.
   *
   * The event is an instance of [DataEvent].
   */
  Stream<DataEvent> get structure => structureEvent.forTarget(_owner);
  /** Identifies the selection of the lists has changed.
   *
   * It is applicable only if the model supports [Selection].
   * The event is an instance of [DataEvent].
   */
  Stream<DataEvent> get select => selectEvent.forTarget(_owner);
  /** Identified the change of whether the model allows mutiple selection.
   *
   * It is applicable only if the model supports [Selection].
   * The event is an instance of [DataEvent].
   */
  Stream<DataEvent> get multiple => multipleEvent.forTarget(_owner);
  /** Identifies the list of disabled objects has changed.
   *
   * It is applicable only if the model supports [Disables].
   * The event is an instance of [DataEvent].
   */
  Stream<DataEvent> get disable => disableEvent.forTarget(_owner);
  /** Identifies the change of the open statuses.
   *
   * It is applicable only if the model supports [Opens].
   * The event is an instance of [DataEvent].
   */
  Stream<DataEvent> get open => openEvent.forTarget(_owner);
}
