//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
part of rikulo_view;

/** A section is a view implementing ID space ([IDSpace]).
 * It is usually used to hold a section of UI that is usually indepedent of
 * the others.
 */
class Section extends View implements IDSpace {
  Section() {
  }

  @override
  final Map<String, View> fellows = new HashMap();

  /** Returns the SECTION element.
   */
  @override
  Element render_() => new Element.tag("section");
  @override
  String get className => "Section";
}
