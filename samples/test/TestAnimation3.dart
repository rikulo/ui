//Sample Code: Test Animation 3

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
  
  num updateSpeed(int time, int elapsed, int paused) {
    num nspeed = speed - deceleration * elapsed;
    return range.contains(position) ? nspeed : nspeed / 2;
  }
  
}

class TestAnimation3 extends Activity {
  
  View cube;
  InertialMotion inertialMotion;
  EasingMotion bounceMotion;
  
  void onCreate_() {
    View box = new Section();
    box.width = 500;
    box.height = 500;
    box.left = 48;
    box.top = 48;
    box.style.border = "2px dashed #CCCCCC";
    mainView.addChild(box);
    
    cube = createCube(100, "Drag Me");
    cube.left = 250;
    cube.top = 250;
    
    mainView.addChild(cube);
    
  }
  
  void onMount_() {
    
    final Rectangle range = new Rectangle(50, 50, 446, 446);
    final Element node = cube.node;
    
    DragGesture dg = new DragGesture(node, start: (DragGestureState state) {
      if (inertialMotion != null)
        inertialMotion.stop();
      if (bounceMotion != null)
        bounceMotion.stop();
      return node;
    }, end: (DragGestureState state) {
      final Offset voff = new DOMQuery(node).documentOffset;
      if (range.contains(voff)) {
        inertialMotion = new BoundedInertialMotion(node, state.velocity, range, 
          end: (int time, int elapsed, int paused) {
            Offset pos = new DOMQuery(node).documentOffset;
            if (!range.contains(pos))
              bounceMotion = new EasingMotion(new LinearMotionActionControl(node, pos, range.snap(pos)).action);
        });
      } else {
        bounceMotion = new EasingMotion(new LinearMotionActionControl(node, voff, range.snap(voff)).action);
      }
      return true;
    });
  }
}

void main() {
  new TestAnimation3().run();
}
