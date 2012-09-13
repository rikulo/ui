//Sample Code: Test Log

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');
#import('../../client/util/util.dart');

class TestDragAndDrop extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";
    for (int i = 0; i < 2; ++i) {
      final view = new View();
      view.classes.add("container");
      view.layout.text = "type: linear; spacing: 5";
      view.profile.text = "min-width: 156; min-height: 156";
      mainView.addChild(view);
    }
    final images = ["alpaca-01.jpg", "alpaca-02.jpg", "alpaca-03.jpg", "alpaca-04.jpg"];
    for (int i = 0; i < images.length; ++i) {
      final view = new Image("http://static.rikulo.org/blogs/tutorial/swipe-album/res/${images[i]}");
        //IE accepts only Image as draggable
      view.width = view.height = 150;
      view.classes..add("box");
      view.draggable = true;
      mainView.firstChild.addChild(view);
    }

    mainView.on
    //create drag effect
    ..dragStart.add((event) {
      event.target.classes.add("dragged");
      event.dataTransfer.setData("Text", "uuid:${event.target.uuid}");
        //IE accepts only "Text" and "URL" as the first argument
    })
    ..dragEnd.add((event) {
      event.target.classes.remove("dragged");
    })
    //allow drop if it is in a container
    ..dragOver.add((event) {
      if (getContainer(event) != null)
        event.preventDefault();
        //calling preventDefault in dragOver means "allow drop"
    })
    //create allow-drop effect
    ..dragEnter.add((event) {
      final container = getContainer(event);
      if (container != null)
        window.setTimeout((){container.classes.add("dragover");}, 0);
        //Chrome issue: prev.dragLeave is fired after nextdragEnter, so
        //we have to defer dragEnter to make the sequence: leave and then enter
    })
    ..dragLeave.add((event) {
      final container = getContainer(event);
      if (container != null)
        container.classes.remove("dragover");
    })
    //handle drop
    ..drop.add((event) {
      final container = getContainer(event);
      if (container != null) {
        container.classes.remove("dragover");
          //Chrome issue: dragLeave not called, so clean up here
        final data = event.dataTransfer.getData("Text");
        container.addChild(ViewUtil.getView(data.substring(5).trim())); //trim uuid:
        container.requestLayout();
      }
    });

    mainView.addChild(new TextView("Drag views between two containers"));
  }
  static View getContainer(ViewEvent event) {
    //to protect the drop from other source, we have to check data first
    final data = event.dataTransfer.getData("Text");
    if (data != null && data.startsWith("uuid:"))
      for (View view = event.target; view != null; view = view.parent)
        if (view.classes.contains('container'))
          return view;
  }
}

void main() {
  new TestDragAndDrop().run();
}
