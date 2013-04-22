//Sample Code: Test ZoomGesture

import 'dart:html';
import 'dart:math';

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/gesture.dart';
import 'package:rikulo_ui/event.dart';
import 'package:rikulo_commons/util.dart';
import "package:rikulo_commons/html.dart";

final int statusHeight = 50;

String printPoint(Point off) => 
    "(${(off.x * 100).toInt() / 100}, ${(off.y * 100).toInt() / 100})";

View dot(String color, int zIndex) {
  View d = new View();
  d.width = d.height = 0;
  d.style.border = "5px solid $color";
  d.style.borderRadius = "5px";
  d.style.boxShadow = "0 0 10px $color";
  d.style.zIndex = "$zIndex";
  d.visible = false;
  return d;
}

TextView label([String text]) {
  final int fontSize = statusHeight ~/ 2;
  TextView lb = new TextView();
  lb.profile.text = "height: 100%; width: flex";
  lb.style.fontSize = CssUtil.px(fontSize);
  lb.style.lineHeight = CssUtil.px(statusHeight);
  if (text != null)
    lb.html = text;
  return lb;
}

void main() {
  View sf0 = dot("#DDFF33", 10);
  View sf1 = dot("#DDFF33", 10);
  View cf0 = dot("#33FFBB", 20);
  View cf1 = dot("#33FFBB", 20);
  
  View panel = new View();
  panel.profile.text = "location: top center; width: 100%";
  panel.style.backgroundColor = "#000000";
  panel.style.overflow = "hidden";
  
  TextView sc = label("-");
  TextView ro = label("-");
  TextView tr = label("-");
  
  View status = new View();
  status.layout.type = "linear";
  status.layout.orient = "horizontal";
  status.profile.text = "location: bottom center; width: 100%";
  status.height = statusHeight;
  
  // view tree
  panel..addChild(sf0)..addChild(sf1)..addChild(cf0)..addChild(cf1);
  status..addChild(sc)..addChild(ro)..addChild(tr);
  
  final View mainView = new View()..addToDocument();
  mainView..addChild(panel)..addChild(status);
  
  // sizing
  panel.on.preLayout.listen((LayoutEvent e) {
    panel.height = new DomAgent(mainView.node).innerHeight - statusHeight;
  });
  
  // zoom gesture
  new ZoomGesture(panel.node, start: (ZoomGestureState state) {
    List<Point> poss = state.positions;
    cf0.left = sf0.left = poss[0].x;
    cf0.top  = sf0.top  = poss[0].y;
    cf1.left = sf1.left = poss[1].x;
    cf1.top  = sf1.top  = poss[1].y;
    cf0.visible = sf0.visible = true;
    cf1.visible = sf1.visible = true;
    
  }, move: (ZoomGestureState state) {
    List<Point> poss = state.positions;
    cf0.left = poss[0].x;
    cf0.top  = poss[0].y;
    cf1.left = poss[1].x;
    cf1.top  = poss[1].y;
    
    sc.html = "${(state.scalar * 10000).toInt() / 100}%";
    ro.html = "${(state.angle * 1800 ~/ PI) / 10}&deg;";
    tr.html = "${state.transition}";
    
  }, end: (ZoomGestureState state) {
    cf0.visible = sf0.visible = false;
    cf1.visible = sf1.visible = false;
    
  });
  
}
