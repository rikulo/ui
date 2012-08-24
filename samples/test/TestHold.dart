//Sample Code: Test Log

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/util/util.dart');

class TestHold extends Activity {
  
  void onCreate_() {
    
    block(1000, 3, 50);
    block(1000, 100, 150);
    block(5000, 3, 250);
    block(100, 3, 350);
    
  }
  
  TextView block(int duration, num limit, int top) {
    TextView v = new TextView("${duration/1000}s / ${limit}px");
    v.left = 50;
    v.top = top;
    v.height = 50;
    v.style.border = "2px solid #AAAAAA";
    v.style.borderRadius = "5px";
    v.style.lineHeight = "46px";
    v.style.backgroundColor = "#FFCCCC";
    
    mainView.addChild(v);
    bool c = false;
    
    new HoldGesture(v.node, (HoldGestureState State) {
      v.style.backgroundColor = c ? "#FFCCCC" : "#CCCCFF";
      c = !c;
      
    }, start: (HoldGestureState) {
      
      
    }, duration: duration, movementLimit: limit);
    
    return v;
  }
  
}

void main() {
  new TestHold().run();
}
