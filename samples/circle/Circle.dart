//Sample Code: Circles

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/effect/effect.dart');

Animator animator;

class Ball {
	final View view;
	int radius, speed;

	Ball(int this.radius, int this.speed, int size, String color):
	view = new View() {
		view.style.cssText = "border-radius: ${size~/2}px;border: ${size~/2}px solid $color";
		view.width = view.height = size;
	}
}

class Circle extends Activity {
	void onCreate_() {
		title = "Circles";
		animator = new Animator();
		rootView.appendChild(new Ball(50, 20, 12, "red").view);
	}
}

void main() {
	new Circle().run();
}
