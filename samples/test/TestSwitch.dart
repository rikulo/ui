//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/model/model.dart');
#import('../../client/event/event.dart');
#import('../../client/util/util.dart');

class TestSwitch extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";

    mainView.addChild(new Switch(true));
    mainView.addChild(new Switch());
  }
}

void main() {
  new TestSwitch().run();
}
