//Sample Code: SwipeGesture

import "dart:html";
import "dart:math";

import 'package:rikulo/app.dart';
import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/util.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

class DialogEffectDemo extends Activity {
  
  void onCreate_() {
    title = "View Effect Demo";
    mainView.style.backgroundPosition = "center center";
    // photo by dcysurfer / Dave Young @ flickr, under Creative Commons license
    // http://www.flickr.com/photos/dcysurfer/3779922157/
    mainView.style.backgroundImage = "url('http://static.rikulo.org/example/luna.jpg')";
    mainView.style.backgroundColor = "#000000";
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
        new EasingMotion.join([new FadeInEffect(d.node), maskFadeIn(m)], 
            end: (MotionState state) => end(), easing: (num t) => t * t).run();
      });
      _eff = (View d, Element m, void end()) {
        new EasingMotion.join([new FadeOutEffect(d.node), maskFadeOut(m)], 
            end: (MotionState state) => end(), easing: (num t) => t * t).run();
      };
    });
    
    v2.on.click.add((ViewEvent event) {
      addDialog(dialog, effect: (View d, Element m, void end()) {
        new EasingMotion.join([new ZoomInEffect(d.node), maskFadeIn(m)], 
            end: (MotionState state) => end(), easing: (num t) => t * t).run();
      });
      _eff = (View d, Element m, void end()) {
        new EasingMotion.join([new ZoomOutEffect(d.node), maskFadeOut(m)], 
            end: (MotionState state) => end(), easing: (num t) => t * t).run();
      };
    });
    
    v3.on.click.add((ViewEvent event) {
      addDialog(dialog, effect: (View d, Element m, void end()) {
        new EasingMotion.join([new SlideInEffect(d.node), maskFadeIn(m)], 
            end: (MotionState state) => end(), easing: (num t) => t * t).run();
      });
      _eff = (View d, Element m, void end()) {
        new EasingMotion.join([new SlideOutEffect(d.node), maskFadeOut(m)], 
            end: (MotionState state) => end(), easing: (num t) => t * t).run();
      };
    });
    
    v4.on.click.add((ViewEvent event) {
      addDialog(dialog);
      _eff = null;
    });
    
  }
  
  static EasingMotion maskFadeIn(Element m) => 
      new FadeInEffect(m, maxOpacity: 0.6);
  
  static EasingMotion maskFadeOut(Element m) => 
      new FadeOutEffect(m, maxOpacity: 0.6);
  
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
