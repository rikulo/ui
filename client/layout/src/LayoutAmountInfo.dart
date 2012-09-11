//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 06, 2012  3:11:20 PM
// Author: tomyeh

/**
 * The types of [LayoutAmountInfo].
 */
class LayoutAmountType {
  final String _name;

  /** Represents none.
   */
  static final LayoutAmountType NONE = const LayoutAmountType("none");
  /** Represents fixed.
   */
  static final LayoutAmountType FIXED = const LayoutAmountType("fixed");
  /** Represents flex.
   */
  static final LayoutAmountType FLEX = const LayoutAmountType("flex");
  /** Represents ratio.
   */
  static final LayoutAmountType RATIO = const LayoutAmountType("ratio");
  /** Represents content.
   */
  static final LayoutAmountType CONTENT = const LayoutAmountType("content");

  const LayoutAmountType(String this._name);

  /** The name of this direction. */
  String get name => _name;

  String toString() => _name;
}

/**
 * The dimension information specified in layout and profile.
 *
 * Format: `#n | content | flex | flex #n | #n %`
 */
class LayoutAmountInfo {
  LayoutAmountType type;
  num value;

  /** Constructor.
   */
  LayoutAmountInfo(String profile) {
    if (profile == null || profile.isEmpty()) { //no need to trim since it was trimmed
      type = LayoutAmountType.NONE;
    } else if (profile == "content") {
      type = LayoutAmountType.CONTENT;
    } else if (profile.startsWith("flex")) {
      type = LayoutAmountType.FLEX;
      value = profile.length > 4 ? parseInt(profile.substring(4).trim()): 1;
      if (value < 1) value = 1;
    } else if (profile.endsWith("%")) {
      type = LayoutAmountType.RATIO;
      value= parseDouble(profile.substring(0, profile.length - 1).trim()) / 100;
    } else {
      type = LayoutAmountType.FIXED;
      value = CSS.intOf(profile, true); //report error if no number at all
        //since it is common to end the number with px (because of CSS),
        //we retrieve only the number (and ignore the text following it).
    }
  }
  String toString() {
    return "$type:$value";
  }
}
