//Sample Code: Test IDSpace

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_commons/util.dart';

void main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear;orient: vertical";
  Button btn = new Button("Test 1");
  btn.on.click.listen((event) {
    View view = new View();
    view.addChild(new View());
    printc("It shall be empty: ${view.fellows}");
  });
  mainView.addChild(btn);

  btn = new Button("Test 2");
  btn.on.click.listen((event) {
    View v1 = new View(), v2 = new View(), v3 = new View(), v4 = new View();
    v2.addChild(v3);
    v4.id = "v4";
    v2.addChild(v4);
    v3.id = "v3";
    printc("It shall be [v3, v4]: ${v2.fellows}");
    v1.addChild(v2);
    printc("It shall be [v3, v4]: ${v1.fellows}");
  });
  mainView.addChild(btn);
}
