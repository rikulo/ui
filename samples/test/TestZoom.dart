//Sample Code: Test ZoomGesture

#import('dart:html');
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');

final int statusHeight = 50;

class TestZoom extends Activity {
  
  int statusHeight = 100;
  
  void onCreate_() {
    
    View sf0 = dot("#DDFF33", 10);
    View sf1 = dot("#DDFF33", 10);
    View cf0 = dot("#33FFBB", 20);
    View cf1 = dot("#33FFBB", 20);
    
    View panel = new View();
    panel.profile.text = "location: top center; width: 100%";
    panel.style.backgroundColor = "#000000";
    panel.style.overflow = "hidden";
    
    TextView sc = label("-");
    TextView ro = label("-");
    TextView tr = label("-");
    
    View status = new View();
    status.layout.type = "linear";
    status.layout.orient = "horizontal";
    status.profile.text = "location: bottom center; width: 100%";
    status.height = statusHeight;
    
    // view tree
    panel..addChild(sf0)..addChild(sf1)..addChild(cf0)..addChild(cf1);
    status..addChild(sc)..addChild(ro)..addChild(tr);
    mainView..addChild(panel)..addChild(status);
    
    // sizing
    panel.on.preLayout.add((LayoutEvent e) {
      panel.height = new DOMQuery(mainView).innerHeight - statusHeight;
    });
    
    // zoom gesture
    new ZoomGesture(panel.node, start: (ZoomGestureState state) {
      List<Offset> poss = state.positions;
      cf0.left = sf0.left = poss[0].left;
      cf0.top  = sf0.top  = poss[0].top;
      cf1.left = sf1.left = poss[1].left;
      cf1.top  = sf1.top  = poss[1].top;
      cf0.visible = sf0.visible = true;
      cf1.visible = sf1.visible = true;
      
    }, move: (ZoomGestureState state) {
      List<Offset> poss = state.positions;
      cf0.left = poss[0].left;
      cf0.top  = poss[0].top;
      cf1.left = poss[1].left;
      cf1.top  = poss[1].top;
      
      sc.html = "${(state.scalar * 10000).toInt() / 100}%";
      ro.html = "${(state.angle * 1800 / PI).toInt() / 10}&deg;";
      tr.html = "${state.transition}";
      
    }, end: (ZoomGestureState state) {
      cf0.visible = sf0.visible = false;
      cf1.visible = sf1.visible = false;
      
    });
    
  }
  
}

String printOffset(Offset off) => 
    "(${(off.x * 100).toInt() / 100}, ${(off.y * 100).toInt() / 100})";

View dot(String color, int zIndex) {
  View d = new View();
  d.width = d.height = 0;
  d.style.border = "5px solid $color";
  d.style.borderRadius = "5px";
  d.style.boxShadow = "0 0 10px $color";
  d.style.zIndex = "$zIndex";
  d.visible = false;
  return d;
}

TextView label([String text]) {
  final int fontSize = (statusHeight / 2).toInt();
  TextView lb = new TextView();
  lb.profile.text = "height: 100%; width: flex";
  lb.style.fontSize = CSS.px(fontSize);
  lb.style.lineHeight = CSS.px(statusHeight);
  if (text != null)
    lb.html = text;
  return lb;
}

void main() {
  new TestZoom().run();
}
