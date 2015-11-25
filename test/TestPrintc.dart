//Sample Code: Test Log

import 'package:rikulo_ui/view.dart';

void main() {
  printc("Started");
  printc(null);
  int count = 0;
  Button btn = new Button("Click Me!");
  btn.on.click.listen((event) {
    printc("Clicked ${++count}");
  });
  final View mainView = new View()..addToDocument();
  mainView.addChild(btn);
}
