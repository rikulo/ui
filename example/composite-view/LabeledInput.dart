//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jul 24, 2012 12:47:44 PM
// Author: tomyeh
library rikulo_example_compositeView;

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/event.dart';

/**
 * A composite view consisting of a label ([TextView]) and an input ([TextBox]).
 */
class LabeledInput extends View {
  TextView _label;
  TextBox _input;

  LabeledInput(String label, [String value]) {
    layout.type = "linear"; //use horizontal linear layout
    addChild(_label = new TextView(label));
    addChild(_input = new TextBox(value));

    _input.on.change.listen((ChangeEvent event) {
      sendEvent(new ChangeEvent(event.value, "change", this));
      });
  }
  String get label => _label.text;
  void set label(String label) {
    _label.text = label;
  }
  String get value => _input.value;
  void set value(String value) {
    _input.value = value;
  }
  String get className => "LabeledInput";
}
