//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/model/model.dart');
#import('../../client/event/event.dart');
#import('../../client/util/util.dart');

class TestRadioGroupModel extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";

    //prepare data
    final DefaultListModel<String> model
      = new DefaultListModel(["apple", "orange", "lemon", "juice"]);
    model.addToSelection("orange");
    model.addToDisables("juice");
    model.on.select.add((event) {
      log("Selected: ${model.selection}");
    });

    //create first radio group
    createRadioGroup(model)
    .on.select.add((SelectEvent<String> event) {
      log("RG) $event");
    });

    Button btn = new Button("toggle multiple");
    btn.on.click.add((event) {
      model.multiple = !model.multiple;
    });
    mainView.addChild(btn);

    btn = new Button("invalidate");
    btn.on.click.add((event) {
      mainView.invalidate();
    });
    mainView.addChild(btn);

    int i = 0;
    btn = new Button("add");
    btn.on.click.add((event) {
      if (i > model.length)
        i = 0;
      model.insertRange(i++, 1, "New $i");
    });
    mainView.addChild(btn);

    //Add the 2nd radio group that share the same model
    createRadioGroup(model);

    //Add the drop-down list that share the same model
    createDropDownList(model)
    .on.select.add((SelectEvent<String> event) {
      log("DD) $event");
    });;
  }
  RadioGroup createRadioGroup(ListModel<String> model) {
    final RadioGroup rg = new RadioGroup(model: model);
    mainView.addChild(rg);
    return rg;
  }
  DropDownList createDropDownList(ListModel<String> model) {
    final DropDownList ddlist = new DropDownList(model: model);
    mainView.addChild(ddlist);
    return ddlist;
  }
}

void main() {
  new TestRadioGroupModel().run();
}
