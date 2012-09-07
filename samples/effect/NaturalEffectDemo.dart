//Sample Code: SwipeGesture

#import("dart:html");
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/effect/effect.dart');

class NaturalEffectDemo extends Activity {
  
  void onCreate_() {
    title = "Effect Demo";
    mainView.style.background = "#000000";
    
    View v;
    mainView.addChild(v = block("Breathe", 50, 50));
    
    final num n = 0.35;
    final Element element = v.node;
    new EasingMotion((num x, MotionState state) {
      element.style.boxShadow = "0 0 10px 2px rgba(255, 255, 255, $x)";
      element.style.transform = "scale(${1 + x / 10})";
      
    }, period: 5000, repeat: -1, 
    easing: (num t) => (1 - cos(t < n ? t * PI / n : (1 - t) * PI / (1 - n))) / 2);
    
  }
  
  TextView block(String text, int left, int top) {
    TextView tv = new TextView(text);
    tv.width = tv.height = 100;
    tv.left = left;
    tv.top = top;
    tv.classes.add("block");
    tv.style.lineHeight = "96px";
    return tv;
  }
  
}

void main() {
  new NaturalEffectDemo().run();
}
