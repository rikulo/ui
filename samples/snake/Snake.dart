
#import('dart:html');

class Snake {
  final int UP = 0, DOWN = 1, LEFT=2, RIGHT=3;
  int direction;
  Point head;
  List<Point> body;
  
  Snake() {
    direction = RIGHT;
  }
  
  length() {
    return body.length + 1;
  }
  
  move() {
    
  }
}
