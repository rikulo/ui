//Sample Code: SwipeGesture

import "dart:html";

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/event.dart';
import 'package:rikulo_ui/effect.dart';

TextView block(String text, int left, int top) {
  TextView tv = new TextView(text)..width = 100..height = 100;
  tv.left = left;
  tv.top = top;
  tv.classes.add("block");
  tv.style.lineHeight = "96px";
  return tv;
}

void main() {
  document.body.style.margin = "0";
  
  final View mainView = new View()..addToDocument();
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
  
  bool removeReady = false;
  EasingMotion removeMotion;
  
  btn.on.click.listen((ViewEvent event) {
    if (removeReady) {
      removeReady = false;
      if (removeMotion == null)
        dialog.remove();
      else
        removeMotion.run();
    }
  });
  
  v1.on.click.listen((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(mode: "dialog");
    final Element mask = dialog.maskNode;
    
    new EasingMotion.join([new FadeInEffect(dialog.node), new FadeInEffect(mask)], 
    end: (MotionState state) {
      removeReady = true;
    }, easing: (num t) => t * t, period: 400).run();
    
    removeMotion = new EasingMotion.join([new FadeOutEffect(dialog.node), new FadeOutEffect(mask)], 
    end: (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    }, easing: (num t) => t * t, period: 400);
  });
  
  v2.on.click.listen((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(mode: "dialog");
    final Element mask = dialog.maskNode;
    
    new EasingMotion.join([new ZoomInEffect(dialog.node), new FadeInEffect(mask)], 
    end: (MotionState state) {
      removeReady = true;
    }, easing: (num t) => t * t, period: 400).run();
    
    removeMotion = new EasingMotion.join([new ZoomOutEffect(dialog.node), new FadeOutEffect(mask)], 
    end: (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    }, easing: (num t) => t * t, period: 400);
  });
  
  v3.on.click.listen((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(mode: "dialog");
    final Element mask = dialog.maskNode;
    
    new EasingMotion.join([new SlideInEffect(dialog.node), new FadeInEffect(mask)], 
    end: (MotionState state) {
      removeReady = true;
    }, easing: (num t) => t * t, period: 400).run();
    
    removeMotion = new EasingMotion.join([new SlideOutEffect(dialog.node), new FadeOutEffect(mask)], 
    end: (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    }, easing: (num t) => t * t, period: 400);
  });
  
  v4.on.click.listen((ViewEvent event) {
    dialog.addToDocument(mode: "dialog");
    removeReady = true;
    removeMotion = null;
  });
  
}
