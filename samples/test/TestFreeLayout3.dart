//Sample Code: Layout Demostration

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestFreeLayout3 extends Activity {

  void onCreate_() {
    title = "Free Layout Demo";

    mainView.style.backgroundColor = "#cca";

    View view = new ScrollView();
    view.style.backgroundColor = "#ddb";
    view.profile.anchor = "parent";
    view.profile.location = "center center";
    view.profile.width = "70%";
    view.profile.height = "80%";
    addContent(view); //to make it larger
    mainView.addChild(view);

    //1. first level dependence (anchor children)
    addLocations(view, view, "inner");

    //3. anchor siblings
//    addLocations(view, mainView, "outer");
  }
  void addLocations(View anchor, View parent, String prefix) {
    for (final String loc in [
    "north start", "north center", "north end",
    "south start", "south center", "south end",
    "west start", "west center", "west end",
    "east start", "east center", "east end",
    "top left", "top center", "top right",
    "center left", "center center", "center right",
    "bottom left", "bottom center", "bottom right"]) {
      TextView txt = new TextView("$prefix $loc");
      txt.style.border = "1px solid #555";
      txt.profile.anchorView = anchor;
      txt.profile.location = loc;
      parent.addChild(txt);
    }
  }
  void addContent(View parent) {
    View v = new View();
    v.width = v.height = 2000;
    TextView t = new TextView("Hi this is a grandchild of scroll view");
    t.left = t.top = 20;
    v.addChild(t);
    t = new TextView("Another grandchild of scroll view");
    t.left = t.top = 50;
    v.addChild(t);
    parent.addChild(v);
  }
}

void main() {
  new TestFreeLayout3().run();
}
