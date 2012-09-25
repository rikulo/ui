//Sample Code: Test Log

#import('../lib/app.dart');
#import('../lib/view.dart');
#import('../lib/util.dart');

class TestPrintc extends Activity {

  void onCreate_() {
    printc("Started");
    printc(null);
    int count = 0;
    Button btn = new Button("Click Me!");
    btn.on.click.add((event) {
      printc("Clicked ${++count}");
    });
    mainView.addChild(btn);
  }
}

void main() {
  new TestPrintc().run();
}
