import 'package:rikulo/view.dart';
import 'package:rikulo/service/gmaps.dart';
import 'package:rikulo/util.dart';

void main() {
  GMap gmap = new GMap("mymap");
  Map mapOptions = {
                    "center": new LatLng(-34.397, 150.644),
                    "zoom": 8,
                    "mapTypeId": MapTypeId.ROADMAP
  };
  gmap.init(mapOptions, (GMap map) {
    new GMarker({
      "position": map.getCenter(),
      "map": map
    });
  });
}
