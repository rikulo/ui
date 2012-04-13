//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

#import('viewport.dart');

class ViewportDemo extends Activity {

	void onCreate_() {
		title = "Viewport Demo";

		Viewport viewport = new Viewport();
		viewport.profile.width = viewport.profile.height = "flex";
		rootView.appendChild(viewport);

		viewport.appendChild(new TextView("Hello Viewport!"));
	}
}

void main() {
	new ViewportDemo().run();
}
