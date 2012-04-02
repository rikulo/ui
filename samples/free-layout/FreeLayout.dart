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
	}
}

void main() {
	new LayoutDemo().run();
}
