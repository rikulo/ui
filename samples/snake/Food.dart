
class Food {
  
  int _x, _y;
  bool redraw = true;
  SnakeEnvironment snakeEnvironment;
  
  Food(this.snakeEnvironment);
  
  int get x() => _x;
  set x(int value) {
    _x = value;
    redraw = true;
  }
  
  int get y() => _y;
  set y(int value) {
    _y = value;
    redraw = true;
  }
  
  void relocate(List<SnakePoint> avoid) {
    
    double suggestedX = Math.random()*((snakeEnvironment.width / SnakeEnvironment.adjustment) - 1);
    double suggestedY = Math.random()*((snakeEnvironment.height / SnakeEnvironment.adjustment) - 1);
    
    suggestedX = suggestedX.floor() * SnakeEnvironment.adjustment;
    suggestedY = suggestedY.floor() * SnakeEnvironment.adjustment;
    
    bool has = false;
    
    for(final point in avoid) {
      if(suggestedX == point.x && suggestedY == point.y) { 
        has=true;
        break;
      }
    }
    
    if(has)
      relocate(avoid);
    else {
      x = suggestedX.toInt();
      y = suggestedY.toInt();
    }
  }
  
  void draw(CanvasRenderingContext2D context) {
    context.beginPath();
    context.fillStyle = "red";
    context.rect(_x, _y, SnakeEnvironment.adjustment, SnakeEnvironment.adjustment);
    context.fill();
    context.closePath();
  }
  
  String toString() {
    return "$_x, $_y";
  }
}
