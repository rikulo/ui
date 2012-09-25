#import('../../lib/app.dart');
#import('../../lib/view.dart');
#import('../../lib/model.dart');
#import('../../lib/event.dart');
#import('../../lib/util.dart');

class Issue5 extends Activity {

  void onCreate_() {
    Button btn = new Button("Click me to show switches and check if one is on and the other off");
    btn.profile.text = "anchor:parent;location:top center";
    mainView.addChild(btn);

    View myView = new View();
    myView.visible = false;
    myView.layout.text = "type: linear; orient: vertical";
    mainView.addChild(myView);

    btn.on.click.add((event) {
      myView.visible = !myView.visible;
    });

    myView.addChild(new Switch(true));
    myView.addChild(new Switch(false));
  }
}

void main() {
  new Issue5().run();
}