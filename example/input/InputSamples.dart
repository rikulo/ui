//Sample Code: Input Samples

import 'package:rikulo_ui/view.dart';

void main() {
  final View mainView = new View()
    ..layout.text = "type: linear; orient: vertical"
    ..addToDocument();
  
  for(final String type in ["text", "password", "multiline", "tel", "date", "color"]) {
    mainView.addChild(new View()
      ..layout.text = "type: linear; align: center; spacing: 0 4"
      ..profile.width = "flex"
      ..addChild(new TextView(type) //label
        ..style.textAlign = "right"
        ..profile.width = "70"
      )
      ..addChild( (type == "multiline" ? new TextArea(): new TextBox(null, type))
        ..on.change.listen((event) {
          var input = event.target;
          TextView inf = input.nextSibling;
          inf.text = (input as Input).value;
        }))
      ..addChild(new TextView() //result
          ..profile.text = "width: flex; height: flex"
      )
    );
  }
}
