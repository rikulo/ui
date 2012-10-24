//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 25, 2012  5:00:33 PM
// Author: tomyeh

import 'dart:math';

import 'package:rikulo/view.dart';
import 'package:rikulo/model.dart';

void main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.text = "type: linear; orient: vertical";

  //prepare data
  final DefaultListModel<String> model
  = new DefaultListModel(["apple", "orange", "lemon", "juice"]);
  model.addToSelection("orange");
  model.addToDisables("juice");

  final rg = new RadioGroup();
  mainView.addChild(rg);

  final btn = new Button("test");
  btn.on.click.add((event) {
    rg.model = model;
    mainView.requestLayout(true);
    mainView.addChild(
        new TextView(rg.node.query('input') != null ?
          "Success!":
          "Wrong! requestLayout+immediate shall force model to render immediately"));
    mainView.requestLayout();
  });
  mainView.addChild(btn);
}
