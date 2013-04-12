import 'dart:html';
import 'dart:math';

import "package:rikulo_commons/util.dart";

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/event.dart';
import 'package:rikulo_ui/effect.dart';

Button btn(String text) => 
    new Button(text)..width = 96..height = 96..style.zIndex = "10";

TextView circle(String text, View anchor) => 
    new TextView(text)..width = 80..height = 80
        ..profile.anchorView = anchor..profile.location = "center center"
        ..classes.add("dashed-block")
        ..style.lineHeight = "78px"..style.borderRadius = "40px"..style.fontSize = "12px"
        ..style.color = "#666"..style.borderColor = "#666";

// slide direction
SlideDirection _dir = SlideDirection.NORTH;
List<SlideDirection> _dirs = [SlideDirection.NORTH, SlideDirection.SOUTH, 
                              SlideDirection.WEST, SlideDirection.EAST];
List<View> _dirviews = new List<View>(4);

void select(SlideDirection dir) {
  if (_dir == dir)
    return;
  _dir = dir;
  for (int j = 0; j < 4; j++)
    updateStyle(_dirviews[j], _dirs[j]);
}

void updateStyle(View v, SlideDirection dir) {
  if (dir == _dir)
    v.classes.add("checked");
  else
    v.classes.remove("checked");
}

View radio(SlideDirection dir) {
  View v = new View()..width = 16..height = 16
      ..profile.location = "center center"
      ..style.boxSizing = "border-box"
      ..style.border = "1px solid #888"
      ..style.borderRadius = "2px"
      ..on.click.listen((ViewEvent event) => select(dir));
  View c = new View()..width = 24..height = 24
      ..profile.location = "center center"
      ..style.boxSizing = "border-box";
  
  v.addChild(c);
  updateStyle(_dirviews[_dirs.indexOf(dir)] = v, dir);
  
  return new View()..width = 40..height = 40..addChild(v);
}

void main() {
  final Element body = query("#v-main-view");
  
  final View mainView = new View()..addToDocument(ref: body);
  View container = new View()..width = 240..height = 240;
  container.profile.location = "center center";
  mainView.addChild(container);
  
  bool mv1 = false, mv2 = false, mv3 = false;
  
  final View v1 = btn("Fade")..profile.location = "top left";
  container.addChild(v1..on.click.listen((ViewEvent event) {
    if (mv1)
      return;
    mv1 = true;
    new FadeOutEffect(v1.node, end: (MotionState state) {
      v1.remove();
      mv1 = false;
    }).run();
  }));
  
  container.addChild(circle("Fade", v1)..on.click.listen((ViewEvent event) {
    if (mv1)
      return;
    mv1 = true;
    v1.style.visibility = "hidden";
    container.addChild(v1);
    new FadeInEffect(v1.node, end: (MotionState state) {
      mv1 = false;
    }).run();
  }));
  
  final View v2 = btn("Zoom")..profile.location = "top right";
  container.addChild(v2..on.click.listen((ViewEvent event) {
    if (mv2)
      return;
    mv2 = true;
    new ZoomOutEffect(v2.node, end: (MotionState state) {
      v2.remove();
      mv2 = false;
    }).run();
  }));
  
  container.addChild(circle("Zoom", v2)..on.click.listen((ViewEvent event) {
    if (mv2)
      return;
    mv2 = true;
    v2.style.visibility = "hidden";
    container.addChild(v2);
    new ZoomInEffect(v2.node, end: (MotionState state) {
      mv2 = false;
    }).run();
  }));
  
  final View v3 = btn("Slide")..profile.location = "bottom left";
  container.addChild(v3..on.click.listen((ViewEvent event) {
    if (mv3)
      return;
    mv3 = true;
    new SlideOutEffect(v3.node, direction: _dir, end: (MotionState state) {
      v3.remove();
      mv3 = false;
    }).run();
  }));
  
  container.addChild(circle("Slide", v3)..on.click.listen((ViewEvent event) {
    if (mv3)
      return;
    mv3 = true;
    v3.style.visibility = "hidden";
    container.addChild(v3);
    new SlideInEffect(v3.node, direction: _dir, end: (MotionState state) {
      mv3 = false;
    }).run();
  }));
  
  container.addChild(radio(SlideDirection.NORTH)
      ..profile.anchorView = v3..profile.location = "north center");
  container.addChild(radio(SlideDirection.SOUTH)
      ..profile.anchorView = v3..profile.location = "south center");
  container.addChild(radio(SlideDirection.WEST)
      ..profile.anchorView = v3..profile.location = "west center");
  container.addChild(radio(SlideDirection.EAST)
      ..profile.anchorView = v3..profile.location = "east center");
  
  final View v4 = btn("N/A")..profile.location = "bottom right";
  container.addChild(v4..on.click.listen((ViewEvent event) => v4.remove()));
  
  container.addChild(circle("N/A", v4)..on.click.listen((ViewEvent event) {
    container.addChild(v4);
  }));
  
}
