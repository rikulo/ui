//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 11:15:11 AM
// Author: tomyeh

/**
 * The default implementation of [LayoutDeclaration].
 */
class LayoutDeclarationImpl extends DeclarationImpl
implements LayoutDeclaration {
  final View _owner;

  LayoutDeclarationImpl(View owner): _owner = owner;

  String get type => getPropertyValue("type");
  void set type(String value) {
    setProperty("type", value);
  }

  String get orient => getPropertyValue("orient");
  void set orient(String value) {
    setProperty("orient", value);
  }

  String get align => getPropertyValue("align");
  void set align(String value) {
    setProperty("align", value);
  }

  String get spacing => getPropertyValue("spacing");
  void set spacing(String value) {
    setProperty("spacing", value);
  }

  String get gap => getPropertyValue("gap");
  void set gap(String value) {
    setProperty("gap", value);
  }

  String get width => getPropertyValue("width");
  void set width(String value) {
    setProperty("width", value);
  }

  String get height => getPropertyValue("height");
  void set height(String value) {
    setProperty("height", value);
  }
}
