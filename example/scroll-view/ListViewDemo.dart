//Sample Code: ScrollView

import 'package:rikulo/util.dart';
import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';

void main() {
  ScrollView view;
  view = new ScrollView(direction: Dir.VERTICAL, 
  snap: (Offset off) {
    final num vlimit = 50 * 50 - view.innerHeight;
    final num y = off.y >= vlimit ? vlimit : ((off.y + 25) / 50).floor() * 50;
    return new Offset(off.x, y);
  });
  view.profile.text = "location: center center; width: 80%; height: 80%";
  view.classes.add("list-view");

  for (int x = 0; x < 50; ++x) {
    View child = new TextView("Row ${x + 1}");
      
    final int height = 50;
    child.classes.add("list-item");
    child.style.cssText = "line-height: ${height}px";
    child.profile.width = "flex";
    child.top = x * height;
    child.height = height;
    
    view.addChild(child);
  }
    
  final View mainView = new View()..addToDocument();
  mainView.addChild(view);
}
