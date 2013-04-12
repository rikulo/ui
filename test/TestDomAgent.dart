//Test Code: TestDomAgent

import 'package:rikulo_ui/view.dart';
import "package:rikulo_commons/html.dart";

void _createText(View parent, String text, [String cssText="", Collection<String> classes]) {
  final View hlayout = new View();
  hlayout.layout.text = "type: linear";
  hlayout.profile.width = "flex";
  parent.addChild(hlayout);

  final TextView textView = new TextView(text);
  textView.style.cssText = cssText;
  if (classes != null)
    for (String c in classes)
      textView.classes.add(c);
  textView.profile.width = "150";
  hlayout.addChild(textView);

  final TextView info = new TextView();
  info.profile.width = "flex";
  hlayout.addChild(info);
}

void main() {
  final View mainView = new View()..addToDocument();
  
  mainView.layout.text = "type: linear; orient: vertical";
  _createText(mainView, "Test Case 1");
  _createText(mainView, "Test Case 2", "font-size: 20px; font-weight: bold;");
  _createText(mainView, "Test Case 3", "font-style: italic; font-size: 9px;", ["v-button"]);

  final Button button = new Button("Measure");
  button.on.click.listen((event) {
    for (TextView textView in mainView.queryAll("TextView:first-child")) {
      final TextView info = textView.nextSibling;
      info.text = "${new DomAgent(textView.node).measureText(textView.text)}";
    }
  });
  mainView.addChild(button);
}
