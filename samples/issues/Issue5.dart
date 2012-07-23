#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/model/model.dart');
#import('../../client/event/event.dart');
#import('../../client/util/util.dart');

class Issue5 extends Activity {

  void onCreate_() {
    Button btn = new Button("Click me to show switches and check if one is on and the other off");
    btn.profile.text = "anchor:parent;location:top center";
    mainView.addChild(btn);

    View myView = new View();
    myView.hidden = true;
    myView.layout.text = "type: linear; orient: vertical";
    mainView.addChild(myView);

    btn.on.click.add((event) {
      myView.hidden = !myView.hidden;
    });

    myView.addChild(new Switch(true));
    myView.addChild(new Switch(false));
  }
}

void main() {
  new Issue5().run();
}