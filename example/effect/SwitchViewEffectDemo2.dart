//Sample Code: SwipeGesture

import 'dart:html';
import 'dart:math';

import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/util.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

typedef void SwitchViewEffect(Element n1, Element n2, void end());
bool moving = false;

void replace(View vo, View vn, SwitchViewEffect effect) {
  if (moving)
    return;
  moving = true;
  
  if (effect == null) {
    final Element p = vo.node.parent;
    vo.remove();
    vn.addToDocument(ref: p);
    moving = false;
    
  } else {
    vn.style.visibility = "hidden";
    vn.addToDocument(ref: vo.node.parent);
    vn.requestLayout(true);
    effect(vo.node, vn.node, () {
      vo.remove();
      vn.style.visibility = vo.style.visibility = "";
      moving = false;
    });
    
  }
}

Button btn(String text) => new Button(text)..width = 96..height = 96;

void addFly(Element element, Offset range, List<MotionAction> actions, List<Function> ends) {
  if (element.children.isEmpty)
    addRandFly(element, range, actions, ends);
  else
    for (Element c in element.children)
      addFly(c, range, actions, ends);
}

void addRandFly(Element element, Offset range, List<MotionAction> actions, List<Function> ends) {
  final int initX = Css.intOf(element.style.left);
  final int initY = Css.intOf(element.style.top);
  final num velX = (rand.nextDouble() * 2 - 1) * range.x;
  final num velY = (rand.nextDouble() * 2 - 1) * range.y;
  actions.add((num x, MotionState state) {
    element.style.left = Css.px(initX + (velX * x).toInt());
    element.style.top  = Css.px(initY + (velY * x).toInt());
  });
  ends.add(() {
    element.style.left = Css.px(initX);
    element.style.top  = Css.px(initY);
  });
}

final Random rand = new Random();

void main() {
  Element body = query("#v-main-switch");
  if (body == null)
    body = document.body;
  final View v1 = new View()..addToDocument(ref: body);
  v1.style.background = "#333333";
  
  final View container = new View()..width = 240..height = 240;
  container.profile.location = "center center";
  v1.addChild(container);
  
  final View v2 = new View();
  v2.style.background = "#FFFFFF";
  
  final int rad = 72;
  TextView bak = new TextView("Back");
  bak.profile.location = "center center";
  bak.width = bak.height = rad * 2;
  bak.classes.add("dashed-block");
  bak.style..lineHeight = Css.px(rad * 2 - 4)
      ..borderRadius = Css.px(rad)..fontSize = "17px"
      ..color = "#444444"..borderColor = "#444444";
  v2.addChild(bak);
  
  SwitchViewEffect _eff;
  
  bak.on.click.add((ViewEvent event) {
    replace(v2, v1, _eff);
  });
  
  container.addChild(btn("Fade")
      ..profile.location = "top left"
      ..on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (Element n1, Element n2, void end()) {
      final String n1z = n1.style.zIndex;
      new FadeInEffect(n2, start: (MotionState state) {
        n1.style.zIndex = "-1";
        
      }, end: (MotionState state) {
        end();
        n1.style.zIndex = n1z;
        
      }).run();
    });
  }));
  
  container.addChild(btn("Slide")
      ..profile.location = "top right"
      ..on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (Element n1, Element n2, void end()) {
      final int width = new DomAgent(body).width;
      new EasingMotion((num x, MotionState state) {
        final int l = (width * x).toInt();
        n1.style.left = Css.px(-l);
        n2.style.left = Css.px(width - l);
        
      }, start: (MotionState state) {
        final Element parent = n1.parent;
        if (parent != null) {
          state.data = parent.style.overflow;
          parent.style.overflow = "hidden";
        }
        n1.style.left = Css.px(width);
        n2.style.left = "0";
        n2.style.visibility = "";
        
      }, end: (MotionState state) {
        final Element parent = n1.parent;
        if (parent != null)
          parent.style.overflow = state.data == null ? "" : state.data;
        end();
        
      }, easing: (num t) => t * t).run();
    });
  }));
  
  container.addChild(btn("Collapse")
      ..profile.location = "bottom left"
      ..on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (Element n1, Element n2, void end()) {
      final List<MotionAction> actions = new List<MotionAction>();
      final List<Function> ends = new List<Function>();
      
      int h = new DomAgent(body).height;
      final int height = h > 0 ? h : browser.size.height;
      final int width = new DomAgent(body).width;
      final Offset range = new Offset(width / 2, height / 2);
      
      final Element vonode = n1;
      actions.add((num x, MotionState state) {
        vonode.style.top = Css.px((height * x * x).toInt()); // free fall
      });
      addFly(n1, range, actions, ends);
      
      new EasingMotion((num x, MotionState state) {
        for (MotionAction ma in actions)
          ma(x, state);
            
      }, start: (MotionState state) {
        n2.style.zIndex = "-1";
        n2.style.visibility = "";
        final Element parent = n1.parent;
        if (parent != null) {
          state.data = parent.style.overflow;
          parent.style.overflow = "hidden";
        }
        
      }, end: (MotionState state) {
        final Element parent = n1.parent;
        if (parent != null)
          parent.style.overflow = state.data == null ? "" : state.data;
        n2.style.zIndex = "";
        end();
        for (Function f in ends)
          f();
        
      }).run();
    });
  }));
  
  View w4 = btn("N/A")..profile.location = "bottom right";
  container.addChild(btn("N/A")
      ..profile.location = "bottom right"
      ..on.click.add((ViewEvent event) => replace(v1, v2, _eff = null)));
  
}
