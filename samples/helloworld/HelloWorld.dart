#import('dart:html');
#import('../../client/widget/Div.dart');
#import('../../client/widget/Label.dart');

class HelloWorld {

  helloworld() {
  }

  void run() {
    new Div()
      .appendChild(new Label("Hello World!"))
      .addToDocument(document.query('#status'), outer:true);
  }
}

void main() {
  new HelloWorld().run();
}
