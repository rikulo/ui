//Sample Code: Circles

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/html/html.dart');
#import('../../client/view/view.dart');
#import('../../client/effect/effect.dart');

Animator animator;

class Ball {
	final View view;
	int radius, centerX, centerY;
	double speed;

	Ball(int this.radius, double this.speed, int size, String color):
	view = new View() {
		view.style.cssText = "border-radius: ${size>>1}px;border: ${size>>1}px solid $color";
		view.width = view.height = size;
		centerX = (browser.size.width - size) >> 1;
		centerY = (browser.size.height - size) >> 1;
		animator.add((int time, int elapsed) {
			updatePosition(time);
			return true;
		});
	}
	void updatePosition(int time) {
		final double degree = time * speed / 1000;
		view.left = centerX + (radius * Math.sin(degree)).toInt();
		view.top = centerY + (radius * Math.cos(degree)).toInt();
	}
}

class Circle extends Activity {
	void onCreate_() {
		title = "Circles";
		animator = new Animator();
		rootView.appendChild(new Ball(50, 2.0, 12, "red").view);
		rootView.appendChild(new Ball(30, 1.3, 12, "blue").view);
		rootView.appendChild(new Ball(70, 1.6, 20, "green").view);
		rootView.appendChild(new Ball(100, 1.0, 26, "yellow").view);
		rootView.appendChild(new Ball(130, 0.8, 16, "#0ff").view);
	}
}

void main() {
	new Circle().run();
}
