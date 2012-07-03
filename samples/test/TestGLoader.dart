#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/service/gapis/gapis.dart');
#import('../../client/util/util.dart');

class TestGLoader extends Activity {

  void onCreate_() {
    GLoader loader = new GLoader();
    loader.loadIPLatLng((double lat, double lng) {
        log("lat: ${lat}, lng: ${lng}");
    });
    loader.load(GLoader.FEED, "1", {"callback": ()=>log("Feed loaded")});
  }
}

void main() {
  new TestGLoader().run();
}
