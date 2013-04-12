//Sample Code: SwipeGesture

import 'dart:html';
import 'dart:math';

import "package:rikulo_commons/util.dart";

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/event.dart';
import 'package:rikulo_ui/effect.dart';

TextView block(String text, int left, int top) {
  TextView tv = new TextView(text);
  tv.width = tv.height = 100;
  tv.left = left;
  tv.top = top;
  tv.classes.add("block");
  tv.style.lineHeight = "96px";
  return tv;
}

void main() {
  document.body.style.margin = "0";
  
  final View mainView = new View()..addToDocument();
  mainView.style.background = "#000000";
  
  View v;
  mainView.addChild(v = block("Breathe", 50, 50));
  
  final num n = 0.35;
  final Element element = v.node;
  new EasingMotion((num x, MotionState state) {
    element.style.boxShadow = "0 0 10px 2px rgba(255, 255, 255, $x)";
    element.style.transform = "scale(${1 + x / 10})";
    
  }, period: 5000, repeat: -1, 
  easing: (num t) => (1 - cos(t < n ? t * PI / n : (1 - t) * PI / (1 - n))) / 2).run();
  
}
