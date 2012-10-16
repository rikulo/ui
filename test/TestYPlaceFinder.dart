import 'package:rikulo/view.dart';
import 'package:rikulo/service/yapis.dart';
import 'package:rikulo/util.dart';

void main() {
  YPlaceFinder.loadGeoInfo({"location": "37.787082 -122.400929"}, 
      (Map resultSet) {
        if(resultSet == null)
          printc("Fail to loadGeoInfo.");
        else {
          Map result = resultSet["Result"];
          printc("woeid: ${result['woeid']}"); //12797156
          printc("city: ${result['city']}"); //San Francisco
        }
      }, gflags:"R"); 
}
