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
  
  final Panel p1 = new Panel(max: (ViewEvent event) {
    // max
  }, min: (ViewEvent event) {
    // min
  }, dismiss: (ViewEvent event) {
    View v = event.target;
    new FadeOutEffect(v.node, end: (MotionState state) => v.remove()).run();
  }, closeBtn: true);
  
  p1..width = 200..height = 200;
  p1.addChild(new TextView("Panel Content"));
  
  p1.on.dismiss.add((ViewEvent event) {
    printc("event: dismiss");
  });
  p1.on["maximize"].add((ViewEvent event) {
    printc("event: maximize");
  });
  p1.on["minimize"].add((ViewEvent event) {
    printc("event: minimize");
  });
  
  vlayout.addChild(p1);
  
  final Panel p2 = new Panel();
  p2.profile.width = p2.profile.height = "content";
  p2.addChild(new TextView("Compact"));
  vlayout.addChild(p2);
  
  final Panel p3 = new Panel(closeBtn: true);
  p3.profile.width = p3.profile.height = "content";
  p3.addChild(new TextView("Compact"));
  vlayout.addChild(p3);
  
}
