//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 21, 2012  02:40:30 PM
// Author: hernichen

/**
 * Bridge Dart to Google Feed JavaScript APIs; see https://developers.google.com/jsFeed/ for details.
 */

class GFeed {
  //private JavaScript function
  static final String _LOAD = "gfeed.1";
  static final String _NUM_ENTRIES = "gfeed.2";
  static final String _NEW_FEED = "gfeed.3";

  static LoadableModule _feedModule;
  
  String _url; //jsFeed url
  String _version; //jsFeed module version
  Map _options; //options for loading the jsFeed module
  var jsFeed; //JavaScript Feed object
  
  /**
   * Prepare a Google Feed.
   * + [url] - the jsFeed url.
   * + [version] - the Google Feed API version to be loaded; default "1".
   * + [options] - special option when loading Google Feed API (used by Google Loader).
   */
  GFeed(String url, [String version="1", Map options]) :
    _url = url, _version = version, _options = options {
    _feedModule = new LoadableModule(_loadModule);
    _feedModule.doWhenLoaded(null); //force loading module
  }
  
  //load Feed module
  void _loadModule(Function readyFn) {
    _initJSFunctions();

    Map options = _options !== null ? new Map.from(_options) : new Map();
    options["callback"] = () => readyFn(); //callback after Feed API is loaded
    options["nocss"] = true;
    new GLoader().load(GLoader.FEED, _version, options); //load Feed API
  }    
  
  load(GFeedSuccessCallback onSuccess) {
    _feedModule.doWhenLoaded(()=>_load(onSuccess));
  }
  
  //load the specified Feed
  void _load(GFeedSuccessCallback onSuccess) {
    if (jsFeed == null) {
      jsFeed = JSUtil.jsCall(_NEW_FEED, [_url]);             
    }
    JSUtil.jsCall(_LOAD, [jsFeed, (xmldoc) => onSuccess(xmldoc === null ? null : JSUtil.xmlDocToDartMap(xmldoc))]);
  }
  
  void _initJSFunctions() {
    JSUtil.newJSFunction(_NEW_FEED, ["url"], '''
      var jsFeed = new window.google.feeds.Feed(url);
      jsFeed.setResultFormat(window.google.feeds.Feed.XML_FORMAT);
      return jsFeed;
    ''');
    JSUtil.newJSFunction(_LOAD, ["jsFeed", "callback"], '''
      jsFeed.load(function(result) {
        if (result.status.code === 200)
            callback.\$call\$1(result.xmlDocument);
      });
    ''');
  }
}

typedef GFeedSuccessCallback(Map resultSet);