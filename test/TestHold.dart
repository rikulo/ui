//Sample Code: Test Log

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/html.dart';
import 'package:rikulo_ui/gesture.dart';
import 'package:rikulo_commons/util.dart';

TextView block(View parent, int duration, num limit, int top) {
  TextView v = new TextView("${duration/1000}s / ${limit}px");
  v.left = 50;
  v.top = top;
  v.height = 50;
  v.style.border = "2px solid #AAAAAA";
  v.style.borderRadius = "5px";
  v.style.lineHeight = "46px";
  v.style.backgroundColor = "#FFCCCC";
  
  bool c = false;
  parent.addChild(v);
  
  new HoldGesture(v.node, (HoldGestureState State) {
    v.style.backgroundColor = c ? "#FFCCCC" : "#CCCCFF";
    c = !c;
    
  }, start: (HoldGestureState) {
    
    
  }, duration: duration, movementLimit: limit);
  
  return v;
}

void main() {
  
  final View mainView = new View()..addToDocument();
  
  block(mainView, 1000, 3, 50);
  block(mainView, 1000, 100, 150);
  block(mainView, 5000, 3, 250);
  block(mainView, 100, 3, 350);
  
}
