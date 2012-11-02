//Sample Code: Input Samples

import 'package:rikulo/view.dart';

void main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear; orient: vertical";

  for (final String type in
  ["text", "password", "multiline", "number", "tel", "date", "color"]) {
    View view = new View();
    view.layout.text = "type: linear; align: center; spacing: 0 3";
    view.profile.width = "flex";
    mainView.addChild(view);

    TextView label = new TextView(type);
    label.style.textAlign = "right";
    label.profile.width = "70";
    view.addChild(label);

    var input = type == "multiline" ? new MultilineBox(): new TextBox(null, type);
    input.on.change.add((event) {
      TextView inf = input.nextSibling;
      inf.text = input.value;
    });
    view.addChild(input);

    label = new TextView();
    label.profile.text = "width: flex; height: flex";
    view.addChild(label);
  }
}
