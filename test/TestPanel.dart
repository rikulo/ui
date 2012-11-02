//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

import 'dart:html';

import 'package:rikulo/view.dart';
import 'package:rikulo/model.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';
import 'package:rikulo/util.dart';

void main() {
  final View mainView = new View()..addToDocument();
  
  final View vlayout = new View();
  vlayout.layout.type = "linear";
  vlayout.layout.orient = "vertical";
  vlayout.profile.width = vlayout.profile.height = "content";
  vlayout.style.border = "2px dashed #AAAAAA";
  mainView.addChild(vlayout);
  
  final Panel p1 = new Panel()..width = 200..height = 200;
  p1..addButton("close", (Event event) {
    printc("p1 close");
    new FadeOutEffect(p1.node, end: (MotionState state) => p1.remove()).run();
  })..addButton("max", (Event event) {
    printc("p1 max");
  })..addButton("max", (Event event) {
    printc("p1 min");
  });
  p1.addChild(new TextView("Panel Content"));
  
  vlayout.addChild(p1);
  
  final Panel p2 = new Panel();
  p2.profile.width = p2.profile.height = "content";
  p2.addChild(new TextView("Compact"));
  vlayout.addChild(p2);
  
  final Panel p3 = new Panel();
  p3.profile.width = p3.profile.height = "content";
  p3.addButton("close", (Event event) => p3.remove());
  p3.addChild(new TextView("Compact"));
  vlayout.addChild(p3);
  
}
