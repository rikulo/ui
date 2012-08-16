//Sample Code: Test Log

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestViewTag extends Activity {

  void onCreate_() {
    View dl = new View.tag("dl");
    for (int i = 0; i < 10; ++i) {
      View li = new View.tag("li", {"type": "i", "value": i*2 + 1},
        "This is the <b>$i</b> item.", false);
      li.top = 22 * i;
      dl.addChild(li);
    }
    mainView.addChild(dl);
  }
}

void main() {
  new TestViewTag().run();
}
