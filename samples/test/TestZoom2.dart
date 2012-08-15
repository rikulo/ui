//Sample Code: Test ZoomGesture

#import('dart:html');
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');

final int statusHeight = 100;

class TestZoom2 extends Activity {
  
  void onCreate_() {
    
    final int imgw = 500, imgh = 395;
    
    mainView.style.backgroundColor = "#000000";
    
    View panel = new View();
    panel.profile.text = "location: center center; width: 90%; height: 90%";
    
    Image img = new Image();
    img.src = "http://farm4.staticflickr.com/3140/2675391188_d42c03b423.jpg";
    img.profile.text = "location: center center";
    
    panel.addChild(img);
    mainView.addChild(panel);
    
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
      Size size = new DOMQuery(img).outerSize;
      trans = new Transformation.identity();
      img.style.transform = CSS.transform(trans);
      
    });
    
    new ZoomGesture(mainView.node, start: (ZoomGestureState state) {
      diff = center(img) - state.startMidpoint;
      
    }, move: (ZoomGestureState state) {
      img.style.transform = CSS.transform(state.transformation.originAt(diff) % trans);
      
    }, end: (ZoomGestureState state) {
      trans = state.transformation.originAt(diff) % trans;
      
    });
    
  }
  
  Offset center(View v) {
    Size size = new DOMQuery(v).outerSize;
    return new DOMQuery(v).pageOffset + new Offset(size.width / 2, size.height / 2);
  }
  
}

void main() {
  new TestZoom2().run();
}
