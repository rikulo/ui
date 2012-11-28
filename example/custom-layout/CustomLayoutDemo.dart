//Sample Code: Custom Layout Demo

import 'package:rikulo/view.dart';
import 'package:rikulo/event.dart';
import 'package:rikulo/util.dart';
import 'package:rikulo/html.dart';

class CustomLayoutDemo {
  View anchor, mainView;

  void run() {
    mainView = new View()..addToDocument();

    TextView text = new TextView("Touch Anywhere You like");
    text.profile.text = "location: center center";
    mainView.addChild(text);
    mainView.on.click.add((DOMEvent event) {
      if (anchor == null)
        _createViews();
      _move(event.pageOffset - new DomAgent(mainView.node).pageOffset);
    });
  }
  void _move(Offset offset) {
    anchor.left = offset.left - 35;
    anchor.top = offset.top - 35;
    anchor.requestLayout(false, true); //only views that depend on anchor (excluding anchor)
  }

  void _createViews() {
    anchor = _createTextView("Anchor", "#0ff");
    mainView.addChild(anchor);

    final View red = _createTextView("Mobile", "red");
    anchor.on.layout.add((event) {
      red.left = anchor.left + anchor.width;
      red.top = anchor.top - anchor.height;
    });
    mainView.addChild(red);

    final View green = _createTextView("Web", "yellow");
    anchor.on.layout.add((event) {
      green.left = anchor.left + anchor.width * 2;
      green.top = anchor.top;
    });
    mainView.addChild(green);
  }
  TextView _createTextView(String label, String color)  {
    final TextView text = new TextView(label);
    text.width = text.height = 70;
    text.style.cssText = "background: $color; border: 1px solid black; text-align: center; line-height: 68px";
    return text;
  }
}


void main() {
  new CustomLayoutDemo().run();
}
