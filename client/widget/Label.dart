//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
#library("dargate:widget:Label");

#import("Widget.dart");
#import("Skipper.dart");

/** A label.
 */
class Label extends Widget {
  String _value;

  Label([String value=""]) {
    wclass = "w-label";
    this.value = value;
  }
  Label.from(Map<String, Object> props): super.from(props);

  String get value() => _value;
  void set value(String value) {
    _value = value != null ? value: "";
  }
  String get encodedText() => _value; //TODO

  void redraw(StringBuffer out, Skipper skipper) {
    out.add("<span").add(domAttrs_()).add('>')
      .add(encodedText).add("</span>");
  }
}
