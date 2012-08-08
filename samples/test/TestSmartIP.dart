#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/service/service.dart');
#import('../../client/util/util.dart');

class TestSmartIP extends Activity {

  void onCreate_() {
    SmartIP loader = new SmartIP();
    loader.loadIPGeoInfo((Map geoip) {
        printc('''
          source: ${geoip['source']},
          host: ${geoip['host']},
          lang: ${geoip['lang']},
          countryName: ${geoip['countryName']},
          countryCode: ${geoip['countryCode']},
          city: ${geoip['city']},
          region: ${geoip['region']},
          latitude: ${geoip['latitude']}, 
          longitude: ${geoip['longitude']},
          timezone: ${geoip['timezone']}
        ''');
    });
  }
}

void main() {
  new TestSmartIP().run();
}
