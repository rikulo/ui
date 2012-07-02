//Sample Code: Hello World!

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class HelloWorld extends Activity {

  void onCreate_() {
    title = "Hello World!";

    TextView welcome = new TextView("Hello World!");
    welcome.profile.text = "anchor:  parent; location: center center";
    welcome.on.click.add((event) {
      welcome.text = "Hi, this is Rikulo.";
      welcome.style.border = welcome.style.border.isEmpty() ? "1px solid blue": "";
      welcome.parent.requestLayout();
    });
    mainView.addChild(welcome);
  }
}


void main() {
  new HelloWorld().run();
}
