//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A section is a view implementing ID space ([IdSpace]).
 */
class Section extends View implements IdSpace {
  //The fellows. Used only if this is IdSpace
  Map<String, View> _fellows;

  Section() {
    _fellows = {};
  }

  //@Override
  String get className => "Section"; //TODO: replace with reflection if Dart supports it

  View getFellow(String id) => _fellows[id];
  void bindFellow_(String id, View fellow) {
    if (fellow != null) _fellows[id] = fellow;
    else _fellows.remove(id);
  }

  /** Returns the HTML tag's name representing this widget.
   *
   * Default: `section`.
   */
  String get domTag_ => "section";
}
