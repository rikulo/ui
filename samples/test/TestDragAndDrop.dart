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
      view.on
      ..dragOver.add((event) {
        event.preventDefault(); //it means "allow drop"
      })
      ..drop.add((event) {
        final view = getContainer(event.target);
        if (view != null) {
          view.classes.remove("dragover");
            //Chrome issue: dragLeave not called, so clean up here
          view.addChild(ViewUtil.getView(event.dataTransfer.getData("dragged")));
          view.requestLayout();
        }
      });
      mainView.addChild(view);
    }
    for (int i = 0; i < 3; ++i) {
      final view = new TextView("View $i");
      view.classes..add("box")..add("b$i");
      view.draggable = true;
      mainView.firstChild.addChild(view);
    }
    mainView.on
    ..dragStart.add((event) {
      event.target.classes.add("dragged");
      event.dataTransfer.setData("dragged", event.target.uuid);
    })
    ..dragEnd.add((event) {
      event.target.classes.remove("dragged");
    })
    ..dragEnter.add((event) {
      final view = getContainer(event.target);
      if (view != null)
        window.setTimeout((){view.classes.add("dragover");}, 0);
        //Chrome issue: prev.dragLeave is fired after nextdragEnter, so
        //we have to defer dragEnter to make the sequence: leave and then enter
    })
    ..dragLeave.add((event) {
      final view = getContainer(event.target);
      if (view != null)
        view.classes.remove("dragover");
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
