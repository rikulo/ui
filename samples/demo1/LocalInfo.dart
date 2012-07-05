//Copyright (C) 2012 Potix Corporation. A:ll Rights Reserved.
//History: Mon, Jun 25, 2012  02:38:10 PM
// Author: hernichen

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/html/html.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');
#import('../../client/util/util.dart');
#import('../../client/effect/effect.dart');
#import('../../client/service/gapis/gapis.dart');
#import('../../client/service/gmaps/gmaps.dart');
#import('../../client/service/yapis/yapis.dart');
#import('../../client/service/service.dart');

/**
 * Sample Code: Show the local time/weather/position information
 */
class LocalInfo extends Activity {
  View _homePanel; //home
  int _timeHandle;
  TextView _timeView;
  TextView _dateView;
  TextView _weekdayView;
  TextView _cityView;
  TextView _weatherView;
  TextView _tempView; //temperature
  TextView _htempView; //high temperature
  TextView _ltempView; //low temperature
  
  Image _weatherIcon;
  Image _locationIcon;
  Image _back;
  Switch _mapType;
  View _mapArea;
  View _mapView;
  GMap _gmap;
  
  void onCreate_() {
    _prepareLayout();
    _prepareController();
    _prepareTime();
    _prepareWeather();
    _prepareMaps();
  }
  
  //prepare layout
  void _prepareLayout() {
    title = "Local Information";

    mainView.style.backgroundImage = "url('img/phone_bg.png')";
    
    //home panel
    _homePanel = new View();
    _homePanel.profile.width = CSS.px(mainView.width);
    _homePanel.profile.height = CSS.px(mainView.height);
    _homePanel.width = mainView.width;
    _homePanel.height = mainView.height;
    mainView.addChild(_homePanel);
    
    //home area
    View homeArea = _createVlayout();
    homeArea.profile.width="114px";
    homeArea.profile.height = "100%";
    homeArea.profile.anchor = "parent";
    homeArea.profile.location = "center center";
    _homePanel.addChild(homeArea);
    
    homeArea.addChild(_createSpaceArea(0, 12));
    homeArea.addChild(_createTimeArea()); //timeArea
    homeArea.addChild(_createDateArea()); //dateArea
    homeArea.addChild(_createWeatherArea()); //weather area
    homeArea.addChild(_createLocationIcon()); //location area
    homeArea.addChild(_createLocationText()); //location area
    
//    homeArea.addChild(_createConfigArea()); //config area
    mainView.addChild(_createMapsArea()); //map area
    
    mainView.requestLayout(); //request layout 
  }
  
  View _createSpaceArea(int width, int height) {
    View view = new View();
    view.profile.width = "${width}px";
    view.profile.height = "${height}px";
    view.profile.spacing = "0";
    return view;
  }
  
  //prepare controller
  void _prepareController() {
    //press locationIcon shall hide homePanel and show MapArea
    _locationIcon.on.click.add((event) {
      new EasingMotion((num x) {
        int off = -(x * mainView.height).toInt();
        //_homePanel.style.transform = CSS.translate3d(0, off);
        _mapArea.style.transform = CSS.translate3d(0, off);
      }, duration: 350, start: (int time, int elapsed, int paused) {
        _mapArea.hidden = false;
        _prepareMaps();
        _gmap.checkResize();
        _mapArea.requestLayout();
      }, end: (int time, int elapsed, int paused) {
        _homePanel.hidden = true;
        _back.hidden = false;
      });
    });
    
    //press back shall hide MapArea and show homePanel
    _back.on.click.add((event) {
      new EasingMotion((num x) {
        int off = -((1-x) * mainView.height).toInt();
        //_homePanel.style.transform = CSS.translate3d(0, off);
        _mapArea.style.transform = CSS.translate3d(0, off);
      }, duration: 350, start: (int time, int elapsed, int paused) {
        _homePanel.hidden = false;
        _back.hidden = true;
        _prepareWeather();
      }, end: (int time, int elapsed, int paused) {
        _mapArea.hidden = true;
      });
    });
  }
  
