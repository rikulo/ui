//Sample Code: SwipeGesture

#import("dart:html");
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/effect/effect.dart');

class MainViewEffectDemo extends Activity {
  
  ViewSwitchEffect _efac;
  
  void onCreate_() {
    title = "Main View Switch Effect Demo";
    
    View v1 = mainView;
    
    v1.style.background = "#000000";
    View container = new View()..width = 250..height = 250;
    container.profile.location = "center center";
    v1.addChild(container);
    
    View w1 = block("Fade", 0, 0);
    container.addChild(w1);
    
    View w2 = block("Shift", 150, 0);
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
    
    w1.on.click.add((ViewEvent event) {
      v2.visible = false;
      _efac = (View vo, View vn, void end()) {
        new FadeInEffect(vn.node, start: (MotionState state) {
          vo.node.style.zIndex = "-1";
          vn.visible = true;
        }, end: (MotionState state) => end());
      };
      setMainView(v2, _efac);
    });
    
    w2.on.click.add((ViewEvent event) {
      v2.visible = false;
      _efac = (View vo, View vn, void end()) {
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
          
        }, easing: (num t) => t * t);
      };
      setMainView(v2, _efac);
    });
    
    w3.on.click.add((ViewEvent event) {
      v2.visible = false;
      _efac = (View vo, View vn, void end()) {
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
          
        });
      };
      setMainView(v2, _efac);
    });
    
    w4.on.click.add((ViewEvent event) {
      _efac = null;
      setMainView(v2);
    });
    
    bak.on.click.add((ViewEvent event) {
      if (_efac != null)
        v1.visible = false;
      setMainView(v1, _efac);
    });
    
  }
  
  TextView block(String text, int left, int top) {
    TextView tv = new TextView(text)
        ..width = 100..height = 100..left = left..top = top;
    tv.classes.add("block");
    tv.style.lineHeight = "96px";
    return tv;
  }
  
  ViewEventListener listener(View v, [ViewSwitchEffect efac]) => (ViewEvent event) {
    if (efac != null)
      _efac = efac;
    setMainView(v, _efac);
  };
  
  static void addFly(View view, Offset range, List<MotionAction> actions) {
    if (view.children.isEmpty())
      actions.add(randFly(view.node, range));
    else
      for (View c in view.children)
        addFly(c, range, actions);
  }
  
  static MotionAction randFly(Element element, Offset range) {
    final int initX = CSS.intOf(element.style.left);
    final int initY = CSS.intOf(element.style.top);
    final num velX = (rand().nextDouble() * 2 - 1) * range.x;
    final num velY = (rand().nextDouble() * 2 - 1) * range.y;
    return (num x, MotionState state) {
      element.style.left = CSS.px(initX + (velX * x).toInt());
      element.style.top =  CSS.px(initY + (velY * x).toInt());
    };
  }
  
  static Random _rand;
  static Random rand() => _rand == null ? (_rand = new Random()) : _rand;
  
}

void main() {
  new MainViewEffectDemo().run();
}
