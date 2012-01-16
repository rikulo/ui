//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
#library("dargate:widget:Div");

#import("Widget.dart");
#import("Skipper.dart");

/** A div.
 */
class Div extends Widget {
  Div() {
  	wclass = "w-div";
  }
  Div.from(Map<String, Object> props): super.from(props);

  void redraw(StringBuffer out, Skipper skipper) {
    out.add("<div").add(domAttrs_()).add('>');
    for (Widget child = firstChild; child != null; child = child.nextSibling)
      child.redraw(out, null); //only one level
    out.add("</div>");
  }
}
