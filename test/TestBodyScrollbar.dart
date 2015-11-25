//Sample Code: Test Log

import "dart:html" show window;
import 'package:rikulo_ui/view.dart';

void main() {
  final View mainView = new View()..addToDocument();
  View view = new View();
  view.style.backgroundColor = "blue";
  view.width = 300;
  view.height = 250;
  view.left = window.innerWidth - 180;
  view.top = window.innerHeight - 180;
  mainView.addChild(view);
  mainView.addChild(new TextView("You shall see the scrollbar shown"));
}
