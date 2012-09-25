//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Sep 06, 2012  6:31:33 PM
// Author: tomyeh

/**
 * The UI factory used to instantiate instances of [View], and
 * assigning the properties.
 */
interface UIFactory default DefaultUIFactory {
  UIFactory();

  /** Instantiate an instance of the given name.
   * It also adds the view as a child of the given parent, if not null.
   *
   * Notice that the name is case-insensitive.
   */
  View newInstance(Mirrors mirrors, View parent, View before, String name);
  /** Instantiate a text.
   */
  View newText(View parent, View before, String text);
  /** Assigns the given value to the property with the given name.
   */
  void setProperty(View view, String name, String value);
  /** Assigns the text to the default property, which depends on
   * the view.
   */
  void setDefaultText(View view, String value);
}

/** The default implementation that is based on mirror.
 */
class DefaultUIFactory implements UIFactory {
  View newInstance(Mirrors mirrors, View parent, View before, String name) {
  //TODO: replace with Dart mirror (and handle caseSensitive)
    View view;
    switch (name.toLowerCase()) {
      case "button": view = new Button(); break;
      case "canvas": view = new Canvas(); break;
      case "checkbox": view = new CheckBox(); break;
      case "dropdownlist": view = new DropDownList(); break;
      case "image": view = new Image(); break;
      case "radiogroup": view = new RadioGroup(); break;
      case "section": view = new Section(); break;
      case "scrollview": view = new ScrollView(); break;
      case "style": view = new Style(); break;
      case "textview": view = new TextView(); break;
      case "textbox": view = new TextBox(); break;
      case "switch": view = new Switch(); break;
      case "view": view = new View(); break;
    }
    if (view != null && parent != null)
      parent.addChild(view, before);
    return view;
  }
  View newText(View parent, View before, String text) {
    View view = new TextView(text);
    if (parent != null)
      parent.addChild(view, before);
    return view;
  }
  void setDefaultText(View view, String value) {
    //TODO: user mirror to identify the most likely property: content->html->text->value
    if (view is Style) (view as Style).content = value;
    else if (view is TextView) (view as TextView).html = value;
    else throw new UIException("Don't know to assign default text for $view");
  }
  void setProperty(View view, String name, String value) {
  //TODO: replace with Dart mirror
    switch (name) {
      case "id":
        view.id = value;
        break;
      case "class":
        view.classes.add(value);
        break;
      case "style":
        view.style.cssText = value;
        break;
      case "layout":
        view.layout.text = value;
        break;
      case "profile":
        view.profile.text = value;
        break;
      case "text":
        (view as Dynamic).text = value;
        break;
      case "html":
        (view as Dynamic).html = value;
        break;
    }
  }
}

/** The UI factory.
 *
 * You can assign your own implementation if you'd like.
 */
UIFactory uiFactory = new UIFactory();
