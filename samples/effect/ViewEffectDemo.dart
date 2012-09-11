//Sample Code: SwipeGesture

#import("dart:html");
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/effect/effect.dart');

class ViewEffectDemo extends Activity {
  
  void onCreate_() {
    title = "View Effect Demo";
    mainView.style.background = "#000000";
    
    bool mv1 = false, mv2 = false, mv3 = false;
    
    List<View> vs = blocks("Fade", 50, 50);
    final View w1 = vs[0], v1 = vs[1];
    mainView..addChild(w1)..addChild(v1);
    
    w1.on.click.add((ViewEvent event) {
      if (mv1)
        return;
      mv1 = true;
      v1.style.opacity = "0";
      mainView.addChild(v1);
      new EasingMotion((num x, MotionState state) {
        v1.style.opacity = "$x";
      }, end : (MotionState state) {
        mv1 = false;
      });
    });
    
    v1.on.click.add((ViewEvent event) {
      if (mv1)
        return;
      mv1 = true;
      new EasingMotion((num x, MotionState state) {
        v1.style.opacity = "${1-x}";
      }, end: (MotionState state) {
        v1.removeFromParent();
        mv1 = false;
      });
    });
    
    vs = blocks("Zoom", 200, 50);
    final View w2 = vs[0], v2 = vs[1];
    mainView..addChild(w2)..addChild(v2);
    
    w2.on.click.add((ViewEvent event) {
      if (mv2)
        return;
      mv2 = true;
      v2.style.opacity = "0";
      v2.style.transform = "scale(0)";
      mainView.addChild(v2);
      new EasingMotion((num x, MotionState state) {
        v2.style.opacity = "$x";
        v2.style.transform = "scale($x)";
      }, end : (MotionState state) {
        mv2 = false;
      });
    });
    
    v2.on.click.add((ViewEvent event) {
      if (mv2)
        return;
      mv2 = true;
      new EasingMotion((num x, MotionState state) {
        v2.style.opacity = "${1-x}";
        v2.style.transform = "scale(${1-x})";
      }, end: (MotionState state) {
        v2.removeFromParent();
        mv2 = false;
      });
    });
    
    vs = blocks("Slide", 50, 200);
    final View w3 = vs[0], v3 = vs[1];
    mainView..addChild(w3)..addChild(v3);
    
    w3.on.click.add((ViewEvent event) {
      if (mv3)
        return;
      mv3 = true;
      v3.height = 0;
      mainView.addChild(v3);
      new EasingMotion((num x, MotionState state) {
        //v3.style.opacity = "$x";
        v3.height = (x * 100).toInt();
      }, end : (MotionState state) {
        mv3 = false;
      });
    });
    
    v3.on.click.add((ViewEvent event) {
      if (mv3)
        return;
      mv3 = true;
      new EasingMotion((num x, MotionState state) {
        //v3.style.opacity = "${1-x}";
        v3.height = ((1-x) * 100).toInt();
      }, end: (MotionState state) {
        v3.removeFromParent();
        mv3 = false;
      });
    });
    
    vs = blocks("N/A", 200, 200);
    final View w4 = vs[0], v4 = vs[1];
    mainView..addChild(w4)..addChild(v4);
    
    w4.on.click.add((ViewEvent event) {
      mainView.addChild(v4);
    });
    
    v4.on.click.add((ViewEvent event) {
      v4.removeFromParent();
    });
    
  }
  
  List<TextView> blocks(String text, int left, int top) => 
      [block(text, left, top, true), block(text, left, top)];
  
  TextView block(String text, int left, int top, [bool dashed = false]) {
    TextView tv = new TextView(text);
    tv.width = tv.height = dashed ? 80 : 100;
    tv.left = left + (dashed ? 10 : 0);
    tv.top = top + (dashed ? 10 : 0);
    tv.classes.add(dashed ? "dashed-block" : "block");
    tv.style.lineHeight = dashed ? "76px" : "96px";
    if (dashed)
      tv.style.borderRadius = "40px";
    return tv;
  }
  
}

void main() {
  new ViewEffectDemo().run();
}
