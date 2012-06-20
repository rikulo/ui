//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class PseudoClass {
  
  final String name;
  String parameter;
  
  PseudoClass(this.name);
  
  String toString() {
    StringBuffer sb = new StringBuffer(":${name}");
    if (parameter != null)
      sb.add("(${parameter})");
    return sb.toString();
  }
  
  // built-in implementations //
  static Function getDefinition(String name) {
    switch (name) {
      case "first-child":
        return (ViewMatchContext ctx, String param) => 
            param == null && ctx.view.previousSibling == null;
      case "last-child":
        return (ViewMatchContext ctx, String param) => 
            param == null && ctx.view.nextSibling == null;
      case "only-child":
        return (ViewMatchContext ctx, String param) => 
            param == null && ctx.view.previousSibling == null 
            && ctx.view.nextSibling == null;
      case "empty":
        return (ViewMatchContext ctx, String param) => 
            param == null && ctx.view.childCount == 0;
      case "nth-child":
        return (ViewMatchContext ctx, String param) => param != null; // TODO
      case "last-nth-child":
        return (ViewMatchContext ctx, String param) => param != null; // TODO
      default:
        return null;
    }
  }
  
}
