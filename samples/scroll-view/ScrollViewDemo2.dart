//Sample Code: ScrollView

#import('../../client/app/app.dart');
#import('../../client/util/util.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');

class ScrollViewDemo2 extends Activity {
  
  void onCreate_() {
    title = "ScrollView Demo";
    
    ScrollView view;
    view = new ScrollView(direction: Dir.VERTICAL, 
      snap: (Offset off) {
        final num vlimit = 50 * 50 - view.innerHeight;
        final num y = off.y >= vlimit ? vlimit : ((off.y + 25) / 50).floor() * 50;
        return new Offset(off.x, y);
      });
    view.profile.text =
      "anchor: parent; location: center center; width: 80%; height: 80%";
    view.classes.add("scroll-view");

    for (int x = 0; x < 50; ++x) {
      View child = new View();
      TextView txtv = new TextView("Row $x");
      
      final String color = CSS.color(250 - x * 4, 250, 200);
      child.style.cssText = "border: 1px solid #AAAAAA; background-color: #FFFFFF; color: #111111; width: 100%; line-height: 50px";
      child.style.userSelect = "none";
      child.profile.width = "flex";
      child.top = x * 50;
      child.height = 50;
      
      child.addChild(txtv);
      view.addChild(child);
    }
    
    mainView.addChild(view);
  }
  
}

void main() {
  new ScrollViewDemo2().run();
}
