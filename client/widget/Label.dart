//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
#library("dargate:widget:Label");

#import("Widget.dart");
#import("Skipper.dart");
#import("../util/Strings.dart");

/** A label.
 */
class Label extends Widget {
  String _value;
  int _maxlength = 0;
  bool _pre = false, _multiline = false;

  Label([String value=""]) {
    wclass = "w-label";
    this.value = value;
  }
  Label.from(Map<String, Object> props): super.from(props);

  String get value() => _value;
  void set value(String value) {
    _value = value != null ? value: "";
  }
  String get encodedText() {
    return encodeXML(_value, pre:_pre, multiline:_multiline, maxlength:_maxlength);
  }

  void redraw(StringBuffer out, Skipper skipper) {
    out.add("<span").add(domAttrs_()).add('>')
      .add(encodedText).add("</span>");
  }
}
