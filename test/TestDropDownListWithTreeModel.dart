//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/model.dart';
import 'package:rikulo_ui/event.dart';

DefaultTreeModel<String> createTreeModel() {
  DefaultTreeModel<String> model = new DefaultTreeModel(nodes: [
    "Wonderland",
    new DefaultTreeNode("Australia",
      ["Sydney", "Melbourne", "Port Hedland"]),
      new DefaultTreeNode("New Zealand",
      ["Cromwell", "Queenstown"])]);
//    model.addToSelection(model.root[1][2]);
  model.on.select.listen((event) {
    printc("Selected: ${model.selection}");
  });
  return model;
}
DropDownList createDropDownList(View parent, DefaultTreeModel<String> model) {
  final ddlist = new DropDownList(model: model);
  parent.addChild(ddlist);
  return ddlist;
}

void main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear; orient: vertical";

  //prepare data
  final DefaultTreeModel<String> model = createTreeModel();

  int i = 0;
  Button btn = new Button("add");
  btn.on.click.listen((event) {
    model.root.add(new DefaultTreeNode("New ${++i}"));
  });
  mainView.addChild(btn);

  //create a drop-down list
  createDropDownList(mainView, model)
  .on.select.listen((SelectEvent<String> event) {
    printc("DD) $event");
  });;

  //Add the 2nd drop-down list to share the same model
  final d2 = createDropDownList(mainView, model);
  mainView.addChild(new Button('clear')..on.click.listen((e) {d2.model =  null;}));
}
