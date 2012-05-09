//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/util/util.dart');

class ScrollViewDemo extends Activity {

	void onCreate_() {
		title = "ScrollView Demo";

		final ScrollView view = new ScrollView();
		view.profile.text =
			"anchor: parent; location: center center; width: 80%; height: 80%";
		view.classes.add("scroll-view");

		for (int x = 0; x < 20; ++x) {
			for (int y = 0; y < 20; ++y) {
				View child = new View();
				final String color = StringUtil.rgb(250 - x * 4, 250 - y * 4, 200);
				child.style.cssText = "border: 1px solid #553; background-color: $color";
				child.left = x * 50 + 2;
				child.top = y * 50 + 2;
				child.width = child.height = 46;
				view.appendChild(child);
			}
		}

		rootView.appendChild(view);
		log("hello");
	}
}

void main() {
	new ScrollViewDemo().run();
}