  //show current time
  void _prepareTime() {
    if (_timeHandle == null) {
      _timeHandle = window.setInterval((){
        if (_prepareTime0()) { //on tick 
          window.clearInterval(_timeHandle);
          //sync to minute
          _timeHandle = window.setInterval(() { 
            if (!_prepareTime0()) { //not on tick (skewed)
              window.clearInterval(_timeHandle);
              _timeHandle = null;
              _prepareTime(); //re-sync
            }
          }, 60000); //every minute
        }
      }, 500); //every 0.5 second
    }
  }
  
  bool _prepareTime0() {
    List<String> nowtime = _getNowTime();
    _timeView.text=nowtime[0];
    _dateView.text=nowtime[1];
    _weekdayView.text=nowtime[2];
    
    return nowtime[3] !== null;
  }

  double _lat, _lng;
  void _loadSmartIPInfo(LatLngSuccessCallback onSuccess) {
    SmartIP geoip = new SmartIP();
    geoip.loadIPGeoInfo((Map info) {
      String latstr = info["latitude"];
      String lngstr = info["longitude"];
      if (latstr !== null) {
        _lat = Math.parseDouble(latstr);
        _lng = Math.parseDouble(lngstr);
        onSuccess(_lat, _lng);
      }
    });
  }
  
  void _loadIPLatLng(LatLngSuccessCallback onSuccess) {
    if (_lat != null)
      onSuccess(_lat, _lng);
    else {
      GLoader.loadIPLatLng((double lat, double lng) {
        if (lat != null) {
          _lat = lat;
          _lng = lng;
          onSuccess(_lat, _lng);
        } else
          _loadSmartIPInfo(onSuccess);
      });
    }
  }
    
  //show weather forcast
  void _prepareWeather() {
    _loadIPLatLng((double lat, double lng) => _prepareWeather0(lat, lng));
  }

  //prepare local maps
  void _prepareMaps() {
    _loadIPLatLng((double lat, double lng) => _prepareMaps0(lat, lng));
  }

  //create Time area
  View _createTimeArea() {
    //time view
    _timeView = _createTextView(48, _getNowTime()[0]);
    _timeView.profile.width = "100%";
    _timeView.profile.height = "52px";
    _timeView.profile.spacing = "0";
    _timeView.style.textAlign = "center";
    return _timeView;
  }
  
  //create Date area
  View _createDateArea() {
    //dateArea
    View dateArea = new View();
    dateArea.profile.width = "100%";
    dateArea.profile.height = "24px";
    dateArea.profile.spacing = "0";
    
    //_dateView
    _dateView = _createTextView(10, _getNowTime()[1]);
    _dateView.profile.anchor="parent";
    _dateView.profile.location = "left top";
    
    //_weekdayView
    _weekdayView = _createTextView(9, _getNowTime()[2]);
    _weekdayView.profile.anchor="parent";
    _weekdayView.profile.location = "right top";
    
    dateArea.addChild(_dateView);
    dateArea.addChild(_weekdayView);
    return dateArea;
  }
  
  //create Weather area
  View _createWeatherArea() {
    View weatherArea = _createVlayout();
    weatherArea.profile.width = "100%";
    //weatherArea.profile.height = "44px";
    weatherArea.profile.spacing = "0";

    //temperatureArea
    View tempArea = _createHlayout();
    tempArea.profile.width="100%";
    //tempArea.profile.height = "18px";
    tempArea.profile.spacing = "0";

    weatherArea.addChild(tempArea);
    
    //temperatureView
    _tempView = _createTextView(18, "00°");
    _tempView.profile.width = "28px"; 
    _tempView.profile.spacing = "0";
    tempArea.addChild(_tempView);
    
    //hiloView
    View hiloView = _createVlayout();
    hiloView.profile.width = "50%";
    hiloView.profile.spacing = "3";
    tempArea.addChild(hiloView);
    
    //hiView
    _htempView = _createTextView(8, "H: 00°");
    _htempView.profile.width = "100%";
    _htempView.profile.spacing = "0";
    _ltempView = _createTextView(8, "L: 00°");
    _ltempView.profile.width = "100%";
    _ltempView.profile.spacing = "0";
    hiloView.addChild(_htempView);
    hiloView.addChild(_ltempView);
    
    //city view
    _cityView = _createTextView(10, "N/A");
    _cityView.profile.width = "70%";
    _cityView.profile.spacing = "0";
    weatherArea.addChild(_cityView);
    
    //weather view
    _weatherView = _createTextView(8, "N/A");
    _weatherView.profile.width = "70%";
    _weatherView.profile.spacing = "0";
    weatherArea.addChild(_weatherView);
    
    //icon view
    _weatherIcon = new Image("img/weather3200.png");
    _weatherIcon.profile.anchor = "parent";
    _weatherIcon.profile.location = "center right";
    _weatherIcon.profile.width = "40px";
    _weatherIcon.profile.height = "40px";
    _weatherIcon.on.layout.add((evt){_weatherIcon.left += 3;});
    weatherArea.addChild(_weatherIcon);
    
    return weatherArea;
  }
  
