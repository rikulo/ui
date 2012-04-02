//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class LayoutDemo extends Activity {

	void onCreate_(View rootView) {
		View view = new View();
		view.style.backgroundColor = "blue";
		view.left = 80;
		view.top = 50;
		view.width = 300;
		view.height = 200;
		rootView.appendChild(view);

		//1. first level dependence
		for (final String loc in ["north start", "west end", "east center",
		"south end", "top left", "bottom right"]) {
			TextView txt = new TextView(loc);
			txt.style.border = "1px solid #555";
			txt.profile.anchorView = view;
			txt.profile.location = loc;
			rootView.appendChild(txt);
		}

		//2. second level dependence
		TextView txt = new TextView("bottom right 2");
		txt.style.border = "1px solid #555";
		txt.profile.anchorView = rootView.lastChild;
		txt.profile.location = "bottom right";
		rootView.appendChild(txt);
	}
}

void main() {
	new LayoutDemo().run();
}
