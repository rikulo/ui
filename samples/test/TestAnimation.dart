//Sample Code: Test Animation

#import('dart:html');
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');
#import('../../client/html/html.dart');
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

class TestAnimation extends Activity {
  
  View cube;
  Motion motion;
  
  void onCreate_() {
    cube = createCube(100, "Catch Me");
    cube.left = 300;
    cube.top = 100;
    
    /*
    int pauseStart = 0;
    int offset = 0;
    bool paused = false;
    */
    
    cube.on.mouseDown.add((ViewEvent event) {
      motion.pause();
      /*
      pauseStart = new Date.now().millisecondsSinceEpoch;
      paused = true;
      */
    });
    
    mainView.on.mouseUp.add((ViewEvent event) {
      motion.run();
      /*
      if (paused) {
        offset += new Date.now().millisecondsSinceEpoch - pauseStart;
        paused = false;
      }
      */
    });
    
    mainView.addChild(cube);
    
    /*
    Animator animator = new Animator();
    animator.add((int time, int elapsed) {
      if (!paused) {
        cube.left = 300 + (150 * cos((time - offset) / 200)).toInt();
        cube.top = 100 + (50 * sin((time - offset) / 100)).toInt();
      }
      return true;
    });
    */
    
    motion = new EasingMotion((num x, MotionState state) {
      cube.left = 300 + (150 * cos(x * 2 * PI)).toInt();
      cube.top = 100 + (50 * sin(x * 4 * PI)).toInt();
    }, period: (400 * PI).toInt(), repeat: -1);
    
  }
  
}

void main() {
  new TestAnimation().run();
}
