
class Food {
  
  num _x, _y;
  bool redraw = true;
  
  Food(this._x, this._y);
  
  int get x() => _x;
  set x(num value) {
    _x = value;
    redraw = true;
  }
  
  int get y() => _y;
  set y(num value) {
    _y = value;
    redraw = true;
  }
  
  relocate(List<SnakePoint> avoid) {
    
    double suggestedX = Math.random()*39;
    double suggestedY = Math.random()*39;
    
    bool has = false;
    
    for(final point in avoid) {
      if(suggestedX == point.x && suggestedY == point.y) 
        has=true;
    }
    
    if(has)
      return relocate(avoid);
    else {
      x = suggestedX.floor() * 10;
      y = suggestedY.floor() * 10;
    }
  }
  
  draw(CanvasRenderingContext2D context) {
    if(redraw) {
      context.beginPath();
      context.fillStyle = "red";
      context.rect(x, y, 10, 10);
      context.closePath();
      context.fill();
      context.closePath();
      
      redraw = false;
    }
  }
  
  toString() {
    return "x: ${_x} y: ${y}";
  }
}
