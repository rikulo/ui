//Sample Code: Circles implemented in Canvas

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/html/html.dart');
#import('../../client/view/view.dart');
#import('../../client/effect/effect.dart');
#import('../../client/event/event.dart');

#import('SnakeEnvironment.dart');

CanvasRenderingContext2D ctx2d;
Canvas canvas;
Button up, down, left, right;

class SnakeCanvas extends Activity {
  final int UPDATE = 100;
  final int height = 555, width = 555;
  int lastCycle = 0;
  SnakeEnvironment environment;
  TextView topBar;
  num _score = 0;
  
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
    
    
    up = new Button("Up");
    up.profile.text = "anchor:  canvas;";
    up.on.click.add((ViewEvent event) {
      environment.snake.direction = environment.snake.UP;
    });
    
    down = new Button("Down");
    down.profile.text = "anchor:  canvas;";
    down.on.click.add((ViewEvent event) {
      environment.snake.direction = environment.snake.DOWN;
    });
    
    left = new Button("Left");
    left.profile.text = "anchor:  canvas;";
    left.on.click.add((ViewEvent event) {
      environment.snake.direction = environment.snake.LEFT;
    });
    
    right = new Button("Right");
    right.profile.text = "anchor:  canvas;";
    right.on.click.add((ViewEvent event) {
      environment.snake.direction = environment.snake.RIGHT;
    });
    
    hlayout.addChild(up);
    hlayout.addChild(down);
    hlayout.addChild(left);
    hlayout.addChild(right);
  }
  
  void onEnterDocument_() {
    ctx2d = canvas.context2D;
    new Animator().add((int time, int elapsed) {
      int timeSinceCycle = time - lastCycle;
      bool ret = true;
      
      if(timeSinceCycle > UPDATE) {
        var message = environment.draw(ctx2d);
        
        switch(message) {
          case environment.GAMEOVER:
            ret = false;
            window.alert('GAME OVER!!');
            break;
          case environment.SCORED:
            score += 1;
            break;
        }
        
        lastCycle = time;
      }
      
      return ret;
    });
  }
}

void main() {
  new SnakeCanvas().run();
}
