//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/model/model.dart');
#import('../../client/event/event.dart');
#import('../../client/util/util.dart');

class TestDropDownListWithTreeModel extends Activity {

  void onCreate_() {
    mainView.layout.text = "type: linear; orient: vertical";

    //prepare data
    final DefaultTreeModel<String> model = createTreeModel();

    int i = 0;
    Button btn = new Button("add");
    btn.on.click.add((event) {
      model.root.add(new TreeNode("New ${++i}"));
    });
    mainView.addChild(btn);

    //create a drop-down list
    createDropDownList(model)
    .on.select.add((SelectEvent<String> event) {
      printc("DD) $event");
    });;

    //Add the 2nd drop-down list to share the same model
    createDropDownList(model);
  }
  DefaultTreeModel<String> createTreeModel() {
    DefaultTreeModel<String> model = new DefaultTreeModel(nodes: [
      "Wonderland",
      new TreeNode("Australia",
        ["Sydney", "Melbourne", "Port Hedland"]),
      new TreeNode("New Zealand",
        ["Cromwell", "Queenstown"])]);
//    model.addToSelection(model.root[1][2]);
    model.on.select.add((event) {
      printc("Selected: ${model.selection}");
    });
    return model;
  }
  DropDownList createDropDownList(DefaultTreeModel<String> model) {
    final DropDownList ddlist = new DropDownList(model: model);
    mainView.addChild(ddlist);
    return ddlist;
  }
}

void main() {
  new TestDropDownListWithTreeModel().run();
}
