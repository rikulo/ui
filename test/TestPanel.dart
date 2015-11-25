//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

import 'dart:html';

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/effect.dart';

void main() {
  final View mainView = new View()..addToDocument();
  
  final View vlayout = new View();
  vlayout.layout.type = "linear";
  vlayout.layout.orient = "vertical";
  vlayout.profile.width = vlayout.profile.height = "content";
  vlayout.style.border = "2px dashed #AAAAAA";
  mainView.addChild(vlayout);
  
  final Panel p1 = new Panel()..width = 200..height = 200;
  p1..addButton("max", (Event event) {
    printc("p1 min");
    
  })..addButton("max", (Event event) {
    printc("p1 max");
    
  })..addButton("close", (Event event) {
    printc("p1 close");
    new FadeOutEffect(p1.node, end: (MotionState state) => p1.remove()).run();
    
  });
  p1.addChild(new TextView("Panel Content")..profile.location = "center center");
  vlayout.addChild(p1);
  
  final EventListener _nothing = (Event event) {};
  
  final Panel p2 = new Panel();
  p2.profile.width = p2.profile.height = "content";
  p2.addChild(new TextView("Compact"));
  vlayout.addChild(p2);
  
  final Panel p3 = new Panel();
  p3.profile.width = p3.profile.height = "content";
  p3.addButton("close", _nothing);
  p3.addChild(new TextView("Compact"));
  vlayout.addChild(p3);
  
  final Panel p4 = new Panel();
  p4.profile.width = p4.profile.height = "content";
  p4..addButton("min", _nothing)..addButton("max", _nothing)..addButton("close", _nothing);
  p4.addChild(new TextView("Compact"));
  vlayout.addChild(p4);
  
  final Panel p5 = new Panel();
  p5.profile.width = "flex";
  p5.profile.height = "content";
  p5.addButton("close", _nothing);
  p5.addChild(new TextView("Panel Content"));
  vlayout.addChild(p5);
  
}
