//Sample Code: Circles

import 'dart:html';
import "dart:math";

import 'package:rikulo/html.dart';
import 'package:rikulo/view.dart';
import 'package:rikulo/effect.dart';

Animator animator;

class Ball {
  final View view;
  int radius, centerX, centerY;
  double speed;

  Ball(int this.radius, double this.speed, int size, String color):
  view = new View() {
    view.style.cssText = "border-radius: ${size}px;border: ${size}px solid $color";
    view.width = view.height = size << 1;
    centerX = (browser.size.width >> 1) - size;
    centerY = (browser.size.height >> 1) - size;
    animator.add((int time) {
      updatePosition(time);
      return true;
    });
  }
  void updatePosition(int time) {
    final double degree = time * speed / 1000;
    view.left = centerX + (radius * sin(degree)).toInt();
    view.top = centerY + (radius * cos(degree)).toInt();
  }
}

void main() {
  animator = new Animator();
  new View()
    ..addChild(new Ball(50, 2.0, 6, "red").view)
    ..addChild(new Ball(30, 1.3, 6, "blue").view)
    ..addChild(new Ball(70, 1.6, 10, "green").view)
    ..addChild(new Ball(100, 1.0, 13, "yellow").view)
    ..addChild(new Ball(130, 0.8, 8, "#0ff").view)
    ..addToDocument();
}
