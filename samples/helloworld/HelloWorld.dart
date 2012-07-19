//Sample Code: Hello World!

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class HelloWorld extends Activity {

  void onCreate_() {
    title = "Hello World!";

    TextView welcome = new TextView("Hello World!");
    welcome.profile.location = "center center";
    welcome.on.click.add((event) {
      welcome.text = "Hi, this is Rikulo.";
      welcome.style.border = welcome.style.border.isEmpty() ? "1px solid blue": "";
      welcome.requestLayout(); //need to re-layout since its size is changed
    });
    mainView.addChild(welcome);
  }
}


void main() {
  new HelloWorld().run();
}
