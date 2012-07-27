//Sample Code: Circles implemented in Canvas

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/effect/effect.dart');
#import('../../client/event/event.dart');

#source('SnakePoint.dart');
#source('SnakeEnvironment.dart');
#source('Food.dart');
#source('Snake.dart');

class SnakeCanvas extends Activity {
  final int UPDATE = 100;
  final int height = 250, width = 400;
  
  int lastCycle = 0;
  SnakeEnvironment environment;
  TextView scoreBar;
  num _score = 0;
  
  //UI elements
  CanvasRenderingContext2D ctx2d;
  Canvas canvas;
  Button up, down, left, right;
  
  num get score() => _score;
  set score(num score) {
    _score = score;
    scoreBar.text = "Your score is: ${score}";
  }
  
  void onCreate_() {
    title = "Snake";

    mainView.width = 572;
    mainView.height = 396;
    mainView.style.backgroundImage = "url('http://blog.rikulo.org/static/files/tutorial/creating-snake/res/snake_bg.png')";
    
    //first vlayout
    View vlayout = new View();
    vlayout.layout.type = "linear";
    vlayout.layout.orient = "vertical";
    vlayout.profile.anchorView = mainView;   
    vlayout.profile.location = "center center";
    
    //canvas
    canvas = new Canvas();
    canvas.profile.text = "width: ${width}; height: ${height}";
    canvas.style.border = "1px solid black";
    vlayout.addChild(canvas);
    
    scoreBar = new TextView("Your score is: ${score}");
    scoreBar.profile.width = "flex";
    scoreBar.profile.height = "30";
    vlayout.addChild(scoreBar);
    
    mainView.addChild(vlayout);

    ctx2d = canvas.context2D;

    new DragGesture(this.canvas.node, move: _gestureMove(), end: _gestureEnd());
    
    document.on.keyDown.add(onKeyDown);
    startGame();
  }

  DragGestureMove _gestureMove() {
    return (DragGestureState state) {

      final int MINIMUM_DRAG_LENGTH = 5;

      if(state.delta.x.abs() > state.delta.y.abs() && 
         state.delta.x.abs() > MINIMUM_DRAG_LENGTH) {
        //horizontal swipe
        state.delta.x > 0 ? 
          environment.snake.direction = Snake.RIGHT :
          environment.snake.direction = Snake.LEFT;

      } else if(state.delta.y.abs() > MINIMUM_DRAG_LENGTH) {
        //vertical swipe
        state.delta.y > 0 ?
          environment.snake.direction = Snake.DOWN :
          environment.snake.direction = Snake.UP;

      }

      return true;
    };
  }

  DragGestureMove _gestureEnd() {
    return (DragGestureState state) {
      return true;
    };
  }
  
  void startGame() {

    score = 0;

    environment = new SnakeEnvironment(height,width);

    new Animator().add((int time, int elapsed) {
      int timeSinceCycle = time - lastCycle;
      bool ret = true;
      
      if(timeSinceCycle > UPDATE) {
        int message = environment.draw(ctx2d);
        
        switch(message) {
          case SnakeEnvironment.GAMEOVER:
            ret = false;
            gameOverDialog();
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

  void gameOverDialog() {
    View dlg = new TextView("Game Over, your score was ${score}");
    dlg.style.cssText = "text-align: center; padding-top: 20px";
    dlg.profile.text = "location: center center;width:30%;height:20%";
    dlg.classes.add("v-dialog");
    dlg.on.click.add((e) {
      removeDialog();
      
      //reset the canvas
      ctx2d.save();
      ctx2d.setTransform(1,0,0,1,0,0);
      ctx2d.clearRect(0, 0, canvas.width, canvas.height);
      ctx2d.restore();
      
      startGame();
    });
    
    addDialog(dlg);
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
