
#library('rikulo:samples:snake');

#import('dart:html');

#import('Snake.dart');
#import('Food.dart');

class SnakeEnvironment {
  
  final int SCORED=0, GAMEOVER=1, CONTINUE=2;
  
  num height,width;
  final num adjustment = 10;
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
  
  draw(CanvasRenderingContext2D context) {
    food.draw(context);
    bool grown = snake.act(context, food);
    
    var head = snake.head();
    if((head.x >= width || head.x < 0)
        || (head.y >= height || head.y < 0)) {
       window.alert('GAME OVER!!');
       return GAMEOVER;
     }
    
    if(grown) {
      food.relocate(snake.body);
      return SCORED;
    }
    
    return CONTINUE;
  }
}
