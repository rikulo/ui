//Sample Code: Test ZoomGesture

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');

class MapDemo extends Activity {
  
  void onCreate_() {
    
    final int imgw = 500, imgh = 395;
    
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
    
    Offset diff;
    Transformation trans;
    
    // sizing
    img.on.preLayout.add((LayoutEvent event) {
      Size psize = new DOMQuery(panel).innerSize;
      if (psize.width / imgw < psize.height / imgh) {
        img.width = psize.width.toInt();
        img.height = (psize.width * imgh / imgw).toInt();
      } else {
        img.width = (psize.height * imgw / imgh).toInt();
        img.height = psize.height.toInt();
      }
      trans = new Transformation.identity();
      img.style.transform = CSS.transform(trans);
      
    });
    
    new ZoomGesture(mainView.node, start: (ZoomGestureState state) {
      diff = center(img) - state.startMidpoint;
      
    }, move: (ZoomGestureState state) {
      img.style.transform = CSS.transform(state.transformation.originAt(diff) * trans);
      
    }, end: (ZoomGestureState state) {
      trans = state.transformation.originAt(diff) * trans;
      
    });
    
    new DragGesture(mainView.node, move: (DragGestureState state) {
      img.style.transform = CSS.transform(new Transformation.transit(state.transition) * trans);
      
    }, end: (DragGestureState state) {
      trans = new Transformation.transit(state.transition) * trans;
      
    });
    
  }
  
  Offset center(View v) {
    Size size = new DOMQuery(v).outerSize;
    return new DOMQuery(v).pageOffset + new Offset(size.width / 2, size.height / 2);
  }
  
}

void main() {
  new MapDemo().run();
}
