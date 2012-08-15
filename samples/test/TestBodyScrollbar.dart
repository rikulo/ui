//Sample Code: Test Log

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');

class TestBodyScrollbar extends Activity {

  void onCreate_() {
    View view = new View();
    view.style.backgroundColor = "blue";
    view.width = 300;
    view.height = 250;
    view.left = browser.size.width - 180;
    view.top = browser.size.height - 180;
    mainView.addChild(view);
    mainView.addChild(new TextView("You shall see the scrollbar shown"));
  }
}

void main() {
  new TestBodyScrollbar().run();
}
