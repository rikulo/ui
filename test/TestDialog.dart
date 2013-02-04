//Test Code: TestDialog

import 'package:rikulo/view.dart';
import 'package:rikulo_commons/util.dart';

void main() {
  final mainView = new View()..addToDocument();

  Button btn = new Button("Open a dialog");
  btn.profile.location = "center left";
  btn.on.click.listen((event) {
    View dlg = new TextView("Clicked me to close");
    dlg.style.cssText = "text-align: center; padding-top: 20px";
    dlg.profile.text = "width:30%;height:20%";
    dlg.classes.add("v-dialog");
    dlg.on.click.listen((e) {
      dlg.remove();
    });
    dlg.addToDocument(mode: "dialog");
  });
  mainView.addChild(btn);

//  mainView.addChild(
//    new TextView.fromHtml("<b>This is used to make scrollbar visible</b>")
//      ..top = 1200);
}
