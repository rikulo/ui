//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 28, 2012 10:30:47 AM
// Author: tomyeh

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

  V  operator[](K key) => _map != null ? _map[key]: null;
  void operator[]=(K key, V value) {
    _init()[key] = value;
  }
  void clear() {
    if (_map != null) _map.clear();
  }
  bool containsKey(K key) => _map != null && _map.containsKey(key);
  bool containsValue(V value) => _map != null && _map.containsValue(value);
  void forEach(void f(key, value)) {
    if (_map != null) _map.forEach(f);
  }
  Collection<K> getKeys() => _map != null ? _map.getKeys(): ListUtil.emptyCollection;
  Collection<V> getValues() => _map != null ? _map.getValues(): ListUtil.emptyCollection;
  bool isEmpty() => _map == null || _map.isEmpty();
  int get length => _map != null ? _map.length: 0;
  V putIfAbsent(K key, V ifAbsent()) => _init().putIfAbsent(key, ifAbsent);
  V remove(K key) => _map != null ? _map.remove(key): null;
}