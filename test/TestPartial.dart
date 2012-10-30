//Sample Code: activity is just a part of whole HTML page

import 'package:rikulo/view.dart';

void main() {
  TextView welcome = new TextView.fromHTML("<h1>Click Me</h1>");
  welcome.profile.text = "location: center center";
  welcome.on.click.add((event) {
    TextView dlg = new TextView.fromHTML('<ul><li>Dialog Popup</li><li>center center</li></ul>');
    dlg.classes.add("v-dialog");
    dlg.addToDocument(mode: "dialog");
    dlg.on.click.add((e) {
      dlg.remove();
    });
  });
  new View()..addChild(welcome)..addToDocument();
}
