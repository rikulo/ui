#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/service/yapis/yapis.dart');
#import('../../client/util/util.dart');

class TestYWeather extends Activity {

  void onCreate_() {
    YWeather loader = new YWeather("12797156", "c");
    loader.loadWeatherInfo((Map channel){
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
  new TestYWeather().run();
}
