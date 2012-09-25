//Sample Code: CompositeViewDemo

#import('../../lib/app.dart');
#import('../../lib/view.dart');

#import('LabeledInput.dart');

class CompositeViewDemo extends Activity {
  void onCreate_() {
    title = "Composite View Demo";

    mainView.layout.text = "type: linear; orient: vertical";
    mainView.addChild(new LabeledInput("username"));
    mainView.addChild(new LabeledInput("password"));

    for (LabeledInput view in mainView.queryAll("LabeledInput"))
      view.on.change.add((event) {
        print("$event received");
        });
  }
}

void main() {
  new CompositeViewDemo().run();
}
