//Sample Code: Circles implemented in Canvas

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/html/html.dart');
#import('../../client/view/view.dart');
#import('../../client/effect/effect.dart');
#import('../../client/event/event.dart');

#source('SnakePoint.dart');
#source('SnakeEnvironment.dart');
#source('Food.dart');
#source('Snake.dart');

class SnakeCanvas extends Activity {
  final int UPDATE = 100;
  final int height = 400, width = 400;
  
  int lastCycle = 0;
  SnakeEnvironment environment;
  TextView topBar;
  num _score = 0;
  
  //UI elements
  CanvasRenderingContext2D ctx2d;
  Canvas canvas;
  Button up, down, left, right;
  
  num get score() => _score;
  set score(num score) {
    _score = score;
    topBar.text = "Your score is: ${score}";
  }
  
  void onCreate_() {
    title = "Circles";
    
    environment = new SnakeEnvironment(height,width);
    
    //make rootView as vlayout
    mainView.layout.type = "linear";
    mainView.layout.orient = "vertical";
    mainView.profile.width = "flex";
    mainView.profile.height = "flex";
    
    topBar = new TextView("Your score is: ${score}");
    topBar.profile.width = "flex";
    topBar.profile.height = "30";
    mainView.addChild(topBar);
        
    //canvas
    canvas = new Canvas();
    canvas.profile.text = "width: ${width}; height: ${height}";
    canvas.style.border = "1px solid blue";
    mainView.addChild(canvas);
    
    //first hlayout
    View hlayout = new View();
    hlayout.layout.type = "linear";
    hlayout.profile.height = "content";
    hlayout.profile.width = "flex";
    mainView.addChild(hlayout);
  }

  DragGestureMove _gestureMove() {
    return (DragGestureState state) {
      return true;
    };
  }

  DragGestureMove _gestureEnd() {
    return (DragGestureState state) {
      if(state.delta.x.abs() > state.delta.y.abs()) {
        //horizontal swipe
        state.delta.x > 0 ? 
          environment.snake.direction = Snake.RIGHT :
          environment.snake.direction = Snake.LEFT;

      } else {
        //vertical swipe
        state.delta.y > 0 ?
          environment.snake.direction = Snake.DOWN :
          environment.snake.direction = Snake.UP;

      }

      return true;
    };
  }
  
  void onEnterDocument_() {
    ctx2d = canvas.context2D;

    new DragGesture(this.canvas.node, moving: _gestureMove(), end: _gestureEnd());
    
    document.on.keyDown.add(onKeyDown);

    new Animator().add((int time, int elapsed) {
      int timeSinceCycle = time - lastCycle;
      bool ret = true;
      
      if(timeSinceCycle > UPDATE) {
        int message = environment.draw(ctx2d);
        
        switch(message) {
          case SnakeEnvironment.GAMEOVER:
            ret = false;
            window.alert('GAME OVER!! Your score was ${score}');
            break;
          case SnakeEnvironment.SCORED:
            score += 1;
            break;
        }
        
        lastCycle = time;
      }
      
      return ret;
    });
  }

  void onKeyDown(KeyboardEvent event) {
    if(event.keyCode == 37)
      environment.snake.direction = Snake.LEFT;
    else if(event.keyCode == 39)
      environment.snake.direction = Snake.RIGHT;
    else if(event.keyCode == 38)
      environment.snake.direction = Snake.UP;
    else if(event.keyCode == 40)
      environment.snake.direction = Snake.DOWN;
  }
}

void main() {
  new SnakeCanvas().run();
}
