//Sample Code: Layout Demostration

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class LayoutDemo extends Activity {

	void onCreate_(View rootView) {
		View view = new View();
		view.style.backgroundColor = "blue";
		view.left = 50;
		view.top = 50;
		view.width = 100;
		view.height = 70;
		rootView.appendChild(view);
	}
}

void main() {
	new LayoutDemo().run();
}
