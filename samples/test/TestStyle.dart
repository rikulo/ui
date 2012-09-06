//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class TestStyle extends Activity {

  void onCreate_() {
    final String style1 = '''
.subject {
  border-radius: 6px;
  border: 5px solid #886;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.7);
}
  ''',
      style2 = '''
.subject {
  background-color: #eec;
  border: 1px solid #553;
}
  ''';
    Style style = new Style.fromContent(style1);
    mainView.addChild(style);

    View view = new View();
    view.profile.text =
      "location: center center; width: 80%; height: 80%";
    view.classes.add("subject");
    Button btn = new Button("Click Me!");
    btn.profile.text = "location: center center";
    btn.on.click.add((event) {
      style.content = style.content == style1 ? style2: style1;
    });
    view.addChild(btn);
    mainView.addChild(view);
  }
}

void main() {
  new TestStyle().run();
}
