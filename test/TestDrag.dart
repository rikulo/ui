//Sample Code: Test Log

import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/gesture.dart';
import 'package:rikulo_commons/util.dart';

Rectangle range;

View _createSimpleDrag(View parent, bool transform, [num threshold = -1]) {
  String label = "Simple";
  if (transform)
    label = "$label (T)";
  if (threshold > -1)
    label = "$label ($threshold)";
  View view = _createDragView(parent, label);
  new Dragger(view.node, transform: transform, threshold: threshold);
  return view;
}
View _createBoxedDrag(View parent) {
  View box = new View();
  box.classes.add("drag");
  box.profile.text = "location: center center; width: 70%; height: 70%";
  parent.addChild(box);
  View view = _createDragView(box, "Boxed");
  
  new Dragger(view.node, snap: (Offset ppos, Offset pos) => range.snap(pos));
  
  view.on.layout.listen((event) {
    final Size vs = new DomAgent(view.node).size;
    final Size bs = new DomAgent(box.node).innerSize;
    range = new Rectangle(0, 0, bs.width - vs.width, bs.height - vs.height);
    final Offset vpos = range.snap(new DomAgent(view.node).offset);
    view.left = vpos.left;
    view.top = vpos.top;
  });
  
  return box;
}
TextView _createDragView(View parent, String label) {
  TextView view = new TextView(label);
  view.classes.add("drag");
  view.left = view.top = 20;
  parent.addChild(view);
  return view;
}

void main() {
  final View mainView = new View()..addToDocument();
  
  View d;
  _createBoxedDrag(mainView);
  d = _createSimpleDrag(mainView, false);
  d.left = d.top = 20;
  d = _createSimpleDrag(mainView, true);
  d.left = 170;
  d.top = 20;
  d = _createSimpleDrag(mainView, false, 100);
  d.left = 320;
  d.top = 20;
  mainView.addChild(d = new View());
  d.classes.add("drag");
  d.width = 100;
  d.height = 50;
  TextBox t = new TextBox("Input");
  t.profile.text = "location: top left; width: 50%; height: 100%";
  d.addChild(t);
  d.left = 470;
  d.top = 20;
  new Dragger(d.node);
}
