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
    final SelectableListModel<String> model
      = new SelectableListModel(["apple", "orange", "lemon"]);
    model.addToSelection("orange");
    final RadioGroup rg = new RadioGroup(model: model);
    rg.on.check.add((event) {
      log("Selected: ${model.selection}");
    });
    rg.layout.text = "type: linear";
    mainView.addChild(rg);
  }
}

void main() {
  new TestRadioGroupModel().run();
}
