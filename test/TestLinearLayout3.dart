//Test Code: TestLinearLayout3

import 'package:rikulo_ui/view.dart';

void test1(View parent) {
  View hlayout = new View();
  hlayout.style.backgroundColor = "#ddb";
  hlayout.layout.type = "linear";
  parent.addChild(hlayout);

  TextView view = new TextView("Cyan");
  view.style.backgroundColor = "cyan";
  hlayout.addChild(view);
  view = new TextView("Orange");
  view.style.backgroundColor = "orange";
  hlayout.addChild(view);
  view = new TextView("Yellow");
  view.style.backgroundColor = "yellow";
  view.profile.align = "end";
  hlayout.addChild(view);
}

void main() {
  final View mainView = new View()..addToDocument();
  mainView.style.backgroundColor = "#cca";

  View vlayout = new View();
  vlayout.layout.text = "type: linear; orient: vertical";
  vlayout.style.backgroundColor = "white";
  mainView.addChild(vlayout);
  test1(vlayout);
  test1(vlayout);

  Button btn = new Button("Change text");
  btn.on.click.listen((event) {
    for (TextView v in vlayout.queryAll("TextView"))
      v.text = "${v.text} click";
    vlayout.requestLayout();
  });
  vlayout.addChild(btn);
}
