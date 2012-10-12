#import('package:rikulo/app.dart');
#import('package:rikulo/view.dart');
#import('package:rikulo/service/gapis.dart');
#import('package:rikulo/util.dart');

class TestGLoader extends Activity {

  void onCreate_() {
    GLoader.loadIPLatLng((double lat, double lng) {
        printc("lat: ${lat}, lng: ${lng}");
    });
    GLoader.load(GLoader.FEED, "1", {"callback": ()=>printc("Feed loaded")});
  }
}

void main() {
  new TestGLoader().run();
}
