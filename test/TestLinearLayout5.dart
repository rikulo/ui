//Sample Code: LinearLayout Test 5

import 'dart:html';
import 'package:rikulo/view.dart';

void main() {
  document.title = "Test 5: Virtual Linear Layout";
  
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear; orient: vertical";
  mainView.addChild(new TextView("You shall see two buttons arranged vertically, and the width shall be best-fit"));
  mainView.addChild(new Button("The first button"));
  mainView.addChild(new Button("The second button"));
}
