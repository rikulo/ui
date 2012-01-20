/* CSSStyleWrapper.dart

  History:
    Fri Jan 20 21:35:14 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/
#library("artra:widget:CSSStyleWrapper");

#import("dart:html");
#import("Widget.dart");

/**
 * The implementation for handling [CSSStyleDeclaration].
 * The default implemetation will update the widget's element (Widget.node).
 * The derived class could override the proper method to handle it different.
 */
class CSSStyleWrapper {
  Widget _owner;
  CSSStyleDeclaration _style;
  var dartObjectLocalStorage;

  CSSStyleWrapper(Widget owner) {
    _owner = owner;
    _style = new CSSStyleDeclaration();
  }

  String get cssText() => _style.cssText;
  /** Updates the style style with the CSS text.
   * <p>Note: don't override this method. Rather, override [setCSSText_] instead.
   */
  void set cssText(var value) {
    setCSSText_(value);
  }
  /** Update the style with the CSS text.
   * A deriving class can override this method to handle it different.
   * For example, assume the text-decoration property will be assigned
   * to a subnode, then you can override this method, call back
   * with <code>ignoreDom: true</code>, and then update the subnode.
   */
  void setCSSText_(var value, [ignoreDom = false]) {
    _style.cssText = value;
    if (!ignoreDom) {
      final Element n = _owner.node;
      if (n != null)
        n.style.cssText = value;
    }
  }

  int get length() => _style.length;

  CSSRule get parentRule() => _style.parentRule;

  CSSValue getPropertyCSSValue(String propertyName) =>
    _style.getPropertyCSSValue(propertyName);

  String getPropertyPriority(String propertyName) =>
    _style.getPropertyPriority(propertyName);

  String getPropertyShorthand(String propertyName) =>
    _style.getPropertyShorthand(propertyName);

  String getPropertyValue(String propertyName) =>
    _style.getPropertyValue(propertyName);

  bool isPropertyImplicit(String propertyName) =>
    _style.isPropertyImplicit(propertyName);

  String item(int index) => _style.item(index);

  /** Removes a CSS property.
   * A deriving class can override this method to handle it different.
   * For example, assume the text-decoration property was assigned
   * to a subnode, then you can override this method, call back
   * with <code>ignoreDom: true</code>, and then update the subnode.
   */
  String removeProperty(String propertyName, [bool ignoreDom = false]) {
    String old = _style.removeProperty(propertyName);
    if (!ignoreDom) {
      final Element n = _owner.node;
      if (n != null)
        n.style.removeProperty(propertyName);
    }
    return old;
  }

  /** Sets a CSS property.
   * A deriving class can override this method to handle it different.
   * For example, assume the text-decoration property shall be assigned
   * to a subnode, then you can override this method, call back
   * with <code>ignoreDom: true</code>, and then update the subnode.
   */
  void setProperty(String propertyName, var value,
  [String priority = '', bool ignoreDom = false]) {
    _style.setProperty(propertyName, '$value', priority);
    if (!ignoreDom) {
      final Element n = _owner.node;
      if (n != null)
        n.style.setProperty(propertyName, '$value', priority);
    }
  }
}
