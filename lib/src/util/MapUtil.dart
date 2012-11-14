//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 28, 2012 10:30:47 AM
// Author: tomyeh
part of rikulo_util;

/** A readonly and empty map.
 */
const Map EMPTY_MAP = const {};

/**
 * A collection of Map related utilities.
 */
class MapUtil {
  /** Returns a map that will be created only when necessary, such as
   * [putIfAbsent] is called.
   *
   * It assumes the map was empty, and creates by invoking [creator]
   * when necessary. Don't use this method if the map already exists.
   *
   * It is useful to save the memory, if you have a map that won't contain
   * anything in most case.
   *
   * Notice you don't have to keep the object being returned by this method,
   * since it is just a proxy to the real map.
   * Refer to [View.dataAttributes] for a sample implementation.
   */
  static Map onDemand(AsMap creator) => new _OnDemandMap(creator);
}

class _OnDemandMap<K, V> implements Map<K,V> {
  final AsMap _creator;
  Map<K, V> _map;

  _OnDemandMap(AsMap this._creator);

  Map _init() => _map != null ? _map: (_map = _creator());

  //@override
  V  operator[](K key) => _map != null ? _map[key]: null;
  //@override
  void operator[]=(K key, V value) {
    _init()[key] = value;
  }
  //@override
  void clear() {
    if (_map != null) _map.clear();
  }
  //@override
  bool containsKey(K key) => _map != null && _map.containsKey(key);
  //@override
  bool containsValue(V value) => _map != null && _map.containsValue(value);
  //@override
  void forEach(void f(key, value)) {
    if (_map != null) _map.forEach(f);
  }
  //@override
  Collection<K> get keys => _map != null ? _map.keys: EMPTY_LIST;
  //@override
  Collection<V> get values => _map != null ? _map.values: EMPTY_LIST;
  //@override
  bool get isEmpty => _map == null || _map.isEmpty;
  //@override
  int get length => _map != null ? _map.length: 0;
  //@override
  V putIfAbsent(K key, V ifAbsent()) => _init().putIfAbsent(key, ifAbsent);
  //@override
  V remove(K key) => _map != null ? _map.remove(key): null;
}