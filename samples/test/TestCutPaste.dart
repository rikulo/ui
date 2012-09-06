//Sample Code: Cut-and-Paste

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');

class TestCutPaste extends Activity {

  void onCreate_() {
    title = "Cut-and-Paste Test";

    mainView.addChild(new Style.fromContent('''
.round {
  border-radius: 6px;
  border: 5px solid #886;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.7);
}
  '''));

    View view1 = new View();
    view1.classes.add('round');
    view1.profile.text =
      "anchor: parent; location: left top; width: 100%; height: 45%";
    mainView.addChild(view1);

    View view2 = new View();
    view2.classes.add('round');
    view2.profile.text =
      "anchor: parent; location: left bottom; width: 100%; height: 45%";
    mainView.addChild(view2);

    View subview = newSubview();
    view1.addChild(subview);

    Button button = new Button("Cut and Paste");
    button.profile.text = "anchor: parent; location: center center";
    button.on.click.add((event) {
      View newparent = view1.firstChild != null ? view2: view1;
      subview.cut().pasteTo(newparent);
    });
    mainView.addChild(button);

    button = new Button("Remove and Add");
    button.profile.text = "anchor: parent; location: left center";
    button.on.click.add((event) {
      (view1.firstChild != null ? view2: view1).addChild(subview);
    });
    mainView.addChild(button);
  }
  View newSubview() {
    View view = new View();
    for (int x = 0; x < 5; ++x) {
      for (int y = 0; y < 3; ++y) {
        View child = new View();
        final String color = CSS.color(250 - x * 4, 250 - y * 4, 200);
        child.style.cssText = "border: 1px solid #553; background-color: $color";
        child.left = x * 50 + 2;
        child.top = y * 50 + 2;
        child.width = child.height = 46;
        view.addChild(child);
      }
    }
    return view;
  }
}

void main() {
  new TestCutPaste().run();
}
