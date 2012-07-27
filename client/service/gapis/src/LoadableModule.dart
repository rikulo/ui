//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  10:30:28 AM
// Author: hernichen

/** For JavaScript module that is dynamically loaded and with a callback */
class LoadableModule {
  static final int _NONE = 0;
  static final int _LOADING = 1; //loading but not loaded
  static final int _LOADED = 2; //loaded
  
  int _loadStatus = _NONE;
  List<Function> _callbacks;
  LoadFunction _loadModule;
  
  LoadableModule(this._loadModule) {
    if (_callbacks == null) {
      _callbacks = new List();
    }
  }

  _addCallback(Function callback) {
    _callbacks.add(callback);
  }
  
  _execCallbacks() {
    if (_callbacks != null) {
      _callbacks.forEach((Function callback)=>callback());
      _callbacks.clear();
      _callbacks = null;
    }
  }
  
  /**
   * Per the module load status:
   * 1. Not start loading the module; would call loadModule_ to load the module.
   * 2. Start loading but not loaded yet; would register the function and wait until module loaded.
   * 3. If loaded; would execute the function immediately.
   */
  doWhenLoaded(Function fn) {
    switch(_loadStatus) {
      case _NONE:
        if (fn != null) _addCallback(fn);
        _loadModule0();
        break;
      case _LOADING:
        if (fn != null) _addCallback(fn);
        break;
      case _LOADED:
        if (fn != null) fn();
        break;
    }
  }
  
  void _loadModule0() {
    _loadStatus = _LOADING;
    _loadModule((){_loadStatus=_LOADED; _execCallbacks();});
  }
}

/** 
 * This method is used to load the module. When module is completly loaded, implementation 
 * should call the passed in readyFn function to indicate loading is done and ready.
 */
typedef void LoadFunction(Function readyFn);