//Sample Code: SwipeGesture

#import("dart:html");
#import("dart:math");

#import('../../lib/app.dart');
#import('../../lib/view.dart');
#import('../../lib/html.dart');
#import('../../lib/util.dart');
#import('../../lib/event.dart');
#import('../../lib/effect.dart');

class EffectDemo extends Activity {
  
  void onCreate_() {
    title = "Effect Demo";
    mainView.style.background = "#000000";
    
    View v;
    mainView.addChild(v = block("Buzz", 50, 50));
    
    final Motion buzz = new BuzzEffect(v.node, autorun: false);
    v.on.click.add((ViewEvent event) {
      if (!buzz.isRunning())
        buzz.run();
    });
    
    mainView.addChild(v = block("Glow", 200, 50));
    
    final num n = 0.3;
    //final Color c = const HSVColor(210, 50, 100).rgb();
    final Motion glow = new GlowEffect(v.node, tempo: n, autorun: false);
    v.on.click.add((ViewEvent event) {
      if (!glow.isRunning())
        glow.run();
    });
    
    mainView.addChild(v = block("Shake", 50, 200));
    
    final Motion shake = new ShakeEffect(v.node, autorun: false);
    v.on.click.add((ViewEvent event) {
      if (!shake.isRunning())
        shake.run();
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
