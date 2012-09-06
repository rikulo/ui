//Test Code: TestDialog

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/util/util.dart');

class TestDialog extends Activity {

  void onCreate_() {
    Button btn = new Button("Open a dialog");
    btn.profile.location = "center left";
    btn.on.click.add((event) {
      View dlg = new TextView("Clicked me to close");
      dlg.style.cssText = "text-align: center; padding-top: 20px";
      dlg.profile.text = "location: center center;width:30%;height:20%";
      dlg.classes.add("v-dialog");
      dlg.on.click.add((e) {
        removeDialog();
      });
      addDialog(dlg);
    });
    mainView.addChild(btn);

    btn = new Button("Replace the main View");
    btn.profile.location = "center right";
    btn.on.click.add((event) {
      mainView = new TextView.fromHTML("<h1>New Main View</h1><p>The main view has been replaced</p>");
    });
    mainView.addChild(btn);
  }
}

void main() {
  new TestDialog().run();
}
