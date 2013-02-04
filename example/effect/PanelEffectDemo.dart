import "dart:html";

import "package:rikulo_commons/util.dart";

import 'package:rikulo/view.dart';
import 'package:rikulo/view/impl.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/effect.dart';

TextView btn(String text) => new Button(text)..height = 32..width = 96;

EasingMotion showWithMask(EasingMotion motion, Element mask, MotionEnd end) =>
    new EasingMotion.join([motion, new FadeInEffect(mask)], 
        easing: (num t) => t * t, period: 300, end: end);

EasingMotion hideWithMask(EasingMotion motion, Element mask, MotionEnd end) =>
    new EasingMotion.join([motion, new FadeOutEffect(mask)], 
        easing: (num t) => t * t, period: 300, end: end);

void main() {
  final Element body = query("#v-main-panel");
  
  final View mainView = new View()..addToDocument(ref: body);
  mainView.addChild(new Style(content: ".v-mask {background: rgba(127,127,127,0.25);}"));
  View container = new View();
  container.layout..type = "linear"..orient = "vertical"..gap = "#8";
  container.profile.text = "width: content; height: content; location: center center";
  mainView.addChild(container);
  
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
  
  dialog = new Panel()..addButton("close", (Event event) => _remove())
      ..profile.text = "width: 50%; height: 50%; location: center center";
  dialog.addChild(new TextView("Is this OK?")
      ..profile.location = "center center"..style.fontSize = "14px");
  dialog.addChild(btn("OK")
      ..profile.location = browser.touch ? "bottom center" : "bottom right"
      ..profile.margin = browser.touch ? "0 16 0 -16" : "-16 16 16 -16"
      ..on.click.listen((ViewEvent event) => _remove()));
  
  container.addChild(btn("Fade")..on.click.listen((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(ref: body, mode: "dialog");
    final Element mask = dialog.maskNode;
    
    showWithMask(new FadeInEffect(dialog.node), mask, (MotionState state) {
      removeReady = true;
    }).run();
    
    removeMotion = hideWithMask(new FadeOutEffect(dialog.node), mask, (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    });
  }));
  
  container.addChild(btn("Zoom")..on.click.listen((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(ref: body, mode: "dialog");
    final Element mask = dialog.maskNode;
    
    showWithMask(new ZoomInEffect(dialog.node), mask, (MotionState state) {
      removeReady = true;
    }).run();
    
    removeMotion = hideWithMask(new ZoomOutEffect(dialog.node), mask, (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    });
  }));
  
  container.addChild(btn("Slide")..on.click.listen((ViewEvent event) {
    dialog.style.visibility = "hidden";
    dialog.addToDocument(ref: body, mode: "dialog");
    dialog.requestLayout(true); // as slide effect depends on initial size
    final Element mask = dialog.maskNode;
    
    showWithMask(new SlideInEffect(dialog.node), mask, (MotionState state) {
      removeReady = true;
    }).run();
    
    removeMotion = hideWithMask(new SlideOutEffect(dialog.node), mask, (MotionState state) {
      dialog.remove();
      dialog.style.visibility = "";
    });
  }));
  
  container.addChild(btn("N/A")..on.click.listen((ViewEvent event) {
    dialog.addToDocument(ref: body, mode: "dialog");
    removeReady = true;
    removeMotion = null;
  }));
  
}
