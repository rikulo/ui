//Sample Code: Test Animation 3

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/effect/effect.dart');

String createColor(num x) {
  return CSS.color((92 * x).toInt(), (115 * x).toInt(), (229 * x).toInt());
}

View createCube(int size, String txt) {
  View v = new View();
  v.width = size;
  v.height = size;
  v.style.border = "2px solid #3D4C99";
  v.style.borderRadius = "10px";
  v.style.backgroundColor = createColor(1);
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

class TestAnimation3 extends Activity {
  
  View cube;
  
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
    final Element element = cube.node;
    final num deceleration = 0.0005;
    num colorValue = 1;
    
    Motion inertialMotion;
    EasingMotion recoveryMotion;
    DragGesture dg = new DragGesture(element, range: () => range, 
    start: (DragGestureState dstate) {
      if (inertialMotion != null)
        inertialMotion.stop();
      if (recoveryMotion != null)
        recoveryMotion.stop();
      return element;
    }, end: (DragGestureState dstate) {
      final Offset vel = dstate.velocity;
      num speed = VectorUtil.norm(vel);
      if (speed == 0)
        return;
      Offset unitv = vel / speed;
      Offset pos = new DOMQuery(element).offset;
      inertialMotion = new Motion(moving: (MotionState mstate) {
        int elapsed = mstate.elapsedTime;
        pos += unitv * speed * elapsed;
        if (pos.x < range.left || pos.x > range.right) {
          unitv.x *= -1;
          speed *= 0.8;
          colorValue *= 0.8;
          element.style.backgroundColor = createColor(colorValue);
        }
        if (pos.y < range.top || pos.y > range.bottom) {
          unitv.y *= -1;
          speed *= 0.8;
          colorValue *= 0.8;
          element.style.backgroundColor = createColor(colorValue);
        }
        pos = range.snap(pos);
        element.style.left = CSS.px(pos.left.toInt());
        element.style.top = CSS.px(pos.top.toInt());
        speed = Math.max(0, speed - deceleration * elapsed);
        return speed > 0;
      }, end: (MotionState mstate) {
        final num initColorValue = colorValue, diffColorValue = 1 - initColorValue;
        recoveryMotion = new EasingMotion((num x) {
          colorValue = diffColorValue * x + initColorValue;
          element.style.backgroundColor = createColor(colorValue);
        });
      });
      return true;
    });
  }
}

void main() {
  new TestAnimation3().run();
}
