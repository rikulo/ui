//Sample Code: Test Dialog

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/util/util.dart');

class TestDialog extends Activity {

	void onCreate_() {
		Button btn = new Button("Click Me!");
		btn.profile.text = "anchor: parent; location: center center";
		btn.on.click.add((event) {
			View dlg = new TextView("Clicked me to close");
			dlg.profile.text = "location: center center";
			dlg.classes.add("v-dialog");
			dlg.on.click.add((e) {
				removeDialog();
			});
			addDialog(dlg);
		});
		mainView.addChild(btn);
	}
}

void main() {
	new TestDialog().run();
}
