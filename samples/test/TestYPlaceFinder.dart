#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/service/yapis/yapis.dart');
#import('../../client/util/util.dart');

class TestYPlaceFinder extends Activity {

  void onCreate_() {
    YPlaceFinder finder = new YPlaceFinder();
    finder.loadGeoInfo({"location": "37.787082 -122.400929"}, 
      (Map resultSet) {
        if(resultSet === null)
          log("Fail to loadGeoInfo.");
        else {
          Map result = resultSet["Result"];
          log("woeid: ${result['woeid']}"); //12797156
          log("city: ${result['city']}"); //San Francisco
        }
      }, gflags:"R"); 
  }
}

void main() {
  new TestYPlaceFinder().run();
}
