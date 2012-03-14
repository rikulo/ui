//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class HelloWorld extends Activity {

	void onCreate_(View main) {
		main.appendChild(new Label("Hello World!"));
	}
}

void main() {
	new HelloWorld().run();
}
