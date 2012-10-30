//Sample Code: Test Log

import 'package:rikulo/view.dart';

class Popup extends View {
  Popup() {
    classes.add("v-popup");

    on.activate.add((event) {
      if (event.shallClose(this))
        remove();
    });
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
      ..addToDocument()
      ..locateTo("south start", btn2);
  });
  view.addChild(btn2);

  new Section()
    ..addChild(view)
    ..addToDocument();
}
