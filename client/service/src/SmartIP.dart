//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  05:22:36 PM
// Author: hernichen

/**
 * Bridge Dart to Smart-IP.net Geo IP API; see http://smart-ip.net/geoip-api for details.
 * Retrieve Geo IP information per the provided host or IP address.
 */
class SmartIP {
  static final String _BASE_URI = "http://smart-ip.net/geoip-json?";
  static final String _GEO_IP = "geoip";
  static int _fnnum = 0;

  /** Load geo information per the specified [host]/IP in a Map via callback function [onSuccess].
   * + [onSuccess] callback function if successfully get the Geo IP information.
   * + [host] the IP address or host name to look for geo information; default to the IP of the
   * calling client. See section "Building Queries" of http://smart-ip.net/geoip-api for details.
   * + [type] network type; default to "auto". Meaning for if host is a name. See section 
   * "Building Queries" of http://smart-ip.net/geoip-api for details.
   * + [lang] language of a query; default to auto-detection. See section "Building Queries" 
   * of http://smart-ip.net/geoip-api for details.
   */
  void loadIPGeoInfo(GeoIPSuccessCallback onSuccess, [String host, String type, String lang]) {
    StringBuffer params = new StringBuffer();
    String nm = "${_GEO_IP}${_fnnum++}";
    params.add("callback=_natives.${nm}");
    if (host != null && !host.isEmpty()) {
      params.add("&host=").add(host);
    }
    if (type != null && !type.isEmpty()) {
      params.add("&type=").add(type);
    }
    if (lang != null && !lang.isEmpty()) {
      params.add("&lang=").add(lang);
    }
    //JSONP
    String url = "${_BASE_URI}${params}";
    JSUtil.addJSFunction(nm, JSUtil.toJSFunction((jsmap) {
      JSUtil.removeJavaScriptSrc(url);
      JSUtil.rmJSFunction(nm);
      onSuccess(JSUtil.toDartMap(jsmap));
    }, 1));
    JSUtil.injectJavaScriptSrc(url);
  } 
}

typedef GeoIPSuccessCallback(Map geoip);
