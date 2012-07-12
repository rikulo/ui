//Sample Code: Test Animation 2

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/effect/effect.dart');

View createCube(int size, String txt) {
  View v = new View();
  v.width = size;
  v.height = size;
  v.style.border = "2px solid #3D4C99";
  v.style.borderRadius = "10px";
  v.style.backgroundColor = "#5C73E5";
  v.style.userSelect = "none";
  v.style.zIndex = "10";
  
  TextView txtv = new TextView(txt);
  txtv.width = v.width;
  txtv.style.lineHeight = "${v.height}px";
  txtv.style.textAlign = "center";
  txtv.style.color = "#EEEEEE";
  txtv.style.fontFamily = "Arial";
  txtv.style.fontWeight = "bold";
  txtv.style.userSelect = "none";
  v.addChild(txtv);
  
  return v;
}

class BoundedInertialMotion extends InertialMotion {
  
  final Rectangle range;
  
  BoundedInertialMotion(Element element, Offset velocity, this.range, 
    [num deceleration = 0.0005, MotionEnd start, MotionMoving moving, 
    MotionEnd end, bool autorun = true]) :
      super(element, velocity, deceleration, start, moving, end, autorun);
  
  Offset updatePosition(int time, int elapsed, int paused) => 
      range.snap(super.updatePosition(time, elapsed, paused));
  
}

class TestAnimation2 extends Activity {
  
  View v;
  InertialMotion im;
  
  void onCreate_() {
    View box = new Section();
    box.width = 500;
    box.height = 500;
    box.left = 48;
    box.top = 48;
    box.style.border = "2px dashed #CCCCCC";
    mainView.addChild(box);
    
    v = createCube(100, "Drag Me");
    v.left = 250;
    v.top = 250;
    mainView.addChild(v);
    
  }
  
  void onMount_() {
    
    Rectangle range = new Rectangle(50, 50, 446, 446);
    
    DragGesture dg = new DragGesture(v.node, range: () => range, 
        start: (DragGestureState state) {
      if (im != null)
        im.stop();
      return v.node;
    }, end: (DragGestureState state) {
      im = new BoundedInertialMotion(v.node, state.velocity, range);
      return true;
    });
    
  }
}

void main() {
  new TestAnimation2().run();
}
