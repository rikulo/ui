//Sample Code: Test Log

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/util/util.dart');

class TestDrag extends Activity {
  
  Rectangle range;
  
  void onCreate_() {
    _createBoxedDrag(mainView);
    _createSimpleDrag(mainView);
  }
  View _createSimpleDrag(View parent) {
    View view = _createDragView(parent, "Simple Drag");
    new Dragger(view.node);
    return view;
  }
  View _createBoxedDrag(View parent) {
    View box = new View();
    box.classes.add("drag");
    box.profile.text = "location: center center; width: 70%; height: 70%";
    parent.addChild(box);
    View view = _createDragView(box, "Boxed Drag");
    
    new Dragger(view.node, snap: (Offset ppos, Offset pos) => range.snap(pos));
    
    view.on.layout.add((event) {
      final Size vs = new DOMQuery(view).outerSize;
      final Size bs = new DOMQuery(box).innerSize;
      range = new Rectangle(0, 0, bs.width - vs.width, bs.height - vs.height);
      final Offset vpos = range.snap(new DOMQuery(view).offset);
      view.left = vpos.left;
      view.top = vpos.top;
    });
    
    return box;
  }
  TextView _createDragView(View parent, String label) {
    TextView view = new TextView(label);
    view.classes.add("drag");
    view.left = view.top = 20;
    parent.addChild(view);
    return view;
  }
}

void main() {
  new TestDrag().run();
}
