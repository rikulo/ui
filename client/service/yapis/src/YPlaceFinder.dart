//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  05:22:36 PM
// Author: hernichen

/**
 * Bridge Dart to Yahoo PlaceFinder API; see http://developer.yahoo.com/geo/placefinder/ for details.
 */
class YPlaceFinder {
  static final String _BASE_URI = "http://where.yahooapis.com/geocode";
  
  /** Load geo information per the specified [location] parameters in a Map via callback function [success]; see 
   * <http://developer.yahoo.com/geo/placefinder/guide/responses.html> for details.
   * + [locations] location parameter; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details.
   * + [success(Map ResultSet)] callback function if successfully get the Geo information.
   * + [controls] optional control parametr; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details.
   * + [flags] optional control flag; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details.
   * + [gflags] optional special control flag; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details
   */
  static void loadGeoInfo(Map locations, YPlaceFinderSuccessCallback success, [Map controls, String flags, String gflags]) {
    StringBuffer params = new StringBuffer(); 
    if (locations != null)
      locations.forEach((k,v) => params.isEmpty() ? params.add(k).add('=').add(v) : params.add('&').add(k).add('=').add(v));
    if (controls != null) { //skip flags key
      controls.forEach((k,v) => 
          k.toLowerCase() == 'flags' ? params.add("") : params.isEmpty() ? 
              params.add(k).add('=').add(v) : params.add('&').add(k).add('=').add(v));
    }
    if (flags != null) {
      if (!flags.isEmpty()) {
        //filter out "J" & "P" flag, always use XML
        flags = StringUtil.filterOut(flags, "JP");
        if (params.isEmpty()) 
          params.add("flags=").add(flags);
        else
          params.add("&flags=").add(flags);
      }
    }
    
    if (gflags != null) {
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
    HttpRequest req = new HttpRequest();
    req.on.readyStateChange.add((event){
      if (req.readyState == HttpRequest.DONE && req.status == 200) {
        final Document doc = req.responseXML;
        if (doc != null) {
          Map resultSet = JSUtil.xmlDocToDartMap(doc);
          success(resultSet);
        } else {
          success(null);
        }
      }
    });
    req.open("GET", url.toString(), true);
    req.send(null);
  }
}

typedef YPlaceFinderSuccessCallback(Map resultSet);