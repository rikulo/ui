//Sample Code: Circles implemented in Canvas

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/html/html.dart');
#import('../../client/view/view.dart');
#import('../../client/effect/effect.dart');


CanvasRenderingContext2D ctx2d;
Canvas canvas;

class SnakeCanvas extends Activity {
  final int UPDATE = 1000;
  int lastCycle = 0;
  
  void onCreate_() {
    title = "Circles";

    canvas = new Canvas();
    canvas.profile.text = "anchor: parent; width: flex; height: flex";
    rootView.addChild(canvas);
  }
  void onEnterDocument_() {
    ctx2d = canvas.context2D;
    new Animator().add((int time, int elapsed) {
      int timeSinceCycle = time - lastCycle;
      
      if(timeSinceCycle > UPDATE) {
        
        print('Cycle time: ' + timeSinceCycle);
        
        lastCycle = time;
      }
      
      return true;
    });
  }
}

void main() {
  new SnakeCanvas().run();
}
