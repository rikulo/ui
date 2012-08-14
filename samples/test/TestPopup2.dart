//Sample Code: Test Log

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestPopup2 extends Activity {

  void onCreate_() {
    ScrollView view = new ScrollView();
    view.classes.add("v-dialog");
    view.profile.text = "width: 80%; height: 80%; location: center center";

    View color = new View();
    color.style.backgroundColor = "blue";
    color.left = color.top = 100;
    color.width = 2000;
    color.height = 600;
    view.addChild(color);

    Button btn = new Button("Show Popup");
    btn.profile.anchorView = color;
    btn.profile.location = "north start";
    view.addChild(btn);

    View popup = new PopupView();
    popup.profile.anchorView = btn;
    popup.profile.location = "south start";
    popup.width = 300;
    popup.height = 200;
    popup.style.backgroundColor = "yellow";
    popup.visible = false;
    view.addChild(popup);

    btn.on.click.add((event) {
        popup.visible = true;
      });

    Button btn2 = new Button("Create Popup 1");
    btn2.profile.anchorView = btn;
    btn2.profile.location = "east start";
    btn2.on.click.add((event) {
        final pp = new PopupView();
        pp.width = 200;
        pp.height = 150;
        pp.style.backgroundColor = "orange";
        pp.on.dismiss.add((e) {pp.removeFromParent();});
        view.addChild(pp, popup);
        pp.locateTo("south start", btn2);
      });
    view.addChild(btn2);

    Button btn3 = new Button("Create Popup 2 (timeout: 5s)");
    btn3.profile.anchorView = btn2;
    btn3.profile.location = "east start";
    btn3.on.click.add((event) {
        final pp = new PopupView(dismissTimeout: 5000, dismissOnClickOutside: false);
        pp.profile.anchorView = btn3;
        pp.profile.location = "south start";
        pp.width = 150;
        pp.height = 100;
        pp.style.backgroundColor = "#0ff";
        pp.on.dismiss.add((e) {pp.removeFromParent();});
        view.addChild(pp, popup);
        pp.requestLayout(immediate: true);
      });
    view.addChild(btn3);

    mainView.addChild(view);
  }
}

void main() {
  new TestPopup2().run();
}
