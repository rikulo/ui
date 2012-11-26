//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
part of rikulo_view;

/** A section is a view implementing ID space ([IdSpace]).
 * It is usually used to hold a section of UI that is usually indepedent of
 * the others.
 */
class Section extends View implements IdSpace {
  Section() {
  }

  //@override
  final Map<String, View> fellows = new Map();

  /** Returns the SECTION element.
   */
  //@override
  Element render_() => new Element.tag("section");
}
