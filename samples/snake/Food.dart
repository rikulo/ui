
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
    double smallSquareWidthAndHeight = SnakeEnvironment.adjustment / 3;

    context.beginPath();
    context.fillStyle = "black";

    //first rectangle, top row
    context.rect(_x + smallSquareWidthAndHeight, _y, smallSquareWidthAndHeight, smallSquareWidthAndHeight);

    //two rectangles second row
    context.rect(_x, _y + smallSquareWidthAndHeight, smallSquareWidthAndHeight, smallSquareWidthAndHeight);
    context.rect(_x + (smallSquareWidthAndHeight * 2), _y + smallSquareWidthAndHeight, smallSquareWidthAndHeight, smallSquareWidthAndHeight);

    //bottom row rectangle
    context.rect(_x + smallSquareWidthAndHeight, _y + (smallSquareWidthAndHeight * 2), smallSquareWidthAndHeight, smallSquareWidthAndHeight);

    context.closePath();
    context.fill();
  }
  
  String toString() {
    return "$_x, $_y";
  }
}
