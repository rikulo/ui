//Sample Code: Test Log

#import("dart:html");
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/uil/uil.dart');

class TestUIL extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";
    test1(mainView);
    test2(mainView);
  }
  void test1(View parent) {
    new Template('''
      <View layout="type: linear">
        <CheckBox text="Apple"/>
        <CheckBox text="Orange"/>
        <TextView data-class="list">
          <attribute name="html">
            <ul>
              <li>This is the first item of TextView with HTML</li>
              <li style="font-weight: bold">This is the second</li>
            </ul>
          </attribute>
        </TextView>
      </View>
      ''').create(parent);
  }
  void test2(View parent) {
    new Template.fromNode(document.query("#uil").elements[0].remove())
      .create(parent);
  }
}

void main() {
  new TestUIL().run();
}
