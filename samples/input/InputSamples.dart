//Sample Code: Input Samples

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');

class InputSamples extends Activity {

	void onCreate_() {
		title = "Input Samples";

		rootView.layout.text = "type: linear; orient: vertical";

		for (final String type in
		["text", "password", "multiline", "date", "color"]) {
			View view = new View();
			view.layout.text = "type: linear";
			rootView.addChild(view);

			view.addChild(new TextView(type));
			view.addChild(new TextBox(type: type));
		}
	}
}


void main() {
	new InputSamples().run();
}
