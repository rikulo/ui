import "dart:html";
import "dart:math";

import "package:rikulo_commons/util.dart";

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/view/impl.dart';
import 'package:rikulo_ui/html.dart';
import 'package:rikulo_ui/event.dart';
import 'package:rikulo_ui/effect.dart';

class ViewDemo {
  
  ViewDemo();
  
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
}

class PanelDemo {
  
  PanelDemo();
  
  TextView btn(String text) => new Button(text)..height = 32..width = 96;

  EasingMotion showWithMask(EasingMotion motion, Element mask, MotionEnd end) =>
      new EasingMotion.join([motion, new FadeInEffect(mask)], 
          easing: (num t) => t * t, period: 300, end: end);

  EasingMotion hideWithMask(EasingMotion motion, Element mask, MotionEnd end) =>
      new EasingMotion.join([motion, new FadeOutEffect(mask)], 
          easing: (num t) => t * t, period: 300, end: end);

  void main() {
    final Element body = query("#v-main-panel");
    
    final View mainView = new View()..addToDocument(ref: body);
    mainView.addChild(new Style(content: ".v-mask {background: rgba(127,127,127,0.25);}"));
    View container = new View();
    container.layout..type = "linear"..orient = "vertical"..gap = "#8";
    container.profile.text = "width: content; height: content; location: center center";
    mainView.addChild(container);
    
    Panel dialog;
    bool removeReady = false;
    EasingMotion removeMotion;
    Function _remove = () {
      if (removeReady) {
        removeReady = false;
        if (removeMotion == null)
          dialog.remove();
        else
          removeMotion.run();
      }
    };
    
    dialog = new Panel()..addButton("close", (Event event) => _remove())
        ..profile.text = "width: 50%; height: 50%; location: center center";
    dialog.addChild(new TextView("Is this OK?")
    ..profile.location = "center center"..style.fontSize = "14px");
    dialog.addChild(btn("OK")
        ..profile.location = browser.mobile ? "bottom center" : "bottom right"
          ..on.click.listen((ViewEvent event) => _remove()));
    
    container.addChild(btn("Fade")..on.click.listen((ViewEvent event) {
      dialog.style.visibility = "hidden";
      dialog.addToDocument(ref: body, mode: "dialog");
      final Element mask = dialog.maskNode;
      
      showWithMask(new FadeInEffect(dialog.node), mask, (MotionState state) {
        removeReady = true;
      }).run();
      
      removeMotion = hideWithMask(new FadeOutEffect(dialog.node), mask, (MotionState state) {
        dialog.remove();
        dialog.style.visibility = "";
      });
    }));
    
    container.addChild(btn("Zoom")..on.click.listen((ViewEvent event) {
      dialog.style.visibility = "hidden";
      dialog.addToDocument(ref: body, mode: "dialog");
      final Element mask = dialog.maskNode;
      
      showWithMask(new ZoomInEffect(dialog.node), mask, (MotionState state) {
        removeReady = true;
      }).run();
      
      removeMotion = hideWithMask(new ZoomOutEffect(dialog.node), mask, (MotionState state) {
        dialog.remove();
        dialog.style.visibility = "";
      });
    }));
    
    container.addChild(btn("Slide")..on.click.listen((ViewEvent event) {
      dialog.style.visibility = "hidden";
      dialog.addToDocument(ref: body, mode: "dialog");
      dialog.requestLayout(true); // as slide effect depends on initial size
      final Element mask = dialog.maskNode;
      
      showWithMask(new SlideInEffect(dialog.node), mask, (MotionState state) {
        removeReady = true;
      }).run();
      
      removeMotion = hideWithMask(new SlideOutEffect(dialog.node), mask, (MotionState state) {
        dialog.remove();
        dialog.style.visibility = "";
      });
    }));
    
    container.addChild(btn("N/A")..on.click.listen((ViewEvent event) {
      dialog.addToDocument(ref: body, mode: "dialog");
      removeReady = true;
      removeMotion = null;
    }));
    
  }
  
}

typedef void SwitchViewEffect(Element n1, Element n2, void end());

class SwitchViewDemo {
  
  SwitchViewDemo();
  
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
    
    bak.on.click.listen((ViewEvent event) {
      replace(v2, v1, _eff);
    });
    
    container.addChild(btn("Fade")
        ..profile.location = "top left"
        ..on.click.listen((ViewEvent event) {
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
        ..on.click.listen((ViewEvent event) {
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
        ..on.click.listen((ViewEvent event) {
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
        ..on.click.listen((ViewEvent event) => replace(v1, v2, _eff = null)));
    
  }

}

void main() {
  
  new ViewDemo().main();
  new PanelDemo().main();
  new SwitchViewDemo().main();
  
}
