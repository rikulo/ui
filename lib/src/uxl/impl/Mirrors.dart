//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Sep 08, 2012 12:31:38 AM
// Author: tomyeh

/**
 * The mirrors used in a UXL document.
 */
interface Mirrors default _Mirrors {
  Mirrors();

  void import(String name);
  /** Returns the class mirror of the view ([View]) with given name.
   *
   * Notice that it is class insensitive.
   */
  ClassMirror getViewMirror(String name);
  /** Returns the class mirror of the controller ([Controller]) with given name.
   */
  ClassMirror getControllerMirror(String name);
}

class _Mirrors implements Mirrors {
  final List<_MirrorsOfLib> _libs;
  final Set<String> _names;

  _Mirrors() : _libs = [], _names = new Set() {
    import("rikulo:view");
  }

  void import(String name) {
    if (!_names.contains(name)) {
      _names.add(name);
      _libs.add(_import(name));
    }
  }
  ClassMirror getViewMirror(String name) {
    for (_MirrorsOfLib lib in _libs) {
      final mirror = lib.getViewMirror(name);
      if (mirror != null)
        return mirror;
    }
  }
  ClassMirror getControllerMirror(String name) {
    for (_MirrorsOfLib lib in _libs) {
      final mirror = lib.getControllerMirror(name);
      if (mirror != null)
        return mirror;
    }
  }
}

/** Mirrors in a single library.
 */
class _MirrorsOfLib {
  final Map<String, ClassMirror> _views, _ctrls;

  _MirrorsOfLib() : _views = {}, _ctrls = {};

  //note: it is case-insensitive
  ClassMirror getViewMirror(String name) => _views[name.toLowerCase()];
  ClassMirror getControllerMirror(String name) => _ctrls[name];
}
_MirrorsOfLib _import(String name) {
  if (_libs == null)
    _libs = {};

  _MirrorsOfLib lib = _libs[name];
  if (lib == null) {
    _libs[name] = lib = new _MirrorsOfLib();
    //TODO: load from mirrors
  }
  return lib;
}
Map<String, _MirrorsOfLib> _libs;
