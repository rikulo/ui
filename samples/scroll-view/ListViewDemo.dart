//Sample Code: ScrollView

#import('../../client/app/app.dart');
#import('../../client/util/util.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');

class ListViewDemo extends Activity {
  
  void onCreate_() {
    title = "ListView Demo";
    
    ScrollView view;
    view = new ScrollView(direction: Dir.VERTICAL, 
      snap: (Offset off) {
        final num vlimit = 50 * 50 - view.innerHeight;
        final num y = off.y >= vlimit ? vlimit : ((off.y + 25) / 50).floor() * 50;
        return new Offset(off.x, y);
      });
    view.profile.text =
      "location: center center; width: 80%; height: 80%";
    view.classes.add("list-view");

    for (int x = 0; x < 50; ++x) {
      View child = new TextView("Row ${x + 1}");
      
      final int height = 50;
      child.classes.add("list-item");
      child.style.cssText = "line-height: ${height}px";
      child.style.userSelect = "none";
      child.profile.width = "flex";
      child.top = x * height;
      child.height = height;
      
      view.addChild(child);
    }
    
    mainView.addChild(view);
  }
  
}

void main() {
  new ListViewDemo().run();
}
