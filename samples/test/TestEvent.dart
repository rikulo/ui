//Sample Code: Test Animation

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');

View createCube(int size, String txt, String desc) {
  View v = new View();
  v.width = size;
  v.height = size;
  v.style.border = "2px solid #3D4C99";
  v.style.borderRadius = "10px";
  v.style.backgroundColor = "#5C73E5";
  v.style.userSelect = "none";
  v.style.zIndex = "10";
  
  TextView txtv = new TextView(txt);
  txtv.width = size - 4;
  txtv.style.lineHeight = "${size - 4}px";
  txtv.style.textAlign = "center";
  txtv.style.color = "#EEEEEE";
  txtv.style.fontFamily = "Arial";
  txtv.style.fontWeight = "bold";
  txtv.style.userSelect = "none";
  v.addChild(txtv);
  
  if (desc != null) {
    TextView descv = new TextView(desc);
    descv.profile.anchor = "parent";
    descv.profile.location = "south center";
    descv.style.color = "#333333";
    descv.style.fontStyle = "italic";
    v.addChild(descv);
  }
  
  return v;
}

class TestEvent extends Activity {
  
  void log_(String msg) {
    print(msg);
    printc(msg);
  }
  
  void onCreate_() {
    View cube1 = createCube(100, "Cube 1", "Click, Mouse Up/Down/Over/Out");
    cube1.left = 100;
    cube1.top = 100;
    mainView.addChild(cube1);
    
    cube1.on.click.add((ViewEvent event) {
      log_("Mouse Click");
    });
    cube1.on.mouseDown.add((ViewEvent event) {
      log_("Mouse Down");
    });
    cube1.on.mouseUp.add((ViewEvent event) {
      log_("Mouse Up");
    });
    cube1.on.mouseOver.add((ViewEvent event) {
      log_("Mouse Over");
    });
    cube1.on.mouseOut.add((ViewEvent event) {
      log_("Mouse Out");
    });
    
    View cube2 = createCube(100, "Cube 2", "Mouse Move/Wheel");
    cube2.left = 300;
    cube2.top = 100;
    mainView.addChild(cube2);
    
    cube2.on.mouseMove.add((ViewEvent event) {
      log_("Mouse Move");
    });
    cube2.on.mouseWheel.add((ViewEvent event) {
      log_("Mouse Wheel");
    });
    
    View cube3 = createCube(100, "", "Focus/Blur");
    cube3.left = 100;
    cube3.top = 300;
    mainView.addChild(cube3);
    TextBox input = new TextBox();
    input.width = 50;
    input.profile.anchor = "parent";
    input.profile.location = "center center";
    cube3.addChild(input);
    
    input.on.focus.add((ViewEvent event) {
      log_("Focus");
    });
    input.on.blur.add((ViewEvent event) {
      log_("Blur");
    });
    
  }
  
}

void main() {
  new TestEvent().run();
}
