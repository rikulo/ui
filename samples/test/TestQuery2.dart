//Sample Code: Test Query

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/util/util.dart');
#import('../../client/view/select/select.dart');

class TestQuery2 extends Activity {

  void onCreate_() {
    
    mainView.layout.type = "linear";
    mainView.layout.orient = "vertical";
    
    logMsg("The failed cases are shown below:");
    
    // we are not attaching the following to mainView
    View v0 = apply(new ScrollView(), id: "v0");
    v0.addChild(new Image());
    v0.addChild(new TextBox());
    v0.addChild(new Canvas());
    
    View v1 = apply(new Section(), id: "v1");
    v0.addChild(v1);
    
    v1.addChild(new Image());
    v1.addChild(new TextBox());
    v1.addChild(new Canvas());
    
    View v2 = apply(new ScrollView(), id: "v2");
    v1.addChild(v2);
    
    v2.addChild(new Image());
    v2.addChild(new TextBox());
    v2.addChild(new Canvas());
    v2.addChild(new TextBox());
    v2.addChild(new Image());
    
    assertQueryCount(v0, "ScrollView TextBox", 4);
    assertQueryCount(v0, "ScrollView > TextBox", 3);
    assertQueryCount(v0, "Image + TextBox", 3);
    assertQueryCount(v0, "Image ~ TextBox", 4);
    assertQueryCount(v0, "TextBox ~ TextBox", 1);
    assertQueryCount(v0, "#v1 TextBox", 3);
    assertQueryCount(v0, "#v1 #v2", 1);
    assertQueryCount(v0, "*", 14);
    assertQueryCount(v0, "* ScrollView", 1);
    assertQueryCount(v0, "#v1 > *", v1.childCount);
    assertQueryCount(v0, "#v2", 0); // because of id space
    assertQueryCount(v0, "#v1 #v2 Image", 2);
    assertQueryCount(v0, "#v1 > #v2 Image", 2);
    assertQueryCount(v0, "Section > TextBox, Canvas + TextBox", 2);
    assertQueryCount(v0, "ScrollView:first-child", 1);
    assertQueryCount(v0, "Image:last-child", 1);
    
  }
  
  void assertQueryCount(View v, String selector, int count) {
    int c = countQuery(v, selector);
    if (c != count)
      logMsg("${selector}: ${c} (expecting ${count})");
  }
  
  void logMsg(String msg) {
    mainView.addChild(new TextView(msg));
  }
  
}

View apply(View v, [String id, List<String> cls]) {
  if (id != null)
    v.id = id;
  if (cls != null)
    v.classes.addAll(cls);
  return v;
}

int countQuery(View v, String selector) {
  int s = 0;
  for (View q in v.queryAll(selector))
    s++;
  return s;
}

void main() {
  new TestQuery2().run();
}
