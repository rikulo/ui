//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class HelloWorld extends Activity {

	void onCreate_(View mainView) {
		Label label = new Label("Hello World!");
		label.on.click.add((event) {
			event.target.style.border =
				event.target.style.border.isEmpty() ? "1px solid blue": "";
		});
		mainView.appendChild(label);
	}
}

void main() {
	new HelloWorld().run();
}
