

class SnakePoint {
  num x, y;
  
  SnakePoint(this.x, this.y);
  
  toString() {
    return 'x: ${x} y: ${y}';
  }
}

class Snake {
  final int UP = -2, DOWN = 2, LEFT=-1, RIGHT=1;
  int _direction;
  List<SnakePoint> body;
  bool initial = true;
  
  Snake() {
    _direction = RIGHT;
    body = [];
    
    body.addLast(new SnakePoint(10,10));
    body.addLast(new SnakePoint(20,10));
    body.addLast(new SnakePoint(30,10));
  }
  
  int get direction() => _direction;
  
  set direction(int value) {
    if((_direction + value) != 0) {
      _direction = value;
    }
  }
  
  length() {
    return body.length + 1;
  }
  
  head() {
    return body.last();
  }
  
  nextMove() {
    var head = new SnakePoint(body.last().x, body.last().y);
    
    switch(_direction) {
      case UP:
        head.y -= 10;
        break;
      case DOWN:
        head.y += 10;
        break;
      case LEFT:
        head.x -= 10;
        break;
      case RIGHT:
        head.x += 10;
        break;
    }
    
    return head;
  }
  
  move(SnakePoint to, bool grow) {
    var removed = null; 
    
    if(!grow) {
      removed = new SnakePoint(body[0].x, body[0].y);
      body.removeRange(0, 1);
    }
 
    body.add(to);
    
    return removed;
  }
  
  act(CanvasRenderingContext2D context, Food food) {
    
    if(initial) {
      body.forEach((element) => drawSnake(context, element, null));
      initial = false;
      return;
    }
    
    bool grow = false;
    SnakePoint moveTo = nextMove();
    
    if(moveTo.x == food.x && moveTo.y == food.y) {
      grow = true;
    }
    
    var removed = move(moveTo, grow);
    draw(context, removed);
    
    return grow;
  }
  
  draw(CanvasRenderingContext2D context, SnakePoint removed) {    
    drawSnake(context, body.last(), removed);
  }
  
  drawSnake(CanvasRenderingContext2D context, SnakePoint head, SnakePoint removed) {
    context.beginPath();
    context.fillStyle = "blue";
    
    if(removed != null) {
      context.clearRect(removed.x, removed.y, 10, 10);
    }
    
    context.rect(head.x, head.y, 10, 10);
    context.closePath();
    context.fill();
    context.closePath();
  }
}
