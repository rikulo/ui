//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Test1 extends Activity {

	void onCreate_(View rootView) {
		title = "Test 1: Free Layout";

		rootView.style.backgroundColor = "#cca";

		View view = new View();
		view.style.backgroundColor = "#ddb";
		view.style.border = "1px solid white";
		view.profile.anchor = "parent";
		view.profile.location = "center center";
		view.profile.width = "content"; //must! it forces width being calced
		view.profile.height = "content"; //must! it forces height being calced
		rootView.appendChild(view);

		//test if subview will affect its parent's size
		View subview = new View();
		subview.style.backgroundColor = "#eec";
		subview.left = 100;
		subview.top = 10;
		subview.width = 30; //test: direct with
		subview.height = 20;
		view.appendChild(subview);

		subview = new View();
		subview.style.backgroundColor = "#eec";
		subview.left = 10;
		subview.top = 100;
		subview.profile.width = "50"; //test: profile.width
		subview.profile.height = "30";
		view.appendChild(subview);

		//subview doesn't affect how its parent's size
		subview = new View();
		subview.style.backgroundColor = "#dd8";
		subview.profile.anchor = "parent";
		subview.profile.location = "south start";
		subview.profile.width = "100%";
		subview.profile.height = "15%";
		view.appendChild(subview);
	}
}

void main() {
	new Test1().run();
}
