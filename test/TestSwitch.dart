//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

import 'dart:html';

import 'package:rikulo/view.dart';
import 'package:rikulo/model.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/util.dart';

Switch createSwitch(bool value, [String onLabel, String offLabel, bool small=false]) {
  Switch view = new Switch(value, onLabel, offLabel);
  if (small)
    view.classes.add("v-small");
  view.on.change.add((event){
    printc("Switch${view.uuid}: ${view.value}");
  });
  return view;
}

void main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear; orient: vertical";

  mainView.addChild(createSwitch(true));
  mainView.addChild(createSwitch(false));
  mainView.addChild(createSwitch(true, "Yes", "No"));
  mainView.addChild(createSwitch(false, "True", "False"));
  mainView.addChild(createSwitch(true, small: true));
  mainView.addChild(createSwitch(false, small: true));
}
