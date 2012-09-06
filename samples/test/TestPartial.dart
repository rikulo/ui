//Sample Code: activity is just a part of whole HTML page

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestPartial extends Activity {

  void onCreate_() {
    TextView welcome = new TextView("Hello World!");
    welcome.profile.text = "location: center center";
    welcome.on.click.add((event) {
      TextView v = new TextView.fromHTML('<ul><li>Dialog Popup</li><li>center center</li></ul>');
      v.classes.add("v-dialog");
      v.profile.location = "center center";
      addDialog(v);
    });
    mainView.addChild(welcome);
  }
}

void main() {
  new TestPartial().run();
}
