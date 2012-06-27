//Test Code: TestLinearLayout1

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestLinearLayout1 extends Activity {

  void onCreate_() {
    title = "Test 1: Horizontal Linear Layout";

    mainView.style.backgroundColor = "#cca";

    test1(mainView, 10, 10);
    test2(mainView, 10, 100);
  }
  void test1(View parent, int left, int top) {
    //case 1: fixed size
    View hlayout = new View();
    hlayout.left = left;
    hlayout.top = top;
    hlayout.style.backgroundColor = "#ddb";
    hlayout.layout.type = "linear";
    //hlayout.layout.orient = "horizontal"; //default
    hlayout.profile.width = hlayout.profile.height = "content";
    parent.addChild(hlayout);

    View view = new View();
    view.style.backgroundColor = "blue";
    view.profile.width = "30"; //test profile.width
    view.height = 50; //test height
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "orange";
    view.width = 50;
    view.profile.height = "40";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "yellow";
    view.width = 70;
    view.height = 30;
    view.profile.align = "end";
    hlayout.addChild(view);
  }
  void test2(View parent, int left, int top) {
    //case 2: flex
    View hlayout = new View();
    hlayout.left = left;
    hlayout.top = top;
    hlayout.style.border = "1px solid #884";
    hlayout.layout.type = "linear";
    hlayout.layout.align = "center";
    hlayout.layout.orient = "horizontal";
    hlayout.layout.spacing = "5 5";
    hlayout.profile.width = "70%";
     //we can't use flex (which implies parent.innerWidth)
     //of course, we can use hlayout to partition but it is not tested here
    hlayout.profile.height = "40"; //..profile.height = "40" is also OK
    parent.addChild(hlayout);

    View view = new View();
    view.style.backgroundColor = "blue";
    view.profile.width = "flex"; //test profile.width
    view.profile.height = "flex";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "orange";
    view.profile.width = "flex 2";
    view.profile.height = "50%";
    hlayout.addChild(view);
    view = new View();
    view.style.backgroundColor = "yellow";
    view.profile.width = "flex 3";
    view.profile.height = "100%";
    hlayout.addChild(view);
  }
}

void main() {
  new TestLinearLayout1().run();
}
