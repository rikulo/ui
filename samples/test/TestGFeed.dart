#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/service/gapis/gapis.dart');
#import('../../client/util/util.dart');

class TestGFeed extends Activity {

  void onCreate_() {
    GFeed feeder = new GFeed("http://weather.yahooapis.com/forecastrss?w=12797156");
    feeder.loadFeedInfo((Map result) {
      printc("RSS result: $result");
      Map channel = result["channel"];
      printc("channel: $channel");
      Map location = channel['yweather:location'];
      printc("location: $location");
      Map units = channel['yweather:units'];
      printc("units: $units");
      String degree = units['temperature'];
      printc("degree: $degree");
      Map item = channel['item'];
      printc("item: $item");
      Map condition = item['yweather:condition'];
      if (condition != null) {
        printc(location['city']);
        printc(location['country']);
        printc(condition['text']);
        printc(condition['code']);
        printc("${condition['temp']} $degree");
        printc(condition['date']);
      }
    });
  }
}

void main() {
  new TestGFeed().run();
}
