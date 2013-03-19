//Sample Code: Custom Layout Demo

import 'dart:html' show Point;

import "package:rikulo_commons/util.dart";

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/event.dart';
import 'package:rikulo_ui/html.dart';

class CustomLayoutDemo {
  View anchor, mainView;

  void run() {
    mainView = new View()..addToDocument();

    TextView text = new TextView("Touch Anywhere You like");
    text.profile.text = "location: center center";
    mainView.addChild(text);
    mainView.on.click.listen((DomEvent event) {
      if (anchor == null)
        _createViews();
      _move(event.page - new DomAgent(mainView.node).page);
    });
  }
  void _move(Point offset) {
    anchor.left = offset.x - 35;
    anchor.top = offset.y - 35;
    anchor.requestLayout(false, true); //only views that depend on anchor (excluding anchor)
  }

  void _createViews() {
    anchor = _createTextView("Anchor", "#0ff");
    mainView.addChild(anchor);

    final View red = _createTextView("Mobile", "red");
    anchor.on.layout.listen((event) {
      red.left = anchor.left + anchor.width;
      red.top = anchor.top - anchor.height;
    });
    mainView.addChild(red);

    final View green = _createTextView("Web", "yellow");
    anchor.on.layout.listen((event) {
      green.left = anchor.left + anchor.width * 2;
      green.top = anchor.top;
    });
    mainView.addChild(green);
  }
  TextView _createTextView(String label, String color)  {
    final TextView text = new TextView(label);
    text.width = text.height = 70;
    text.style.cssText = "background: $color; border: 1px solid black; text-align: center; line-height: 68px";
    return text;
  }
}


void main() {
  new CustomLayoutDemo().run();
}
