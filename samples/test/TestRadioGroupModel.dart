//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/model/model.dart');
#import('../../client/util/util.dart');

class TestRadioGroupModel extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";

    final DefaultListModel<String> model
      = new DefaultListModel(["apple", "orange", "lemon"]);
    model.addToSelection("orange");
    final RadioGroup rg = new RadioGroup(model: model);
    rg.on.check.add((event) {
      log("Selected: ${model.selection}");
    });
    rg.layout.text = "type: linear";
    mainView.addChild(rg);

    int i = 0;
    Button btn = new Button("add");
    btn.on.click.add((event) {
      if (i > model.length)
        i = 0;
      model.insertRange(i++, 1, "New $i");
    });
    mainView.addChild(btn);
  }
}

void main() {
  new TestRadioGroupModel().run();
}
