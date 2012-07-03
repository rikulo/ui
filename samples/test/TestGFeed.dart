#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/service/gapis/gapis.dart');
#import('../../client/util/util.dart');

class TestGFeed extends Activity {

  void onCreate_() {
    GFeed feeder = new GFeed("http://weather.yahooapis.com/forecastrss?w=12797156");
    feeder.loadFeedInfo((Map result) {
      log("RSS result: $result");
      Map channel = result["channel"];
      log("channel: $channel");
      Map location = channel['yweather:location'];
      log("location: $location");
      Map units = channel['yweather:units'];
      log("units: $units");
      String degree = units['temperature'];
      log("degree: $degree");
      Map item = channel['item'];
      log("item: $item");
      Map condition = item['yweather:condition'];
      if (condition !== null) {
        log(location['city']);
        log(location['country']);
        log(condition['text']);
        log(condition['code']);
        log("${condition['temp']} $degree");
        log(condition['date']);
      }
    });
  }
}

void main() {
  new TestGFeed().run();
}
