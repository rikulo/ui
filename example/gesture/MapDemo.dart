//Sample Code: Test ZoomGesture

import 'dart:html';

import 'package:rikulo_ui/html.dart';
import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/gesture.dart';
import 'package:rikulo_ui/event.dart';

Point center(View v)
=> DomUtil.page(v.node) + new Point(v.node.offsetWidth / 2, v.node.offsetHeight / 2);

void main() {
  final int imgw = 500, imgh = 395;
  
  final View mainView = new View()..addToDocument();
  mainView.style.backgroundColor = "#000000";
  mainView.style.overflow = "hidden";
  
  View panel = new View();
  panel.profile.text = "location: center center; width: 90%; height: 90%";
  
  Image img = new Image();
  // http://www.flickr.com/photos/normanbleventhalmapcenter/2675391188/
  // Creative Commons License
  img.src = "http://static.rikulo.org/blogs/tutorial/zoom-map/res/dutch-west-india-company-map.jpg";
  img.profile.text = "location: center center";
  
  panel.addChild(img);
  mainView.addChild(panel);
  img.node.draggable = false;
  
  Point diff;
  Transformation trans;
  
  // sizing
  img.on.preLayout.listen((LayoutEvent event) {
    Size psize = DomUtil.clientSize(panel.node);
    if (psize.width / imgw < psize.height / imgh) {
      img.width = psize.width.toInt();
      img.height = psize.width * imgh ~/ imgw;
    } else {
      img.width = psize.height * imgw ~/ imgh;
      img.height = psize.height.toInt();
    }
    trans = new Transformation.identity();
    img.style.transform = CssUtil.transform(trans);
    
  });
  
  new ZoomGesture(mainView.node, start: (ZoomGestureState state) {
    diff = center(img) - state.startMidpoint;
    
  }, move: (ZoomGestureState state) {
    img.style.transform = CssUtil.transform(state.transformation.originAt(diff) * trans);
    
  }, end: (ZoomGestureState state) {
    trans = state.transformation.originAt(diff) * trans;
    
  });
  
  new DragGesture(mainView.node, move: (DragGestureState state) {
    img.style.transform = CssUtil.transform(new Transformation.transit(state.transition) * trans);
    
  }, end: (DragGestureState state) {
    trans = new Transformation.transit(state.transition) * trans;
    
  });
  
}
