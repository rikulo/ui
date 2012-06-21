//Sample Code: Test Log

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');

class TestDrag extends Activity {

  void onCreate_() {
    _createBoxedDrag(mainView);
    _createSimpleDrag(mainView);
  }
  View _createSimpleDrag(View parent) {
    View view = _createDragView(parent, "Simple Drag");
    view.on.enterDocument.add((event) {
      new DragGesture(view.node);
    });
    return view;
  }
  View _createBoxedDrag(View parent) {
    View box = new View();
    box.classes.add("drag");
    box.profile.text =
      "anchor: parent; location: center center; width: 70%; height: 70%";
    parent.addChild(box);

    View view = _createDragView(box, "Boxed Drag");
    view.on.enterDocument.add((event) {
      new DragGesture(view.node);
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
