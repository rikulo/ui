//Sample Code: Layout Demostration

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class LinearLayoutDemo extends Activity {

  void onCreate_() {
    title = "Linear Layout Demo";
    mainView.style.backgroundColor = "#cca";

    //make mainView as vlayout
    mainView.layout.type = "linear";
    mainView.layout.orient = "vertical";
    mainView.profile.width = "flex";
    mainView.profile.height = "flex";

    //first hlayout
    View hlayout = new View();
    hlayout.layout.type = "linear";
    hlayout.profile.height = "content";
    hlayout.profile.width = "flex";
    mainView.addChild(hlayout);

    View view = new View();
    view.style.backgroundColor = "blue";
    view.profile.width = "flex";
    view.profile.height = "50";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "orange";
    view.profile.width = "flex 2";
    view.profile.height = "40";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "yellow";
    view.profile.width = "flex 3";
    view.profile.height = "30";
    hlayout.addChild(view);

    //second horizontal layout
    hlayout = new View();
    hlayout.layout.type = "linear";
    hlayout.layout.align = "end";
    hlayout.profile.height = "flex";
    hlayout.profile.width = "flex";
    mainView.addChild(hlayout);

    view = new View();
    view.style.backgroundColor = "yellow";
    view.profile.width = "flex 3";
    view.profile.height = "flex";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "orange";
    view.profile.width = "flex 2";
    view.profile.height = "50%";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "blue";
    view.profile.width = "flex 1";
    view.profile.height = "25%";
    hlayout.addChild(view);

    TextView txt = new TextView("flex 2, 25%");
    txt.style.border = "1px solid #555";
    txt.profile.anchorView = view.previousSibling;
    txt.profile.location = "north center";
    hlayout.addChild(txt);
  }
}

void main() {
  new LinearLayoutDemo().run();
}
