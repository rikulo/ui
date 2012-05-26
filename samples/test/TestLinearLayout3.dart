//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestLinearLayout3 extends Activity {

	void onCreate_() {
		title = "Test 5: Performance Test";

		rootView.layout.type = "linear";
		rootView.layout.orient = "vertical";

		for (int i = 0; i < 50; ++i) {
			View hlayout = new View();
			hlayout.profile.width = "flex";
			hlayout.profile.height = "content";
			hlayout.layout.type = "linear";
			hlayout.style.border = "1px solid #885";
			rootView.addChild(hlayout);

			for (int j = 0; j < 50; ++j) {
				TextView view = new TextView("$i.$j");
				view.style.backgroundColor = "orange";
				view.style.padding = "5px";
				view.style.textAlign = "center";
				view.width = 50; //equivalent to view.profile.width = "50"
				view.height = 30; //equivalent to view.profile.height = "30"
					 //performance is much better if not to use "content" (default)
				hlayout.addChild(view);
			}
		}
	}
}

void main() {
	new TestLinearLayout3().run();
}
