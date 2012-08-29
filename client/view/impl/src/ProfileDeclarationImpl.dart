//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 11:15:27 AM
// Author: tomyeh

/**
 * The default implementation of [ProfileDeclaration].
 */
class ProfileDeclarationImpl extends  DeclarationImpl
implements ProfileDeclaration {
  final View _owner;
  View _anchorView;

  ProfileDeclarationImpl(View owner) : _owner = owner;

  String get anchor
    => getPropertyValue("anchor");
  void set anchor(String value) {
    setProperty("anchor", value);
    _anchorView = null;
  }

  View get anchorView {
    if (_anchorView != null)
      return _anchorView;
    final anc = anchor;
    return anc.isEmpty() ? location.isEmpty() ? null: _owner.parent: _owner.query(anc);
  }
  void set anchorView(View view) {
    String av;
    if (view == null) {
      av = "";
    } else if (view === _owner.parent) {
      av = "parent";
    } else {
      if (view != null
      && view.parent != null && _owner.parent != null //parent might not be assigned yet
      && view.parent !== _owner.parent)
        throw new UIException("Only parent or sibling allowed for an anchor, not $view");
      if (view === _owner)
        throw const UIException("The anchor can't be itself.");
      av = view.id.isEmpty() ? "": "#${view.id}";
    }
    setProperty("anchor", av);
    _anchorView = view;
  }

  String get location => getPropertyValue("location");
  void set location(String value) {
    setProperty("location", value);
  }

  String get align => getPropertyValue("align");
  void set align(String value) {
    setProperty("align", value);
  }

  String get spacing => getPropertyValue("spacing");
  void set spacing(String value) {
    setProperty("spacing", value);
  }

  String get width => getPropertyValue("width");
  void set width(String value) {
    setProperty("width", value);
  }

  String get height => getPropertyValue("height");
  void set height(String value) {
    setProperty("height", value);
  }

  String get minWidth => getPropertyValue("min-width");
  void set minWidth(String value) {
    setProperty("min-width", value);
  }

  String get minHeight => getPropertyValue("min-height");
  void set minHeight(String value) {
    setProperty("min-height", value);
  }

  String get maxWidth => getPropertyValue("max-width");
  void set maxWidth(String value) {
    setProperty("max-width", value);
  }

  String get maxHeight => getPropertyValue("max-height");
  void set maxHeight(String value) {
    setProperty("max-height", value);
  }

  String get clear => getPropertyValue("clear");
  void set clear(String value) {
    setProperty("clear", value);
  }
}
