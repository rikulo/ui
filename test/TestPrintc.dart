//Sample Code: Test Log

import 'package:rikulo/view.dart';
import 'package:rikulo/util.dart';

void main() {
  printc("Started");
  printc(null);
  int count = 0;
  Button btn = new Button("Click Me!");
  btn.on.click.add((event) {
    printc("Clicked ${++count}");
  });
  final View mainView = new View()..addToDocument();
  mainView.addChild(btn);
}