  //create location area
  View _createLocationIcon() {
    _locationIcon = new Image("img/location_icon.png");
    _locationIcon.profile.anchor = "parent"; 
    _locationIcon.profile.location = "bottom center";
    _locationIcon.profile.width = "28px";
    _locationIcon.profile.height = "28px";
    _locationIcon.on.layout.add((evt){_locationIcon.top -= 45;});
    _locationIcon.style.borderRadius="14px";
    _locationIcon.style.animationName="glow";
    _locationIcon.style.animationTimingFunction="ease-in";
    _locationIcon.style.animationIterationCount="infinite";
    _locationIcon.style.animationDirection="alternate";
    _locationIcon.style.animationDuration="3000ms";
   // _locationIcon.style.boxShadow="0 0 15px #FFFFFF";
    
    return _locationIcon;
  }
  
  View _createLocationText() {
    TextView locationText = _createTextView(10, "My Location");
    locationText.profile.width = "60%";
    locationText.profile.anchor = "parent";
    locationText.profile.location = "bottom center";
    locationText.style.textAlign = "center";
    locationText.on.layout.add((evt){locationText.top -= 30;});
    
    return locationText;
  }
  
  static int _BAR_HEIGHT = 26;
  //create Maps area
  View _createMapsArea() {
    //Maps area
    View mapArea = _createVlayout();
    mapArea.profile.height = CSS.px(mainView.height);
    mapArea.profile.width = CSS.px(mainView.width);
    mapArea.width = mainView.width;
    mapArea.height = mainView.height;
    mapArea.style.marginTop = CSS.px(mainView.height);

    //toolbar
    View tbar = _createHlayout();
    tbar.style.backgroundColor = "rgba(0,0,0,0)"; //"rgba(0,0,0,0.6)"
    tbar.profile.width = CSS.px(mainView.width);
    tbar.profile.height = CSS.px(_BAR_HEIGHT);
    tbar.style.lineHeight = CSS.px(_BAR_HEIGHT);
    tbar.profile.spacing = "0";
    tbar.height = 16;
    mapArea.addChild(tbar);
    
    //back button
    _back = new Image("img/back_button.png");//_createTextView(10, "Back");
    _back.profile.width = "26px"; //"34px";
    _back.profile.height = "12px"; //"16px";
//    _back.style.lineHeight = "16px";

    _back.profile.anchor = "parent";
    _back.profile.location = "center left";
    _back.on.layout.add((event)=>_back.left += 5);
    tbar.addChild(_back);
    _back.hidden = true;
    
    //map type switch
    _mapType = new Switch(true, "Map", "Sat.");
    _mapType.classes.add("v-small");
    _mapType.profile.anchor = "parent";
    _mapType.profile.location = "center right";
    _mapType.on.layout.add((event)=>_mapType.left -= 4);
    _mapType.on.change.add((evt) {
      if (_gmap !== null)
        _gmap.setMapTypeId(_mapType.value ? MapTypeId.ROADMAP : MapTypeId.HYBRID);
    });
    tbar.addChild(_mapType);

    //Maps view
    View mapView = new View();
    mapView.style.backgroundColor = "#FFFFFF";
    mapView.profile.width = CSS.px(mainView.width);
    mapView.profile.height = CSS.px(mainView.height - _BAR_HEIGHT);
    mapView.profile.spacing = "0";
    mapArea.addChild(mapView);
    _mapView = mapView;
    
    mapArea.hidden = true;
    return _mapArea = mapArea;
  }
  
