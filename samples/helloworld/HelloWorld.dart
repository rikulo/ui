//Sample Code: Hello World!

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');

class HelloWorld extends Activity {

	void onCreate_() {
		title = "Hello World!";

		TextView text = new TextView("Hello World!");
		text.profile.text = "anchor:  parent; location: center center";
		text.on.click.add((ViewEvent event) {
			event.target.style.border =
				event.target.style.border.isEmpty() ? "1px solid blue": "";
		});
		rootView.appendChild(text);
	}
}


void main() {
	new HelloWorld().run();
}
