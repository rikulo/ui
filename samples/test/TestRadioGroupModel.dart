//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/model/model.dart');

class TestRadioGroupModel extends Activity {

  void onCreate_() {
    final ListModel<String> model = new ListModel(["apple", "orange", "lemon"]);
    final RadioGroup rg = new RadioGroup(model: model);
    rg.layout.text = "type: linear";
    mainView.addChild(rg);
  }
}

void main() {
  new TestRadioGroupModel().run();
}
