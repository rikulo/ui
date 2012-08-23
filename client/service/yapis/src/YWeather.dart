//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 22, 2012  08:32::26 AM
// Author: hernichen

/**
 * Bridge Dart to Yahoo Weather RSS Feed; see <http://developer.yahoo.com/weather/> for details.
 */
class YWeather {
  static final String _BASE_URI = "http://weather.yahooapis.com/forecastrss?";
  Map _channel; //cached channel if not expired yet.
  int _expireTime = 0;
  GFeed _feeder;

  final String woeid;
  String _unit;
  String get unit => _unit;

  /**
   * Yahoo Weather for a woeid.
   *
   * + [woeid] - The Yahoo woeid(Where On Earth ID) that represent a place; can use YPlaceFinder to get woeid.
   * + [unit] - Temperature unit; "c" for Celsius or "f" for Fahrenheit; default to "f".
   */
  YWeather(this.woeid, [String unit='f']) {
    if (woeid == null || woeid.isEmpty()) {
      throw new IllegalArgumentException("woeid cannot be null/empty.");
    }
    if (unit != null)
      unit = StringUtil.filterIn(unit.toLowerCase(), "fc"); //only "f" or "c" is allowed
    else
      unit = "f";
    _unit = unit;
  }

  /** Load Weather information in a Map via callback function [success].
   * See <http://developer.yahoo.com/weather/> for details.
   *
   * Note that YWeather will return you the cached weather information if the information is
   * not expired yet unless you force it to re-load from the internet.
   *
   * + [success(Map channel)] - Callback function if successfully get the Weather information.
   * + [force] - Whether to force loading the information from internet; default false.
   */
  void loadWeatherInfo(YWeatherSuccessCallback success, [bool force = false]) {
    //return cached channel if not expired yet!
    int now = new Date.now().millisecondsSinceEpoch;
    if (!force && _channel != null && now < _expireTime) {
      success(_channel);
      return;
    }
    if (_feeder == null) {
      String url = "${_BASE_URI}w=${woeid}&u=${_unit}";
      _feeder = new GFeed(url);
    }
    _feeder.loadFeedInfo((Map result) {
      Map channel = result != null ? result["channel"] : null;
      if (channel != null) {
        //check if the woeid correct
        String ttl = channel["ttl"];
        if (ttl != null) {
          _channel = channel; //cache the result
          _expireTime = parseInt(ttl) * 60000 + now;
        }
      }
      success(channel);
    });
  }
}

typedef YWeatherSuccessCallback(Map channel);