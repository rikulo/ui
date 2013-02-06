//Sample Code: CompositeViewDemo

import 'dart:html';
import 'package:rikulo_ui/view.dart';
import 'LabeledInput.dart';

void main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear; orient: vertical";
  mainView.addChild(new LabeledInput("username"));
  mainView.addChild(new LabeledInput("password"));

  for (LabeledInput view in mainView.queryAll("LabeledInput"))
    view.on.change.listen((event) {
      print("$event received");
    });
  
}
