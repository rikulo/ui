//Test Code: TestDialog

import 'package:rikulo/view.dart';

void main() {
  Button btn = new Button("Open a dialog");
  btn.profile.location = "center left";
  btn.on.click.add((event) {
    final dialog = new View()
      ..classes.add("v-dialog")
      ..layout.text = "type: linear; orient: vertical"
      ..profile.text = "width:120; height:60";
    dialog
      ..addChild(
        new TextView.fromHTML("<b>Delete this file?</b>"))
      ..addChild(
        new View()
          ..layout.text = "type: linear"
          ..addChild(
          new Button("Yes")
            ..on.click.add((event) { //delete
              //removeFile(); //assume you have this method
              dialog.remove();
            }))
          ..addChild(
          new Button("No")
            ..on.click.add((event) { //cancel
              dialog.remove();
            })))
      ..addToDocument(mode: "dialog");
  });
  new View()..addChild(btn)..addToDocument();
}
