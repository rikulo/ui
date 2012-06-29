//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 22, 2012  08:32::26 AM
// Author: hernichen

/**
 * Yahoo Weather RSS Feed; see http://developer.yahoo.com/weather/ for details.
 */
class YWeather {
  static final String _BASE_URI = "http://weather.yahooapis.com/forecastrss?";
  Map _channel; //cached channel if not expired yet.
  int _expireTime = 0;
  String _url;
  
  /**
   * Yahoo Weather for a woeid.
   * + [woeid] - The Yahoo woeid(Where On Earth ID) that represent a place; can use YPlaceFinder to get woeid.
   * + [unit] - Temperature unit; "c" for Celsius or "f" for Fahrenheit; default to "f".
   */
  YWeather(String woeid, [String unit='f']) {
    if (woeid === null || woeid.isEmpty()) {
      throw new IllegalArgumentException("woeid cannot be null/empty.");
    }
    if (unit !== null)
      unit = StringUtil.filterIn(unit.toLowerCase(), "fc"); //only "f" or "c" is allowed
    else
      unit = "f";
    _url = new StringBuffer(_BASE_URI).add("w=").add(woeid).add("&u=").add(unit).toString();
  }
  
  /** Return Weather information via callback function onSuccess(Map channel).
   * See http://developer.yahoo.com/weather/ for details. Note that YWeather will
   * return you the cached weather information if it is proper unless you force it to
   * re-load from the internet.
   * + [onSuccess(Map channel)] - Callback function if successfully get the Weather information.
   * + [force] - Whether to force loading the information from internet; default false.
   */
  void load(YWeatherSuccessCallback onSuccess, [bool force = false]) {
    //return cached channel if not expired yet!
    if (!force && _channel != null && new Date.now().millisecondsSinceEpoch < _expireTime) { 
      onSuccess(_channel);
    }
    GFeed feeder = new GFeed(_url);
    feeder.load((Map result) {
      Map channel = result != null ? result["channel"] : null;
      if (channel !== null) {
        //check if the woeid correct
        String ttl = channel["ttl"];
        if (ttl !== null) {
          _channel = channel; //cache the result
          _expireTime = Math.parseInt(ttl) * 60000 + new Date.now().millisecondsSinceEpoch;
        }
      }
      onSuccess(channel);
    });
  }
}

typedef YWeatherSuccessCallback(Map channel);