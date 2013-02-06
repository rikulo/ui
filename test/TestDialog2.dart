//Test Code: TestDialog

import 'package:rikulo_ui/view.dart';

void main() {
  Button btn = new Button("Open a dialog");
  btn.profile.location = "center left";
  btn.on.click.listen((event) {
    final dialog = new View()
      ..classes.add("v-dialog")
      ..layout.text = "type: linear; orient: vertical"
      ..profile.text = "width:120; height:60";
    dialog
      ..addChild(
        new TextView.fromHtml("<b>Delete this file?</b>"))
      ..addChild(
        new View()
          ..layout.text = "type: linear"
          ..addChild(
          new Button("Yes")
            ..on.click.listen((event) { //delete
              //removeFile(); //assume you have this method
              dialog.remove();
            }))
          ..addChild(
          new Button("No")
            ..on.click.listen((event) { //cancel
              dialog.remove();
            })))
      ..addToDocument(mode: "dialog");
  });
  new View()..addChild(btn)..addToDocument();
}
