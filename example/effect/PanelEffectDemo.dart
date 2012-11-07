import "dart:html";

import 'package:rikulo/view.dart';
import 'package:rikulo/view/impl.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/util.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

TextView btn(String text) => new Button(text)..height = 32..width = 96;

void main() {
  document.body.style.margin = "0";
  
  final View mainView = new View()..addToDocument();
  View container = new View();
  container.layout..type = "linear"..orient = "vertical"..gap = "#8";
  container.profile.text = "width: content; height: content; location: center center";
  mainView.addChild(container);
  
  final Button v1 = btn("Fade");
  container.addChild(v1);
  
  final Button v2 = btn("Zoom");
  container.addChild(v2);
  
  final Button v3 = btn("Slide");
  container.addChild(v3);
  
  final Button v4 = btn("N/A");
  container.addChild(v4);
  
  Panel dialog;
  bool removeReady = false;
  EasingMotion removeMotion;
  Function _remove = () {
    if (removeReady) {
      removeReady = false;
      if (removeMotion == null)
        dialog.remove();
      else
        removeMotion.run();
    }
  };
  
  dialog = new Panel()..addButton("close", (Event event) => _remove());
  dialog.profile.text = "width: 50%; height: 50%; location: center center";
  dialog.addChild(new TextView("Is this OK?")..profile.location = "center center"..style.fontSize = "14px");
  Button okbtn = btn("OK")..profile.location = browser.mobile ? "bottom center" : "bottom right";
  okbtn.on.click.add((ViewEvent event) => _remove());
  dialog.addChild(okbtn);
  
  v1.on.click.add((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(mode: "dialog");
    final Element mask = dialog.maskNode;
    
    new FadeInEffect(dialog.node,  
    end: (MotionState state) {
      removeReady = true;
    }, easing: (num t) => t * t, period: 300).run();
    
    removeMotion = new FadeOutEffect(dialog.node, 
    end: (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    }, easing: (num t) => t * t, period: 300);
  });
  
  v2.on.click.add((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(mode: "dialog");
    final Element mask = dialog.maskNode;
    
    new ZoomInEffect(dialog.node, 
    end: (MotionState state) {
      removeReady = true;
    }, easing: (num t) => t * t, period: 300).run();
    
    removeMotion = new ZoomOutEffect(dialog.node, 
    end: (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    }, easing: (num t) => t * t, period: 300);
  });
  
  v3.on.click.add((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(mode: "dialog");
    dialog.requestLayout(true);
    final Element mask = dialog.maskNode;
    
    new SlideInEffect(dialog.node,
    end: (MotionState state) {
      removeReady = true;
    }, easing: (num t) => t * t, period: 300).run();
    
    removeMotion = new SlideOutEffect(dialog.node,
    end: (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    }, easing: (num t) => t * t, period: 300);
  });
  
  v4.on.click.add((ViewEvent event) {
    dialog.addToDocument(mode: "dialog");
    removeReady = true;
    removeMotion = null;
  });
  
}