  static List<String> _WEEKDAYS = const ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
  //return the current time in HH:mm format
  List<String> _getNowTime() {
    Date now = new Date.now();
    int h = now.hour;
    int m = now.minute;
    String hour = h < 10 ? "0${h}" : "${h}";
    String minute = m < 10 ? "0${m}" : "${m}";

    int year = now.year;
    int month = now.month;
    int day = now.day;
    
    int weekday = now.weekday;
        
    return ["${hour}:${minute}", "${year}-${month}-${day}", _WEEKDAYS[weekday-1], now.second == 0 ? "tick" : null];
  }
  
  //locate woeid per latitude and longitude; then retrieve weather info
  void _prepareWeather0(double lat, double lng) {
    YPlaceFinder.loadGeoInfo({"location": "${lat}, ${lng}"}, 
      (Map resultSet) {
        Map result = resultSet["Result"];
        String woeid = result['woeid']; //locate woeid
        _prepareWeather1(woeid);
      }, gflags:"R");
  }
  
  //retrieve weather info per the woeid and show
  void _prepareWeather1(String woeid) {
    YWeather finder = new YWeather(woeid, "c");
    finder.loadWeatherInfo((Map channel){
      if (channel == null || channel.isEmpty()) { //no proper weather info
        return;
      }
      Map location = channel['yweather:location'];
      if (location !== null) {
        int ttl = Math.parseInt(channel["ttl"]) * 60000;
        String city = location['city'];
        Map item = channel['item'];
        Map condition = item['yweather:condition']; //current condition
        Map forecast = item['yweather:forecast'][0]; //forecast
        String low = forecast['low'];
        String high = forecast['high'];
        String text = condition['text'];
        String temp = condition['temp'];
        int code = condition['code'];
        String imgurl = "img/weather${code}.png"; //image url pattern 
        _tempView.text = "${temp}°";
        _htempView.text = "H: ${high}°";
        _ltempView.text = "L: ${low}°";
        _cityView.text = city;
        _weatherView.text = text;
        _weatherIcon.src = imgurl;
        
        window.setTimeout(()=>_prepareWeather1(woeid), ttl); //update after information expired
      }
    });
  }

  //prepare Google Maps per the given latitude/longitude
  void _prepareMaps0(double lat, double lng) {
    if (_gmap !== null) //already initilized, return
      return;
    
    GMap gmap = new GMap(_mapView.uuid);
    Map mapOptions = {
      "center": new LatLng(lat, lng),
      "zoom": 11,
      "mapTypeControl" : false,
      "streetViewControl" : false,
      "mapTypeId": MapTypeId.ROADMAP
    };

    gmap.init(mapOptions, (GMap map) {
      new GMarker({
        "position": map.getCenter(),
        "map": map
      });
      _mapView.on.layout.add((event)=>map.checkResize());
      _gmap = map;
    }); 
  }

  //create text view
  TextView _createTextView(int fontsize, [String content=""]) {
    TextView text = new TextView(content);
    text.style.color = "rgba(255,255,255,1)";
    text.style.fontFamily = "'Droid Sans'";
    text.style.fontSize = "${fontsize}px";
    text.style.textShadow = "1px 1px 3px rgba(0,0,0,0.3)";
    //text.style.fontWeight = "bold";
    
    return text;
  }
  
  //create vlayout
  View _createVlayout() {
    View vlayout = new View();
    vlayout.layout.type = "linear";
    vlayout.layout.orient = "vertical";
    
    return vlayout;
  }
  
  //create hlayout
  View _createHlayout() {
    View hlayout = new View();
    hlayout.layout.type = "linear";
    hlayout.layout.orient = "horizontal";
    
    return hlayout;    
  }  
}

main() {
  new LocalInfo().run();
}