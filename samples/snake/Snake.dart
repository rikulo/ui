
class Snake {
  static final int UP = -2, DOWN = 2, LEFT=-1, RIGHT=1;
  
  int _direction;
  List<SnakePoint> body;
  bool initial = true;
  SnakeEnvironment snakeEnvironment;
  
  Snake(this.snakeEnvironment) {
    _direction = RIGHT;
    body = [];
    
    for(num i =0; i<3; i++) {
      body.addLast(new SnakePoint(i * SnakeEnvironment.adjustment,0));
    }
  }
  
  int get direction() => _direction;
  
  set direction(int value) {
    if((_direction + value) != 0) {
      _direction = value;
    }
  }
  
  int length() {
    return body.length;
  }
  
  SnakePoint head() {
    return body.last();
  }
  
  SnakePoint nextMove() {
    var snakeHead = new SnakePoint(head().x, head().y);
    num adjustment = SnakeEnvironment.adjustment;
    
    switch(_direction) {
      case UP:
        snakeHead.y -= adjustment;
        break;
      case DOWN:
        snakeHead.y += adjustment;
        break;
      case LEFT:
        snakeHead.x -= adjustment;
        break;
      case RIGHT:
        snakeHead.x += adjustment;
        break;
    }
    
    return snakeHead;
  }
  
  SnakePoint move(SnakePoint to, bool grow) {
    var removed = null; 
    
    if(!grow) {
      removed = body[0];
      body.removeRange(0, 1);
    }
 
    body.add(to);
    
    return removed;
  }
  
  bool act(CanvasRenderingContext2D context, Food food) {
    
    if(initial) {
      body.forEach((element) => drawSnake(context, element, null));
      initial = false;
      return false;
    }
    
    SnakePoint moveTo = nextMove();
    bool grow = (moveTo.x == food.x && 
                 moveTo.y == food.y);
    
    var removed = move(moveTo, grow);
    draw(context, removed);
    
    return grow;
  }
  
  void draw(CanvasRenderingContext2D context, SnakePoint removed) {    
    drawSnake(context, body.last(), removed);
  }
  
  void drawSnake(CanvasRenderingContext2D context, SnakePoint point, SnakePoint removed) {
    context.beginPath();
    context.fillStyle = "black";

    num adjustment = SnakeEnvironment.adjustment;

    if(removed != null) {
        context.clearRect(removed.x, removed.y, adjustment, adjustment);
    }

    int width = SnakeEnvironment.adjustment;
    int height = SnakeEnvironment.adjustment;
    int radius = SnakeEnvironment.adjustment ~/ 3;

    context.beginPath();
    context.moveTo(point.x + radius, point.y);
    context.lineTo(point.x + width - radius, point.y);
    context.quadraticCurveTo(point.x + width, point.y, point.x + width, 
                             point.y + radius);
    context.lineTo(point.x + width, point.y + height - radius);
    context.quadraticCurveTo(point.x + width, point.y + height, 
                             point.x + width - radius, point.y + height);
    context.lineTo(point.x + radius, point.y + height);
    context.quadraticCurveTo(point.x, point.y + height, point.x, 
                             point.y + height - radius);
    context.lineTo(point.x, point.y + radius);
    context.quadraticCurveTo(point.x, point.y, point.x + radius, point.y);
    context.closePath();
    context.fill();
  }
}
