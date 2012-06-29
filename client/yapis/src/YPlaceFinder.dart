//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  05:22:36 PM
// Author: hernichen

/**
 * Yahoo PlaceFinder API; see http://developer.yahoo.com/geo/placefinder/ for details.
 */
class YPlaceFinder {
  static final String _BASE_URI = "http://where.yahooapis.com/geocode";
  
  /** Return geo information in a Map via callback function onSuccess(Map resultSet).
   * @param locations location parameer; see http://developer.yahoo.com/geo/placefinder/ for details.
   * @param onSuccess callback function if successfully get the Geo information.
   * @param controls control parametr; see http://developer.yahoo.com/geo/placefinder/ for details.
   * @param flags control flag; see http://developer.yahoo.com/geo/placefinder/ for details.
   * @param gflags special control flag; see http://developer.yahoo.com/geo/placefinder/ for details
   */
  void request(Map locations, YPlaceFinderSuccessCallback onSuccess, [Map controls, String flags, String gflags]) {
    StringBuffer params = new StringBuffer(); 
    if (locations !== null)
      locations.forEach((k,v) => params.isEmpty() ? params.add(k).add('=').add(v) : params.add('&').add(k).add('=').add(v));
    if (controls !== null) { //skip flags key
      controls.forEach((k,v) => 
          k.toLowerCase() == 'flags' ? params.add("") : params.isEmpty() ? 
              params.add(k).add('=').add(v) : params.add('&').add(k).add('=').add(v));
    }
    if (flags !== null) {
      if (!flags.isEmpty()) {
        //filter out "J" & "P" flag, always use XML
        flags = StringUtil.filterOut(flags, "JP");
        if (params.isEmpty()) 
          params.add("flags=").add(flags);
        else
          params.add("&flags=").add(flags);
      }
    }
    
    if (gflags !== null) {
      if (!gflags.isEmpty()) {
        if (params.isEmpty()) 
          params.add("gflags=").add(gflags);
        else
          params.add("&gflags=").add(gflags);
      }
    }
    
    StringBuffer url = new StringBuffer(_BASE_URI);
    if (!params.isEmpty())
      url.add("?").add(params);
    XMLHttpRequest req = new XMLHttpRequest();
    req.on.readyStateChange.add((event){
      if (req.readyState == XMLHttpRequest.DONE && req.status == 200) {
        final Document doc = req.responseXML;
        if (doc !== null) {
          Map resultSet = jsutil.xmlDocToDartMap(doc);
          onSuccess(resultSet);
        } else {
          onSuccess(null);
        }
      }
    });
    req.open("GET", url.toString(), true);
    req.send(null);
  }
}

typedef YPlaceFinderSuccessCallback(Map resultSet);