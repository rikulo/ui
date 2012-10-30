//Sample Code: SwipeGesture

import 'dart:html';
import 'dart:math';

import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/util.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

typedef void SwitchViewEffect(Element n1, Element n2, void end());

void replace(View vo, View vn, SwitchViewEffect effect) {
  if (effect == null) {
    final Element p = vo.node.parent;
    vo.remove();
    vn.addToDocument(ref: p);
    
  } else {
    vn.style.visibility = "hidden";
    vn.addToDocument(ref: vo.node.parent);
    vn.requestLayout(true);
    effect(vo.node, vn.node, () {
      vo.remove();
      vn.style.visibility = vo.style.visibility = "";
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

void addFly(Element element, Offset range, List<MotionAction> actions) {
  if (element.$dom_children.isEmpty)
    actions.add(randFly(element, range));
  else
    for (Element c in element.$dom_children)
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
    replace(v1, v2, _eff = (Element n1, Element n2, void end()) {
      new FadeInEffect(n2, start: (MotionState state) {
        n1.style.zIndex = "-1";
      }, end: (MotionState state) => end()).run();
    });
  });
  
  w2.on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (Element n1, Element n2, void end()) {
      final int width = browser.size.width;
      new EasingMotion((num x, MotionState state) {
        final int l = (width * x).toInt();
        n1.style.left = CSS.px(-l);
        n2.style.left = CSS.px(width - l);
        
      }, start: (MotionState state) {
        final Element parent = n1.parent;
        if (parent != null) {
          state.data = parent.style.overflow;
          parent.style.overflow = "hidden";
        }
        n1.style.left = CSS.px(width);
        n2.style.left = "0";
        n2.style.visibility = "";
        
      }, end: (MotionState state) {
        final Element parent = n1.parent;
        if (parent != null)
          parent.style.overflow = state.data == null ? "" : state.data;
        end();
        
      }, easing: (num t) => t * t).run();
    });
  });
  
  w3.on.click.add((ViewEvent event) {
    replace(v1, v2, _eff = (Element n1, Element n2, void end()) {
      final List<MotionAction> actions = new List<MotionAction>();
      
      final int height = browser.size.height;
      final int width = browser.size.width;
      final Offset range = new Offset(width / 2, height / 2);
      
      final Element vonode = n1;
      actions.add((num x, MotionState state) {
        vonode.style.top = CSS.px((height * x * x).toInt()); // free fall
      });
      addFly(n1, range, actions);
      
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
