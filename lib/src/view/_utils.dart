//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Nov 2, 2012  12:04:16 AM
//Author: simonpai
part of rikulo_view;

///Converts null to an empty string
String _s(String s) => s != null ? s: "";
///Converts null to false
bool _b(bool b) => b != null && b;
///Converts null to 0
num _n(num n) => n != null ? n: 0;

/** A utility for element size calculation.
 */
class _DOMAgentX extends DOMAgent {
  _DOMAgentX(Element node): super(node);
  
  /// Sum over horizontal sizes of given properties.
  int sumHor({bool mar: false, bool bor: false, bool pad: false}) =>
      _sum(false, mar, bor, pad);
  /// Sum over vertical sizes of given properties.
  int sumVer({bool mar: false, bool bor: false, bool pad: false}) =>
      _sum(true, mar, bor, pad);
  int _sum(bool ver, bool margin, bool border, bool padding) {
    int sum = 0;
    final CSSStyleDeclaration s = computedStyle;
    if (margin)
      sum += ver ? CSS.intOf(s.marginTop) + CSS.intOf(s.marginBottom) :
          CSS.intOf(s.marginLeft) + CSS.intOf(s.marginRight);
    if (border)
      sum += ver ? CSS.intOf(s.borderTop) + CSS.intOf(s.borderBottom) :
        CSS.intOf(s.borderLeft) + CSS.intOf(s.borderRight);
    if (padding)
      sum += ver ? CSS.intOf(s.paddingTop) + CSS.intOf(s.paddingBottom) :
        CSS.intOf(s.paddingLeft) + CSS.intOf(s.paddingRight);
    return sum;
  }

  ///Returns if there is non-empty text node in this element.
  bool get hasContent => _hasContent(node);
  static bool _hasContent(Node node) {
    if (node is Text && !node.text.trim().isEmpty)
      return true;

    if (node is Element)
      switch ((node as Element).tagName.toLowerCase()) {
        case "input":
        case "option":
        case "textarea":
          return true;
      }

    for (final n in node.nodes)
      if (_hasContent(n))
        return true;
    return false;
  }
}
