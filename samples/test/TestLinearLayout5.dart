//Sample Code: LinearLayout Test 5

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestLinearLayout5 extends Activity {

  void onCreate_() {
    title = "Test 5: Virtual Linear Layout";

    mainView.layout.text = "type: linear; orient: vertical";
    mainView.addChild(new TextView("You shall see two buttons arranged vertically, and the width shall be best-fit"));
    mainView.addChild(new Button("The first button"));
    mainView.addChild(new Button("The second button"));
  }
}

void main() {
  new TestLinearLayout5().run();
}
