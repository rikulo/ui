//Sample Code: Star Chart Demo

import 'dart:math';
import "package:rikulo_commons/util.dart";

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/html.dart';

View _system(Offset pos, num maxsyssize, int rad, [String name]) {
  View sys = new View();
  sys.width = sys.height = 0;
  
  final int shownRad = max(3, rad).toInt();
  sys.left = pos.left.toInt() - shownRad;
  sys.top = pos.top.toInt() - shownRad;
  sys.style.borderWidth = sys.style.borderRadius = Css.px(shownRad);
  sys.classes.add("star");
  
  final int subsysnum = (rad * _rand() / 3).toInt();
  for (int i = 0; i < subsysnum; i++) {
    int subsyssize = (maxsyssize * (1 + _rand()) / 2).toInt();
    int subrad = (rad * (_rand() * 2 + 1) / 3).toInt();
    num subdist = subsyssize + (maxsyssize - subsyssize) * 3 * _rand();
    num subarg = _rand() * PI * 2;
    Offset subpos = new Offset(subdist * cos(subarg), subdist * sin(subarg));
    View subsys = _system(subpos, subsyssize, subrad);
    sys.addChild(subsys);
    sys.addChild(_line(subpos));
  }
  
  if (name != null) {
    TextView tv = new TextView(name);
    tv.profile.location = "south center";
    tv.style.color = "#CCCCCC";
    tv.style.paddingTop = Css.px(rad);
    sys.addChild(tv);
  }
  
  return sys;
}

View _line(Offset pos, [num span = 1]) {
  View lv = new View();
  lv.style.backgroundColor = "#FFFFFF";
  
  final num absx = pos.x.abs(), absy = pos.y.abs();
  
  if (absx > absy) {
    lv.width = absx.toInt();
    lv.height = 1;
    lv.left = min(0, pos.x).toInt();
    lv.top = (pos.y / 2).toInt();
    lv.style.transform = "matrix(${pos.x < 0 ? -1 : 1},${pos.y/absx},0,1,0,0)";
  } else {
    lv.height = absy.toInt();
    lv.width = 1;
    lv.top = min(0, pos.y).toInt();
    lv.left = (pos.x / 2).toInt();
    lv.style.transform = "matrix(1,0,${pos.x/absy},${pos.y < 0 ? -1 : 1},0,0)";
  }
  
  return lv;
}

Random _r = new Random();
double _rand() => _r.nextDouble();

Offset _rollLoc(Size range, num margin) => new Offset(
  margin + (range.width  - 2 * margin) * _rand(),
  margin + (range.height - 2 * margin) * _rand()
);

int _rollc() => 65 + (26 * _rand()).toInt();

String _rollName() => 
  "${new String.fromCharCodes([_rollc(),_rollc(),_rollc()])}-${(1000*_rand()).toInt()}";

void main() {
  final Size range = new Size(1500, 1500);
  final View view = new ScrollView(contentSize: range);
  view.profile.text = "location: center center; width: 80%; height: 80%";
  view.classes.add("star-chart");
  
  final int sysnum = 30 + (10 * _rand()).toInt();
  final num syssize = sqrt(range.width * range.height / sysnum) * 0.3;
  
  // roll for star system locations
  final List<Offset> syslocs = [];
  for (; syslocs.length < sysnum;) {
    Offset loc = _rollLoc(range, syssize);
    // avoid collision (too close) to previously assigned positions
    bool collide = false;
    for (Offset ploc in syslocs) {
      if ((loc - ploc).norm() < syssize * 1.5) {
        collide = true;
        break; // comparison loop
      }
    }
    if (collide)
      continue;
    syslocs.add(loc);
  }
  
  for (int i = 0; i < sysnum; i++)
    view.addChild(_system(syslocs[i], syssize, (10 * _rand() + 5).toInt(), _rollName()));
  
  final View mainView = new View()..addToDocument();
  mainView.addChild(view);
}
