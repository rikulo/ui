//Sample Code: Test Animation 2

import 'dart:html';
import 'dart:math';
import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';
import 'package:rikulo_commons/util.dart';

View createCube(int size, String txt) {
  View v = new View();
  v.width = size;
  v.height = size;
  v.style.border = "2px solid #3D4C99";
  v.style.borderRadius = "10px";
  v.style.backgroundColor = "#5C73E5";
  v.style.userSelect = "none";
  v.style.zIndex = "10";
  
  TextView txtv = new TextView(txt);
  txtv.width = v.width - 4;
  txtv.style.lineHeight = "${v.height - 4}px";
  txtv.style.textAlign = "center";
  txtv.style.color = "#EEEEEE";
  txtv.style.fontFamily = "Arial";
  txtv.style.fontWeight = "bold";
  txtv.style.userSelect = "none";
  v.addChild(txtv);
  
  return v;
}

MotionAction _action(Element elem, Offset center) => 
  (num x, MotionState state) {
    elem.style.left = Css.px(center.x + 50 * sin(x * 2 * PI));
    elem.style.top  = Css.px(center.y - 50 * cos(x * 2 * PI));
  };


void blue(View v) {
  v.style.borderColor = "#3D4C99";
  v.style.backgroundColor = "#5C73E5";
}

void green(View v) {
  v.style.borderColor = "#3D993D";
  v.style.backgroundColor = "#5CE55C";
}

void main() {
  final View mainView = new View()..addToDocument();
  
  List<Offset> centers = 
      [new Offset(100, 100), new Offset(400, 100), new Offset(100, 400)];
  List<int> repeats = [1, 3, -1];
  
  List<View> cubes = [];
  for (int i = 0; i < 3; i++) {
    View c = createCube(50, "Cube $i");
    c.left = centers[i].left;
    c.top = centers[i].top - 50;
    cubes.add(c);
    mainView.addChild(c);
  }
  
  List<EasingMotion> motions = [null, null, null];
  List<Button> stops = [];
  
  for (int i = 0; i < 3; i++) {
    Button b = new Button("Stop $i");
    b.left = 350;
    b.top = 350 + 50 * i;
    mainView.addChild(b);
    b.on.click.listen((ViewEvent event) {
      EasingMotion m = motions[i];
      if (m != null)
        m.stop();
      blue(cubes[i]);
    });
  }
  
  for (int i = 0; i < 3; i++) {
    cubes[i].on.click.listen((ViewEvent event) {
        return;
      green(cubes[i]);
      motions[i] = new EasingMotion(_action(cubes[i].node, centers[i]), 
          end: (MotionState state) {
            blue(cubes[i]);
          }, period: 1000, repeat: repeats[i])..run();
    });
  }
}
