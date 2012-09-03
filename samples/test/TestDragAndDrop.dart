//Sample Code: Test Log

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/util/util.dart');

class TestDragAndDrop extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";
    for (int i = 0; i < 2; ++i) {
      final view = new View();
      view.classes.add("container");
      view.layout.text = "type: linear; spacing: 5";
      mainView.addChild(view);
    }
    for (int i = 0; i < 3; ++i) {
      final view = new TextView("View $i");
      view.classes..add("box")..add("b$i");
      view.draggable = true;
      mainView.firstChild.addChild(view);
    }

    mainView.on
    //create drag effect
    ..dragStart.add((event) {
      event.target.classes.add("dragged");
      event.dataTransfer.setData("dragged", event.target.uuid);
    })
    ..dragEnd.add((event) {
      event.target.classes.remove("dragged");
    })
    //allow drop if it is in a container
    ..dragOver.add((event) {
      if (getContainer(event.target) != null)
        event.preventDefault();
        //calling preventDefault in dragOver means "allow drop"
    })
    //create allow-drop effect
    ..dragEnter.add((event) {
      final container = getContainer(event.target);
      if (container != null)
        window.setTimeout((){container.classes.add("dragover");}, 0);
        //Chrome issue: prev.dragLeave is fired after nextdragEnter, so
        //we have to defer dragEnter to make the sequence: leave and then enter
    })
    ..dragLeave.add((event) {
      final container = getContainer(event.target);
      if (container != null)
        container.classes.remove("dragover");
    })
    //handle drop
    ..drop.add((event) {
      final container = getContainer(event.target);
      if (container != null) {
        container.classes.remove("dragover");
          //Chrome issue: dragLeave not called, so clean up here
        container.addChild(ViewUtil.getView(event.dataTransfer.getData("dragged")));
        container.requestLayout();
      }
    });

    mainView.addChild(new TextView("Drag views between two containers"));
  }
  static View getContainer(View view) {
    for (; view != null; view = view.parent)
      if (view.classes.contains('container'))
        return view;
  }
}

void main() {
  new TestDragAndDrop().run();
}
