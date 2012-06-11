
class SnakeEnvironment {
  
  static final int SCORED=0, GAMEOVER=1, CONTINUE=2;
  static final num adjustment = 10;
  
  num height,width;
  Snake snake;
  Food food;
  
  SnakeEnvironment(this.height, this.width) {
    
    if((this.height % adjustment != 0) ||
        (this.width % adjustment != 0)) {
      throw new IllegalArgumentException("Height & Width must be divisble by the adjustment (${adjustment}) without a remainder");
    }
    
    snake = new Snake(this);
    food = new Food(this);
    
    food.relocate(snake.body);
  }
  
  int draw(CanvasRenderingContext2D context) {
    food.draw(context);
    bool grown = snake.act(context, food);
    
    var head = snake.head();
    if((head.x >= width || head.x < 0)
        || (head.y >= height || head.y < 0)) {
       return GAMEOVER;
     }
    
    if(grown) {
      food.relocate(snake.body);
      return SCORED;
    }
    
    return CONTINUE;
  }
}
