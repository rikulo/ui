//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  10:30:28 AM
// Author: hernichen

/**
 * Bridge Dart to Google JavaScript APIs loader; see https://developers.google.com/loader/ for details.
 */
class GLoader {
  //private JS operation
  static final String _GLOADER_READY = "gload.1";
  static final String _IP_LOCATION = "gload.2";
  static final String _LOAD_MODULE = "gload.3";
  
  static final String _BASE_URI = "https://www.google.com/jsapi";
  
  //module names
  static final String MAPS = "maps";
  static final String SEARCH = "search";
  static final String FEED = "feeds";
  static final String EARTH = "earth";
  static final String VISUALIZATION = "visualization";
  static final String ORKUT = "orkut";
  static final String PICKER = "picker";
  
  static LoadableModule _loaderModule;
  static Map<String, double> _loc;

  GLoader() {
    _loaderModule = new LoadableModule(_loadModule);
  }
  
  Map get _ipLocation() {
    if (_loc == null)
      _loc = jsutil.toDartMap(jsutil.jsCall(_IP_LOCATION));
    return _loc;
  }
  
  void _loadModule(Function readyFn) {
    _initJSFunctions();
    
    jsutil.injectJavaScriptSrc(_BASE_URI);
    doWhenReady(readyFn, ()=>jsutil.jsCall(_GLOADER_READY), 
      (int msec) {if(msec == 0) print("Fail to load jsapi.js!");}, 10, 180000); //check every 10 ms, wait total 180 seconds
  }
  
  void getIPLocation(GLoaderSuccessCallback onSuccess) {
    _loaderModule.doWhenLoaded(() => onSuccess(_ipLocation['lat'], _ipLocation['lng']));
  }
  
  /** Load Goolge JavaScript API module; see https://developers.google.com/loader/#GoogleLoad for details.
   * @param name the module name
   * @param version the module version
   * @param options the options used in loading the module
   */
  void load(String name, String version, [Map options]) {
    _loaderModule.doWhenLoaded(()=>_load(name, version, options));
  }
  
  void _load(String name, String version, [Map options]) {
    jsutil.jsCall(_LOAD_MODULE, [name, version, jsutil.toJSMap(options)]);
  }
  
  void _initJSFunctions() {
    jsutil.newJSFunction(_GLOADER_READY, null, "return !!window.google && !!window.google.load;");
    jsutil.newJSFunction(_IP_LOCATION, null,''' 
      var loc = {};
      if (window.google.loader.ClientLocation) {
        loc.lat = window.google.loader.ClientLocation.latitude;
        loc.lng = window.google.loader.ClientLocation.longitude;
      }
      return loc;
    ''');
    jsutil.newJSFunction(_LOAD_MODULE, ["name", "version", "options"], '''
      if (options && options.callback) {
        var dartfn = options.callback;
        options.callback = function() {dartfn.\$call\$0();};
      }
      window.google.load(name, version, options);
    ''');
  }
}

typedef GLoaderSuccessCallback(double lat, double lng);
