//Sample Code: Test Animation 3

#import('dart:html');
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/effect/effect.dart');

String createColor(num x) {
  return CSS.color((92 * x).toInt(), (115 * x).toInt(), (229 * x).toInt());
}

List<View> createCube(int size) {
  View v = new View();
  v.width = size;
  v.height = size;
  v.style.border = "2px solid #3D4C99";
  v.style.borderRadius = "10px";
  v.style.backgroundColor = createColor(1);
  v.style.userSelect = "none";
  v.style.zIndex = "10";
  
  int s = ((size - 4) / 8).toInt();
  View brow1 = new View();
  View brow2 = new View();
  brow1.width = brow2.width = s * 2;
  brow1.height = brow2.height = 0;
  brow1.top  = brow2.top = (2.5 * s).toInt();
  brow1.left = s;
  brow2.left = s * 5;
  brow1.style.borderBottom = brow2.style.borderBottom = "2px solid #FFFFFF";
  
  v.addChild(brow1);
  v.addChild(brow2);
  
  View eye1 = new View();
  View eye2 = new View();
  eye1.width = eye2.width = eye1.height = eye2.height = 0;
  eye1.top = eye2.top = 4 * s;
  eye1.left = 2 * s - 4;
  eye2.left = 6 * s - 4;
  eye1.style.border = eye2.style.border = "4px solid #FFFFFF";
  eye1.style.borderRadius = eye2.style.borderRadius = "4px";
  
  v.addChild(eye1);
  v.addChild(eye2);
  
  View mouth = new View();
  mouth.width = mouth.height = 0;
  mouth.style.borderTop    = "10px solid transparent";
  mouth.style.borderBottom = "10px solid #FFFFFF";
  mouth.style.borderLeft = mouth.style.borderRight = "6px solid transparent";
  mouth.left = 4 * s - 6;
  mouth.top = 5 * s;
  v.addChild(mouth);
  
  return [v, brow1, brow2];
}

class TestAnimation3 extends Activity {
  
  View cube, brow1, brow2;
  num sanity = 1;
  
  void setSanity(num x) {
    sanity = x;
    cube.node.style.backgroundColor = createColor(sanity);
    brow1.style.transform = "rotate(${((1 - x) * 30).toInt()}deg)";
    brow2.style.transform = "rotate(${((x - 1) * 30).toInt()}deg)";
  }
  
  void onCreate_() {
    View box = new Section();
    box.width = 500;
    box.height = 500;
    box.left = 48;
    box.top = 48;
    box.style.border = "2px dashed #CCCCCC";
    mainView.addChild(box);
    
    List<View> views = createCube(100);
    cube = views[0];
    cube.left = 250;
    cube.top = 250;
    
    brow1 = views[1];
    brow2 = views[2];
    
    mainView.addChild(cube);
    
    final Rectangle range = new Rectangle(50, 50, 446, 446);
    final Element element = cube.node;
    final num deceleration = 0.0005;
    
    Motion inertialMotion;
    EasingMotion recoveryMotion;
    new Dragger(element, snap: (Offset ppos, Offset pos) => range.snap(pos), 
    start: (DraggerState dstate) {
      if (inertialMotion != null)
        inertialMotion.stop();
      if (recoveryMotion != null)
        recoveryMotion.stop();
      
    }, end: (DraggerState dstate) {
      final Offset vel = dstate.elementVelocity;
      num speed = vel.norm();
      if (speed == 0) {
        final num initSanity = sanity, diffSanity = 1 - initSanity;
        recoveryMotion = new EasingMotion((num x, MotionState state) {
          setSanity(diffSanity * x + initSanity);
        }, easing: (num x) => x * x);
        return;
      }
      Offset unitv = vel / speed;
      Offset pos = new DOMQuery(element).offset;
      inertialMotion = new Motion(move: (MotionState mstate) {
        int elapsed = mstate.elapsedTime;
        pos += unitv * speed * elapsed;
        if (pos.x < range.left || pos.x > range.right) {
          unitv = new Offset(-unitv.x, unitv.y);
          speed *= 0.8;
          setSanity(sanity * 0.8);
        }
        if (pos.y < range.top || pos.y > range.bottom) {
          unitv = new Offset(unitv.x, -unitv.y);
          speed *= 0.8;
          setSanity(sanity * 0.8);
        }
        pos = range.snap(pos);
        element.style.left = CSS.px(pos.left.toInt());
        element.style.top = CSS.px(pos.top.toInt());
        speed = max(0, speed - deceleration * elapsed);
        return speed > 0;
      }, end: (MotionState mstate) {
        final num initSanity = sanity, diffSanity = 1 - initSanity;
        recoveryMotion = new EasingMotion((num x, MotionState state) {
          setSanity(diffSanity * x + initSanity);
        }, easing: (num x) => x * x);
      });
    });
  }
}

void main() {
  new TestAnimation3().run();
}
