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
View dlg = new TextView("Clicked");
dlg.profile.text = "location: center center";
dlg.classes.add("v-dialog");
dlg.on.click.add((e) {
	removeDialog();
});
addDialog(dlg);
//			event.target.style.border =
//				event.target.style.border.isEmpty() ? "1px solid blue": "";
		});
		mainView.addChild(text);
	}
}


void main() {
	new HelloWorld().run();
}
