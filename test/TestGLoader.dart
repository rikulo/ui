#import('../lib/app.dart');
#import('../lib/view.dart');
#import('../lib/service/gapis.dart');
#import('../lib/util.dart');

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
