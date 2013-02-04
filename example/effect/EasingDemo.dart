//Sample Code: SwipeGesture

import 'dart:html';
import 'dart:math';

import "package:rikulo_commons/util.dart";

import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

class RadGroup<E> {
  
  final String className;
  final Map<E, View> _map = new Map<E, View>();
  E _item;
  View _view;
  
  RadGroup([String className]) : this.className = className;
  
  void add(E item, View view, void callback()) {
    _map[item] = view;
    if (view != null)
      view.on.click.listen((ViewEvent event) {
        _select(item, view);
        callback();
      });
    if (_item == null)
      _select(item, view);
  }
  
  void _select(E item, View view) {
    if (className != null && _item != item) {
      if (_view != null)
        _view.classes.remove(className);
      if (view != null)
        view.classes.add(className);
    }
    _item = item;
    _view = view;
  }
  
  void set selected(E item) => _select(item, _map[item]);
  
  E get selected => _item;
  
  View get selectedView => _view;
  
}

View rbtn, pbtn, sbtn, tarv, progBar;

void reset() {
  resetBtn();
  tarv.node.style.transform = "";
  tarv.top = 50;
  progBar.width = 0;
}

void resetBtn() {
  rbtn.classes.remove("on");
  pbtn.classes.remove("on");
}

void play() {
  if (_em != null && _em.isRunning)
    return;
  rbtn.classes.add("on");
  pbtn.classes.remove("on");
  if (_em == null || !_em.isPaused)
    _em = new EasingMotion((num x, MotionState state) {
      _rgma.selected(x, state);
      progBar.width = min(300, (state.runningTime * 0.3).toInt());
    }, easing: _rgef.selected, period: 1000, end: (MotionState state) => resetBtn());
  _em.run();
}

void pause() {
  if (_em == null || !_em.isRunning)
    return;
  rbtn.classes.remove("on");
  pbtn.classes.add("on");
  _em.pause();
}

void stop() {
  if (_em != null)
    _em.stop();
  reset();
}

EasingMotion _em = null;
RadGroup<EasingFunction> _rgef = new RadGroup<EasingFunction>("block-seld");
RadGroup<MotionAction> _rgma = new RadGroup<MotionAction>("block-seld");

TextView block(String text, int left, int top) {
  TextView tv = new TextView(text)..width = 50..height = 50;
  tv.left = left;
  tv.top = top;
  tv.classes.add("block");
  tv.style.lineHeight = "46px";
  tv.style.fontSize = "12px";
  return tv;
}

void main() {
  document.body.style.margin = "0";
  
  final View mainView = new View()..addToDocument();
  mainView.style.backgroundColor = "#000000";
  
  View container = new View()..width = 200..height = 200;
  container.profile.location = "center center";
  container.style.padding = "10px";
  mainView.addChild(container);
  
  tarv = new TextView("Rikulo!");
  tarv..width = 100..height = 100..top = 50..left = 50;
  tarv.style.lineHeight = "96px";
  tarv.style.fontSize = "32px";
  tarv.style.textAlign = "center";
  tarv.style.color = "#CCCCCC";
  container.addChild(tarv);
  
  View easingBox = new View()..width = 50;
  easingBox.profile.location = "west center";
  easingBox.profile.height = "100%";
  easingBox.profile.anchorView = container;
  mainView.addChild(easingBox);
  
  View actionBox = new View()..width = 50;
  actionBox.profile.location = "east center";
  actionBox.profile.height = "100%";
  actionBox.profile.anchorView = container;
  mainView.addChild(actionBox);
  
  View stateBar = new View()..height = 50;
  stateBar.profile.location = "south center";
  stateBar.profile.width = "300px";
  stateBar.profile.anchorView = container;
  mainView.addChild(stateBar);
  
  final Element node = tarv.node;
  
  
  
  final View e1 = block("Linear", 0, 0);
  easingBox.addChild(e1);
  _rgef.add((num t) => t, e1, stop);
  
  final View e2 = block("Quad", 0, 60);
  easingBox.addChild(e2);
  _rgef.add((num t) => t * t, e2, stop);
  
  final View e3 = block("Bounce", 0, 120);
  easingBox.addChild(e3);
  _rgef.add((num t) => t < 0.5 ? t * t * 4 : (t - 0.75) * (t - 0.75) * 4 + 0.75, e3, stop);
  
  
  
  final View a1 = block("Move", 0, 0);
  actionBox.addChild(a1);
  _rgma.add((num x, MotionState state) {
    node.style.top = Css.px((50 + x * 50).toInt());
  }, a1, stop);
  
  final View a2 = block("Rotate", 0, 60);
  actionBox.addChild(a2);
  _rgma.add((num x, MotionState state) {
    node.style.transform = "rotate(${x*45}deg)";
  }, a2, stop);
  
  final View a3 = block("Zoom", 0, 120);
  actionBox.addChild(a3);
  _rgma.add((num x, MotionState state) {
    node.style.transform = "scale(${1 + x / 2})";
  }, a3, stop);
  
  
  
  rbtn = new View()..left = 0..top = 16..addChild(new View());
  rbtn.classes..add("round-button")..add("run");
  stateBar.addChild(rbtn);
  rbtn.on.click.listen((ViewEvent event) => play());
  
  pbtn = new View()..left = 35..top = 16..addChild(new View())..addChild(new View());
  pbtn.classes..add("round-button")..add("pause");
  stateBar.addChild(pbtn);
  pbtn.on.click.listen((ViewEvent event) => pause());
  
  sbtn = new View()..left = 70..top = 16..addChild(new View());
  sbtn.classes..add("round-button")..add("stop");
  stateBar.addChild(sbtn);
  sbtn.on.click.listen((ViewEvent event) => stop());
  
  final View progBox = new View()..height = 10..width = 300;
  progBox.style..border = "1px solid #CCCCCC"..borderRadius = "2px"
      ..backgroundColor = "#444444";
  progBar = new View()..height = 8..width = 0..left = -1;
  progBar.style.backgroundColor = "#CCCCCC";
  progBox.addChild(progBar);
  stateBar.addChild(progBox);
  
}
