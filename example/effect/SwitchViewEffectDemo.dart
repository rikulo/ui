//Sample Code: SwipeGesture

import 'dart:html';
import 'dart:math';

import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/util.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

typedef void SwitchViewEffect(View vo, View vn, void end());

void replace(View vo, View vn, SwitchViewEffect effect) {
  if (effect == null) {
    final Element p = vo.node.parent;
    vo.removeFromDocument();
    vn.addToDocument(node: p);
    
  } else {
    vn.visible = false;
    vn.addToDocument(node: vo.node.parent);
    vn.requestLayout(true);
    effect(vo, vn, () {
      vo.removeFromDocument();
      vo.visible = true;
    });
    
  }
}

TextView block(String text, int left, int top) {
  TextView tv = new TextView(text)
  ..width = 100..height = 100..left = left..top = top;
  tv.classes.add("block");
  tv.style.lineHeight = "96px";
  return tv;
}

void addFly(View view, Offset range, List<MotionAction> actions) {
  if (view.children.isEmpty())
    actions.add(randFly(view.node, range));
  else
    for (View c in view.children)
      addFly(c, range, actions);
}

MotionAction randFly(Element element, Offset range) {
  final int initX = CSS.intOf(element.style.left);
  final int initY = CSS.intOf(element.style.top);
  final num velX = (rand.nextDouble() * 2 - 1) * range.x;
  final num velY = (rand.nextDouble() * 2 - 1) * range.y;
  return (num x, MotionState state) {
    element.style.left = CSS.px(initX + (velX * x).toInt());
    element.style.top =  CSS.px(initY + (velY * x).toInt());
  };
}

final Random rand = new Random();

void main() {
  document.body.style.margin = "0";
  final View mainView = new View()..addToDocument();
  View v1 = mainView;
  
  v1.style.background = "#000000";
  View container = new View()..width = 250..height = 250;
  container.profile.location = "center center";
  v1.addChild(container);
  
  View w1 = block("Fade", 0, 0);
  container.addChild(w1);
  
  View w2 = block("Slide", 150, 0);
  container.addChild(w2);
  
  View w3 = block("Collapse", 0, 150);
  container.addChild(w3);
  
  View w4 = block("N/A", 150, 150);
  container.addChild(w4);
  
  View v2 = new View();
  v2.style.background = "#FFFFFF";
  
  final int rad = 70;
  TextView bak = new TextView("Back");
  bak.profile.location = "center center";
  bak.width = bak.height = rad * 2;
  bak.classes.add("dashed-block");
  bak.style..lineHeight = CSS.px(rad * 2 - 4)
      ..borderRadius = CSS.px(rad)..fontSize = "17px"
      ..color = "#444444"..borderColor = "#444444";
  v2.addChild(bak);
  
  SwitchViewEffect _eff;
  
  w1.on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (View vo, View vn, void end()) {
      new FadeInEffect(vn.node, start: (MotionState state) {
        vo.node.style.zIndex = "-1";
        vn.visible = true;
      }, end: (MotionState state) => end()).run();
    });
  });
  
  w2.on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (View vo, View vn, void end()) {
      final int width = browser.size.width;
      new EasingMotion((num x, MotionState state) {
        final int l = (width * x).toInt();
        vo.node.style.left = CSS.px(-l);
        vn.node.style.left = CSS.px(width - l);
        
      }, start: (MotionState state) {
        final Element parent = vo.node.parent;
        if (parent != null) {
          state.data = parent.style.overflow;
          parent.style.overflow = "hidden";
        }
        vo.node.style.left = CSS.px(width);
        vn.node.style.left = "0";
        vn.visible = true;
        
      }, end: (MotionState state) {
        final Element parent = vo.node.parent;
        if (parent != null)
          parent.style.overflow = state.data == null ? "" : state.data;
        end();
        
      }, easing: (num t) => t * t).run();
    });
  });
  
  w3.on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (View vo, View vn, void end()) {
      final List<MotionAction> actions = new List<MotionAction>();
      
      final int height = browser.size.height;
      final int width = browser.size.width;
      final Offset range = new Offset(width / 2, height / 2);
      
      final Element vonode = vo.node;
      actions.add((num x, MotionState state) {
        vonode.style.top = CSS.px((height * x * x).toInt()); // free fall
      });
      addFly(vo, range, actions);
      
      new EasingMotion((num x, MotionState state) {
        for (MotionAction ma in actions)
          ma(x, state);
            
      }, start: (MotionState state) {
        vn.node.style.zIndex = "-1";
        vn.visible = true;
        final Element parent = vo.node.parent;
        if (parent != null) {
          state.data = parent.style.overflow;
          parent.style.overflow = "hidden";
        }
        
      }, end: (MotionState state) {
        final Element parent = vo.node.parent;
        if (parent != null)
          parent.style.overflow = state.data == null ? "" : state.data;
        vn.node.style.zIndex = "";
        end();
        
      }).run();
    });
  });
  
  w4.on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = null);
  });
  
  bak.on.click.add((ViewEvent event) {
    replace(v2, v1, _eff);
  });
  
}
