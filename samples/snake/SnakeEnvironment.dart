
#library('rikulo:samples:snake');

#source('Snake.dart');
#source('Food.dart');

class SnakeEnvironment {
  
  final int SCORED=0, GAMEOVER=1, CONTINUE=2;
  
  num height,width;
  var snake;
  var food;
  
  SnakeEnvironment(this.height, this.width) {
    snake = new Snake();
    food = new Food(260, 260);
  }
  
  draw(CanvasRenderingContext2D context) {
    food.draw(context);
    bool grown = snake.act(context, food);
    
    var head = snake.head();
    if((head.x >= width || head.x < 0)
        || (head.y >= height || head.y < 0)) {
       print('GAME OVER!!');
       return GAMEOVER;
     }
    
    if(grown) {
      print('relocating');
      food.relocate(snake.body);
      return SCORED;
    }
    
    return CONTINUE;
  }
}
