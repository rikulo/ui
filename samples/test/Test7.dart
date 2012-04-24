//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Test7 extends Activity {

	void onCreate_() {
		title = "Test 7: hlayout in hlayout";

		View view = new View();
		_setBorder(view);
		view.layout.type = "linear";
		view.layout.orient = "vertical";
		view.profile.width = view.profile.height = "flex";
		rootView.appendChild(view);

		TextView text = new TextView(html: '<h1 style="margin:0">$title</h1>');
		_setBorder(text);
		view.appendChild(text);

		text = new TextView("Description here");
		_setBorder(text);
		view.appendChild(text);
		
		_addOrientation(view);
	}
	void _addOrientation(View parent) {
		View view = new View();
		_setBorder(view);
		_setHLayout(view);
		parent.appendChild(view);

		TextView text = new TextView("Orientation");
		_setBorder(text);
		view.appendChild(text);

		View group = new View();
		_setHLayout(group);
		_setBorder(group);
//		group.profile.width = "content";
		group.layout.spacing = "0 5";
		view.appendChild(group);

		TextView horz = new TextView("horizontal");
		_setBorder(horz);
		group.appendChild(horz);
		TextView vert = new TextView("vertical");
		_setBorder(vert);
		group.appendChild(vert);
	}
	void _setBorder(View view) {
		view.style.border = "1px solid black";
	}
	void _setHLayout(View view) {
		view.layout.type = "linear";
		view.layout.width = "content";
		view.profile.width = "flex";
		view.profile.height = "content";
	}
}

void main() {
	new Test7().run();
}
