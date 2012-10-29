//Sample Code: Test Log

import 'package:rikulo/view.dart';
import 'package:rikulo/event.dart';

class Popup extends View {
  ViewEventListener _fnClickOutside;

  //@override
  void mount_() {
    super.mount_();

    broadcaster.on.popup.add(_fnClickOutside = (event) {
        if (visible && inDocument && event.shallClose(this))
          removeFromDocument();
      });
  }
  //@override
  void unmount_() {
    broadcaster.on.popup.remove(_fnClickOutside);
    super.unmount_();
  }
}
void main() {
  View view = new View();
  view.classes.add("v-dialog");
  view.style.overflow = "auto";
  view.profile.text = "width: 80%; height: 80%; location: center center";

  View color = new View();
  color.style.backgroundColor = "blue";
  color.left = color.top = 100;
  color.width = 2000;
  color.height = 600;
  view.addChild(color);

  Button btn = new Button("Show Popup");
  btn.profile.anchorView = color;
  btn.profile.location = "north start";
  view.addChild(btn);

  View popup = new Popup()
    ..width = 300
    ..height = 200
    ..classes.add("v-dialog")
    ..style.backgroundColor = "yellow";
  popup.profile..anchorView = btn
    ..location = "south start";

  btn.on.click.add((event) {
    popup.addToDocument(layout: true);
  });

  Button btn2 = new Button("Create Popup 1");
  btn2.profile.anchorView = btn;
  btn2.profile.location = "east start";
  btn2.on.click.add((event) {
    final pp = new Popup()
      ..width = 200
      ..height = 150
      ..style.backgroundColor = "orange"
      ..addToDocument(layout: false)
      ..locateTo("south start", btn2);
  });
  view.addChild(btn2);

  new Section()
    ..addChild(view)
    ..addToDocument();
}
