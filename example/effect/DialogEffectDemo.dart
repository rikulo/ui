//Sample Code: SwipeGesture

#import("dart:html");
#import("dart:math");

#import('../../lib/app.dart');
#import('../../lib/view.dart');
#import('../../lib/html.dart');
#import('../../lib/util.dart');
#import('../../lib/event.dart');
#import('../../lib/effect.dart');

class DialogEffectDemo extends Activity {
  
  void onCreate_() {
    title = "View Effect Demo";
    mainView.style.background = "#000000";
    View container = new View()..width = 250..height = 250;
    container.profile.location = "center center";
    mainView.addChild(container);
    
    final View v1 = block("Fade", 0, 0);
    container.addChild(v1);
    
    final View v2 = block("Zoom", 150, 0);
    container.addChild(v2);
    
    final View v3 = block("Slide", 0, 150);
    container.addChild(v3);
    
    final View v4 = block("N/A", 150, 150);
    container.addChild(v4);
    
    final View dialog = new View();
    dialog.profile.text = "width: 50%; height: 50%; location: center center";
    dialog.classes.add("dialog-box");
    View btn = block("OK", 0, 0);
    btn.profile.location = "center center";
    btn.classes.add("dialog-button");
    btn.style.borderRadius = "50px";
    dialog.addChild(btn);
    
    btn.on.click.add((ViewEvent event) {
      removeDialog(dialog, _eff);
    });
    
    v1.on.click.add((ViewEvent event) {
      addDialog(dialog, effect: (View d, Element m, void end()) {
        new FadeInEffect(d.node, end: (MotionState state) => end());
      });
      _eff = (View d, Element m, void end()) {
        new FadeOutEffect(d.node, end: (MotionState state) => end());
      };
    });
    
    v2.on.click.add((ViewEvent event) {
      addDialog(dialog, effect: (View d, Element m, void end()) {
        new ZoomInEffect(d.node, end: (MotionState state) => end());
      });
      _eff = (View d, Element m, void end()) {
        new ZoomOutEffect(d.node, end: (MotionState state) => end());
      };
    });
    
    v3.on.click.add((ViewEvent event) {
      addDialog(dialog, effect: (View d, Element m, void end()) {
        new SlideInEffect(d.node, end: (MotionState state) => end());
      });
      _eff = (View d, Element m, void end()) {
        new SlideOutEffect(d.node, end: (MotionState state) => end());
      };
    });
    
    v4.on.click.add((ViewEvent event) {
      addDialog(dialog);
      _eff = null;
    });
    
  }
  
  DialogEffect _eff = null;
  
  TextView block(String text, int left, int top) {
    TextView tv = new TextView(text)..width = 100..height = 100;
    tv.left = left;
    tv.top = top;
    tv.classes.add("block");
    tv.style.lineHeight = "96px";
    return tv;
  }
  
}

void main() {
  new DialogEffectDemo().run();
}
