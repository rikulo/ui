//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Test2 extends Activity {

	void onCreate_() {
		title = "Test 2: Free Layout";

		rootView.style.backgroundColor = "#cca";

		View view = new View();
		view.style.backgroundColor = "#ddb";
		view.style.border = "5px solid #885";
		view.profile.anchor = "parent";
		view.profile.location = "center center";
		view.profile.width = "70%";
		view.profile.height = "80%";
		rootView.appendChild(view);

		TextView txt = new TextView("child (right top)");
		txt.style.border = "1px solid #555";
		txt.profile.anchorView = view;
		txt.profile.location = "right top";
		txt.profile.width = "flex";
		view.appendChild(txt);

		txt = new TextView("child (left bottom)");
		txt.style.border = "1px solid #555";
		txt.profile.anchorView = view;
		txt.profile.location = "left bottom";
		txt.profile.width = "flex";
		view.appendChild(txt);

		txt = new TextView("sibling (left center)");
		txt.style.border = "1px solid #555";
		txt.profile.anchorView = view;
		txt.profile.location = "left center";
		txt.profile.width = "flex";
		rootView.appendChild(txt);
	}
}

void main() {
	new Test2().run();
}
