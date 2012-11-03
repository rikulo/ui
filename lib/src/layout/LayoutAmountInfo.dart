//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 06, 2012  3:11:20 PM
// Author: tomyeh
part of rikulo_layout;

/**
 * The types of [LayoutAmountInfo].
 */
class LayoutAmountType {
  /** Represents none.
   */
  static const LayoutAmountType NONE = const LayoutAmountType._("none");
  /** Represents fixed.
   */
  static const LayoutAmountType FIXED = const LayoutAmountType._("fixed");
  /** Represents flex.
   */
  static const LayoutAmountType FLEX = const LayoutAmountType._("flex");
  /** Represents ratio.
   */
  static const LayoutAmountType RATIO = const LayoutAmountType._("ratio");
  /** Represents content.
   */
  static const LayoutAmountType CONTENT = const LayoutAmountType._("content");

  const LayoutAmountType._(String this.name);

  /** The name of this direction. */
  final String name;

  String toString() => name;
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
    if (profile == null || profile.isEmpty) { //no need to trim since it was trimmed
      type = LayoutAmountType.NONE;
    } else if (profile == "content") {
      type = LayoutAmountType.CONTENT;
    } else if (profile.startsWith("flex")) {
      type = LayoutAmountType.FLEX;
      value = profile.length > 4 ? int.parse(profile.substring(4).trim()): 1;
      if (value < 1) value = 1;
    } else if (profile.endsWith("%")) {
      type = LayoutAmountType.RATIO;
      value= double.parse(profile.substring(0, profile.length - 1).trim()) / 100;
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
