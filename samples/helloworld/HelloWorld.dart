//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class HelloWorld extends Activity {

	void onCreate_(View mainView) {
		TextView text = new TextView("Hello World!");
		text.on.click.add((event) {
			event.target.style.border =
				event.target.style.border.isEmpty() ? "1px solid blue": "";
		});
		mainView.appendChild(text);
	}
}

void main() {
	new HelloWorld().run();
}
