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

    mainView.addChild(createSwitch(true));
    mainView.addChild(createSwitch(false));
    mainView.addChild(createSwitch(true, "Yes", "No"));
    mainView.addChild(createSwitch(false, "True", "False"));
    mainView.addChild(createSwitch(true, small: true));
    mainView.addChild(createSwitch(false, small: true));
  }
  Switch createSwitch(bool value, [String onLabel, String offLabel, bool small=false]) {
    Switch view = new Switch(value, onLabel, offLabel);
    if (small)
      view.classes.add("v-small");
    view.on.change.add((event){
      printc("Switch${view.uuid}: ${view.value}");
    });
    return view;
  }
}

void main() {
  new TestSwitch().run();
}
