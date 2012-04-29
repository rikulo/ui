//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/util/util.dart');

class HelloWorld extends Activity {

	void onCreate_() {
		title = "Hello World!";
		log("$title started...");

		TextView text = new TextView("Hello World!");
		text.on.click.add((event) {
			event.target.style.border =
				event.target.style.border.isEmpty() ? "1px solid blue": "";
		});
		rootView.appendChild(text);
	}
}

void main() {
	new HelloWorld().run();
}
