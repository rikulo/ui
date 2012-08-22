//Test Code: TestTileLayout1

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestTileLayout1 extends Activity {

  void onCreate_() {
    title = "Test Tile Layout";

//    mainView.style.backgroundColor = "#cca";
//    mainView.layout.type = "tile";
mainView.layout.type = "linear";
View view = new View();
view.style.backgroundColor = "#cca";
view.layout.type = "tile";
mainView.addChild(view);
  }
}

void main() {
  new TestTileLayout1().run();
}
