//Sample Code: Circles implemented in Canvas

#import('dart:html');
#import("dart:math");

#import('../../client/app/app.dart');
#import('../../client/html/html.dart');
#import('../../client/view/view.dart');
#import('../../client/effect/effect.dart');


CanvasRenderingContext2D ctx2d;
Canvas canvas;

class Ball {
  int size, radius;
  double speed;
  String color;

  Ball(int this.radius, double this.speed, int this.size, String this.color);

  void updatePosition(int time) {
    final double degree = time * speed / 1000;
    ctx2d.beginPath();
    ctx2d.fillStyle = color;
    ctx2d.arc(
      (canvas.width >> 1) + radius * sin(degree),
      (canvas.height >> 1) + radius * cos(degree), size,
      0, PI * 2, true);
    ctx2d.closePath();
    ctx2d.fill();
  }
}

class CanvasCircle extends Activity {
  List<Ball> balls;

  void onCreate_() {
    title = "Circles";

    canvas = new Canvas();
    canvas.profile.text = "anchor: parent; width: flex; height: flex";
    mainView.addChild(canvas);

    balls = [new Ball(50, 2.0, 6, "red"),
      new Ball(30, 1.3, 6, "blue"),
      new Ball(70, 1.6, 10, "green"),
      new Ball(100, 1.0, 13, "yellow"),
      new Ball(130, 0.8, 8, "#0ff")];

    ctx2d = canvas.context2D;
    new Animator().add((int time, int elapsed) {
      ctx2d.clearRect(0, 0, canvas.width, canvas.height);
      for (final Ball ball in balls)
        ball.updatePosition(time);
      return true;
    });
  }
}

void main() {
  new CanvasCircle().run();
}
