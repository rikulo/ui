//Test Code: TestFreeLayout1

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestFreeLayout1 extends Activity {

  void onCreate_() {
    title = "Test 1: Free Layout";

    mainView.style.backgroundColor = "#cca";

    test1();
}
void test1() {
    View view = new View();
    view.style.backgroundColor = "#ddb";
    view.style.border = "1px solid white";
    view.profile.anchor = "parent";
    view.profile.location = "center center";
    mainView.addChild(view);

    //test if subView will affect its parent's size
    View subView = new View();
    subView.style.backgroundColor = "#eec";
    subView.left = 100;
    subView.top = 10;
    subView.width = 30; //test: direct with
    subView.height = 20;
    view.addChild(subView);

    subView = new View();
    subView.style.backgroundColor = "#eec";
    subView.style.border = "2px solid red";
    subView.left = 10;
    subView.top = 100;
    subView.profile.width = "50"; //test: profile.width
    subView.profile.height = "30";
    view.addChild(subView);

    //it shall be placed inside border
    View subsubView = new View();
    subsubView.style.border = "2px solid blue";
    subsubView.profile.width = subsubView.profile.height = "flex";
    subView.addChild(subsubView);

    //anchored view doesn't affect its parent's size
    subView = new View();
    subView.style.backgroundColor = "#dd8";
    subView.profile.anchor = "parent";
    subView.profile.location = "south start";
    subView.profile.width = "100%";
    subView.profile.height = "15%";
    view.addChild(subView);
  }
}

void main() {
  new TestFreeLayout1().run();
}
