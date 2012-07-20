//Sample Code: Custom Layout Test 1

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestCustomLayout1 extends Activity {

  void onCreate_() {
    title = "Custom Layout Test 1";

    mainView.style.backgroundColor = "#cca";

    View view = new View();
    view.style.backgroundColor = "#ddb";
    view.profile.anchor = "parent";
    view.profile.location = "center center";
    view.profile.width = "70%";
    view.profile.height = "80%";
    var layoutListner;
    view.on.layout.add(layoutListner = (event) {
      view.on.layout.remove(layoutListner); //do only once

      TextView txt = new TextView("on.layout: A child at 10%, 10%");
      txt.style.border = "1px solid #663";
      txt.left = view.width ~/ 10;
      txt.top = view.height ~/ 10;
      txt.on.mount.add((event2) {
        TextView txt2 = new TextView("on.mount: another child at 20%, 20%");
        txt2.style.border = "1px solid #663";
        txt2.left = view.width ~/ 5;
        txt2.top = view.height ~/ 5;
        view.addChild(txt2);
      });
      view.addChild(txt);
    });
    mainView.addChild(view);
  }
}

void main() {
  new TestCustomLayout1().run();
}
