//Sample Code: SwipeGesture

#import("dart:html");
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/effect/effect.dart');

class EffectDemo extends Activity {
  
  void onCreate_() {
    title = "Effect Demo";
    mainView.style.background = "#000000";
    
    View v;
    mainView.addChild(v = block("Buzz", 50, 50));
    
    final Element buzzNode = v.node;
    bool buzzing = false;
    v.on.click.add((ViewEvent event) {
      if (buzzing)
        return;
      buzzing = true;
      new BuzzEffect(buzzNode, end: (MotionState state) {
        buzzing = false;
      });
    });
    
    mainView.addChild(v = block("Glow", 200, 50));
    
    final num n = 0.3;
    //final Color c = const HSVColor(210, 50, 100).rgb();
    final Element glowNode = v.node;
    bool glowing = false;
    v.on.click.add((ViewEvent event) {
      if (glowing)
        return;
      glowing = true;
      new GlowEffect(glowNode, tempo: n, end: (MotionState state) {
        glowing = false;
      });
    });
    
    mainView.addChild(v = block("Shake", 50, 200));
    
    bool shaking = false;
    final Element shakeNode = v.node;
    v.on.click.add((ViewEvent event) {
      if (shaking)
        return;
      shaking = true;
      new ShakeEffect(shakeNode, end: (MotionState state) {
        shaking = false;
      });
    });
    
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
  new EffectDemo().run();
}
