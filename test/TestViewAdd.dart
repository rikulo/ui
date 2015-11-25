//Test Code: TestViewAdd

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/effect.dart';

View block(String text) {
  final View v = new TextView(text);
  v.profile..height = "50"..width = "100";
  v.style..border = "2px solid #111111"
      ..background = "#EEEEEE"..lineHeight = "46px";
  return v;
}

void main() {
  final mainView = new View()..addToDocument();
  
  final View vlayout = new View();
  vlayout.layout.type = "linear";
  vlayout.layout.orient = "vertical";
  vlayout.profile.width = vlayout.profile.height = "content";
  vlayout.style.border = "2px solid #AAAAAA";
  mainView.addChild(vlayout);
  
  final Button btn = new Button("Insert")..profile.width = "100";
  final View v1 = block("Block 1");
  final View v2 = block("Block 2");
  final View v3 = block("Block 3");
  
  vlayout..addChild(btn)..addChild(v1)..addChild(v3);
  
  btn.on.click.listen((event) {
    if (!v2.inDocument) {
      btn.disabled = true;
      v2.style.visibility = "hidden";
      vlayout.addChild(v2, v3);
      vlayout.requestLayout(true);
      new ZoomInEffect(v2.node, end: (MotionState state) {
        btn.text = "Remove";
        btn.disabled = false;
      }).run();
      
    } else {
      btn.disabled = true;
      new ZoomOutEffect(v2.node, end: (MotionState state) {
        v2.remove();
        vlayout.requestLayout(true);
        btn.text = "Insert";
        btn.disabled = false;
      }).run();
      
    }
  });
  
}
