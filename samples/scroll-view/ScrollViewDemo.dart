//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class ScrollViewDemo extends Activity {

	void onCreate_() {
		title = "ScrollView Demo";

		final ScrollView view = new ScrollView();
		view.profile.text =
			"anchor: parent; location: center center; width: 80%; height: 80%";
		view.classes.add("scroll-view");

		for (int i = 0; i < 20; ++i) {
			View child = new View();
			final int r = (i * 5 + 70) % 100,
					g = (i * 5 + 70) % 100, b = (i * 2 + 50) % 100;
			child.style.cssText = "border: 1px solid #553; background-color: #$r$g$b";
			child.left = child.top = i * 100;
			child.width = child.height = 100;
			view.appendChild(child);

			child = new View();
			child.style.cssText = "border: 1px solid #553; background-color: #$b$g$r";
			child.left = 2000 - i * 100;
			child.top = i * 100;
			child.width = child.height = 100;
			view.appendChild(child);
		}

		rootView.appendChild(view);
	}
}

void main() {
	new ScrollViewDemo().run();
}
