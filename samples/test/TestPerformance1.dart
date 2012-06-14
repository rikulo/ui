//Sample Code: LinearLayout Test Performance 1

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestPerformance1 extends Activity {

  void onCreate_() {
    title = "Test 1: Performance Test";

    mainView.layout.text = "type: linear; orient: vertical";

    for (int i = 0; i < 50; ++i) {
      View hlayout = new View();
      hlayout.profile.text = "width: flex; height: content";
      hlayout.layout.type = "linear";
      hlayout.style.border = "1px solid #885";
      mainView.addChild(hlayout);

      for (int j = 0; j < 50; ++j) {
        TextView view = new TextView("$i.$j");
        view.style.backgroundColor = "orange";
        view.style.padding = "5px";
        view.style.textAlign = "center";
        view.profile.text = "width: 50; height: 30";
          //performance is much better if not to use "content" (default)
          //note: don't assign to view.width/height directly since it is slower (measureWidth_ will be called)
        hlayout.addChild(view);
      }
    }
  }
}

void main() {
  new TestPerformance1().run();
}
