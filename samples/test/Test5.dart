//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Test5 extends Activity {

	void onCreate_() {
		title = "Test 5: Performance Test";

		final View vlayout = new View();
		vlayout.layout.type = "linear";
		vlayout.layout.orient = "vertical";
		rootView.appendChild(vlayout);

		for (int i = 0; i < 50; ++i) {
			View hlayout = new View();
			hlayout.profile.height = "content";
			hlayout.layout.type = "linear";
			hlayout.style.border = "1px  solid #885";
			vlayout.appendChild(hlayout);

			for (int j = 0; j < 50; ++j) {
				TextView view = new TextView("$i.$j");
				view.style.backgroundColor = "orange";
				view.style.padding = "3px";
				view.width = 50;
				view.height = 30;
				hlayout.appendChild(view);
			}
		}
	}
}

void main() {
	new Test5().run();
}
