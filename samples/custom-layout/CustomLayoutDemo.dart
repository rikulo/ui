//Sample Code: Custom Layout Demo

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');

class CustomLayoutDemo extends Activity {
  View anchor;

  void onCreate_() {
    title = "Custom Layout Demo";

    TextView text = new TextView("Touch Anywhere You like");
    text.profile.text = "location: center center";
    mainView.addChild(text);
    mainView.on.click.add((ViewEvent event) {
      if (anchor == null)
        _createViews();
      _move(event.offset.left, event.offset.top);
    });
  }
  void _move(int left, int top) {
    anchor.left = left - 35;
    anchor.top = top - 35;
    anchor.requestLayout(descendantOnly: true); //only views that depend on anchor (excluding anchor)
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
