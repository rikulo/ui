import 'package:rikulo/view.dart';
import 'package:rikulo/service.dart';
import 'package:rikulo/util.dart';

void main() {
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
