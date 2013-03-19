//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012  3:04:55 PM
// Author: tomyeh
part of rikulo_html;

/**
 * CSS utilities
 */
class Css {
  /** The prefix used for non-standard CSS property.
   * For example, it is `-webkit-` for a Webkit-based browser.
   * If you're not sure whether to prefix a CSS property, please use
   * [name] instead.
   */
  static final String prefix = browser.webkit ? "-webkit-":
    browser.msie ? "-ms-": browser.firefox ? "-moz-": browser.opera ? "-o-": "";

  ///A list of the property names of CSS text related styles.
  static const List<String> textNames = const [
    'font-family', 'font-size', 'font-weight', 'font-style',
    'letter-spacing', 'line-height', 'text-align', 'text-decoration',
    'text-indent', 'text-shadow', 'text-transform', 'text-overflow',
    'direction', 'word-spacing', 'white-space'];

  /** Converts a CSS value representing a pixel.
   * In other words, it converts a number to a string appended with "px".
   * Notice that it returns an empty string if [val] is null.
   */
  static String px(num val) {
    return val != null ? "${val}px": "";
  }
  /** Converts a CSS value representing a color.
   */
  static String color(int red, int green, int blue, [num alpha]) {
    return alpha != null ? "rgba($red,$green,$blue,$alpha)":
      "#${StringUtil.toHexString(red,2)}${StringUtil.toHexString(green,2)}${StringUtil.toHexString(blue,2)}";
  }

  /** Converts a [Transformation] object to CSS value for property transform.
   */
  static String transform(Transformation t) => 
      "matrix(${t[0][0]}, ${t[1][0]}, ${t[0][1]}, ${t[1][1]}, ${t[0][2]}, ${t[1][2]})";
  /** Converts a CSS value presenting `translate3d` for the property called `transform`.
   */
  static String translate3d(int x, int y, [int z])
  => "translate3d(${x}px,${y}px,${z != null ? z: 0}px)";
  /** Converts a string of a 3-tuples to [Point3D].
   * If it is 2-tuples, [Point3D.z] will be zero.
   */
  static Point3D point3DOf(String value) {
    if (value == null || value.isEmpty)
      return new Point3D(0, 0, 0);

    final List<int> ary = [0, 0, 0];
    int i = value.indexOf('(');
    if (i >= 0) value = value.substring(i + 1);
    i = 0;
    for (String tuple in value.split(',')) {
      ary[i++] = intOf(tuple);
      if (i == 3)
        break;
    }
    return new Point3D(ary[0], ary[1], ary[2]);
  }
  /** Converts a string of a CSS value to an integer.
   * It returns 0 if value is null, empty, or failed to parse.
	 *
	 * By default, it returns `defaultValue` (default: 0)
   * if it failed to parse the given value.
	 * If you prefer to throw an exception, specify [reportError] to true.
   */
  static int intOf(String value, {int defaultValue: 0, bool reportError}) {
    try {
      if (value != null && !value.isEmpty) {
        final Match m = _reNum.firstMatch(value);
        if (m != null)
          return int.parse(m.group(0));
      }
    } catch (e) {
      if (reportError != null && reportError)
        throw e;
    }
    return defaultValue;
  }
  static final RegExp _reNum = new RegExp(r"([-]?[0-9]+)");
  
  /** Return the sum of the integers of the given [values] converted by [intOf]
   * function. 
   */
  static int sumOf(List<String> values, {bool reportError}) {
    int sum = 0;
    for (String v in values)
      sum += intOf(v, reportError: reportError);
    return sum;
  }

  ///Copy the properties of the given names from one declaration, src, to another, dest.
  static void copy(CssStyleDeclaration dest, CssStyleDeclaration src, List<String> names) {
    for (int j = names.length; --j >= 0;) {
      final String nm = names[j];
      final String val = src.getPropertyValue(nm);
      dest.setProperty(nm, val != null ? val: "");
    }
  }
}
