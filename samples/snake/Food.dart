#library('rikulo:samples:snake');

#import('dart:html');

#import('SnakePoint.dart');
#import('SnakeEnvironment.dart');

class Food {
  
  int _x, _y;
  bool redraw = true;
  SnakeEnvironment snakeEnvironment;
  
  Food(this.snakeEnvironment);
  
  num get x() => _x;
  set x(num value) {
    _x = value;
    redraw = true;
  }
  
  num get y() => _y;
  set y(num value) {
    _y = value;
    redraw = true;
  }
  
  relocate(List<SnakePoint> avoid) {
    
    double suggestedX = Math.random()*((snakeEnvironment.width / snakeEnvironment.adjustment) - 1);
    double suggestedY = Math.random()*((snakeEnvironment.height / snakeEnvironment.adjustment) - 1);
    
    suggestedX = suggestedX.floor() * snakeEnvironment.adjustment;
    suggestedY = suggestedY.floor() * snakeEnvironment.adjustment;
    
    bool has = false;
    
    for(final point in avoid) {
      if(suggestedX == point.x && suggestedY == point.y) 
        has=true;
    }
    
    if(has)
      return relocate(avoid);
    else {
      x = suggestedX;
      y = suggestedY;
      
      print("relocated ${this}");
    }
  }
  
  draw(CanvasRenderingContext2D context) {
    num adjustment = snakeEnvironment.adjustment;
    
    context.beginPath();
    context.fillStyle = "red";
    context.rect(_x, _y, adjustment, adjustment);
    context.fill();
    context.closePath();
  }
  
  toString() {
    return "x: ${_x} y: ${_y}";
  }
}
