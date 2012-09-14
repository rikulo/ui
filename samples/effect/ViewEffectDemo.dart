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
    View container = new View()..width = 250..height = 250;
    container.profile.location = "center center";
    mainView.addChild(container);
    
    bool mv1 = false, mv2 = false, mv3 = false;
    
    List<View> vs = blocks("Fade", 0, 0);
    final View w1 = vs[0], v1 = vs[1];
    container..addChild(w1)..addChild(v1);
    
    w1.on.click.add((ViewEvent event) {
      if (mv1)
        return;
      mv1 = true;
      v1.visible = false;
      container.addChild(v1);
      new FadeInEffect(v1.node, end: (MotionState state) {
        mv1 = false;
      });
    });
    
    v1.on.click.add((ViewEvent event) {
      if (mv1)
        return;
      mv1 = true;
      new FadeOutEffect(v1.node, end: (MotionState state) {
        v1.removeFromParent();
        mv1 = false;
      });
    });
    
    vs = blocks("Zoom", 150, 0);
    final View w2 = vs[0], v2 = vs[1];
    container..addChild(w2)..addChild(v2);
    
    w2.on.click.add((ViewEvent event) {
      if (mv2)
        return;
      mv2 = true;
      v2.visible = false;
      container.addChild(v2);
      new ZoomInEffect(v2.node, end: (MotionState state) {
        mv2 = false;
      });
    });
    
    v2.on.click.add((ViewEvent event) {
      if (mv2)
        return;
      mv2 = true;
      new ZoomOutEffect(v2.node, end: (MotionState state) {
        v2.removeFromParent();
        mv2 = false;
      });
    });
    
    vs = blocks("Slide", 0, 150);
    final View w3 = vs[0], v3 = vs[1];
    container..addChild(w3)..addChild(v3);
    
    final View radioN = radio(SlideDirection.NORTH);
    radioN.profile..anchorView = w3..location = "north center";
    final View radioS = radio(SlideDirection.SOUTH);
    radioS.profile..anchorView = w3..location = "south center";
    final View radioW = radio(SlideDirection.WEST);
    radioW.profile..anchorView = w3..location = "west center";
    final View radioE = radio(SlideDirection.EAST);
    radioE.profile..anchorView = w3..location = "east center";
    container..addChild(radioN)..addChild(radioS)..addChild(radioW)..addChild(radioE);
    
    w3.on.click.add((ViewEvent event) {
      if (mv3)
        return;
      mv3 = true;
      v3.visible = false;
      container.addChild(v3);
      new SlideInEffect(v3.node, direction: _dir, end: (MotionState state) {
        mv3 = false;
      });
    });
    
    v3.on.click.add((ViewEvent event) {
      if (mv3)
        return;
      mv3 = true;
      new SlideOutEffect(v3.node, direction: _dir, end: (MotionState state) {
        v3.removeFromParent();
        mv3 = false;
      });
    });
    
    vs = blocks("N/A", 150, 150);
    final View w4 = vs[0], v4 = vs[1];
    container..addChild(w4)..addChild(v4);
    
    w4.on.click.add((ViewEvent event) {
      container.addChild(v4);
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
    bool seld = dir == _dir;
    v.style.borderColor = seld ? "#EEEEEE" : "#888888";
    v.style.boxShadow = seld ? "0 0 10px 0px #EEEEEE" : "none";
  }
  
  View radio(SlideDirection dir) {
    View v = new View();
    v.profile.location = "center center";
    v.width = v.height = 20;
    v.style.border = "10px solid #888888";
    v.style.borderRadius = "10px";
    updateStyle(v, dir);
    
    final int i = _dirs.indexOf(dir);
    _dirviews[i] = v;
    
    v.on.click.add((ViewEvent event) {
      select(dir);
    });
    
    View w = new View()..addChild(v);
    w.width = w.height = 44;
    
    return w;
  }
  
}

void main() {
  new ViewEffectDemo().run();
}
