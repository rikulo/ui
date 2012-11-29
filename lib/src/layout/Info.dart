//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Nov 09, 2012  6:37:16 PM
// Author: tomyeh
part of rikulo_layout;

final RegExp _reNum = new RegExp(r"([-]?[0-9]+)");

/**
 * The types of [AmountInfo].
 */
class AmountType {
  /** Represents none.
   */
  static const AmountType NONE = const AmountType._("none");
  /** Represents fixed.
   */
  static const AmountType FIXED = const AmountType._("fixed");
  /** Represents flex.
   */
  static const AmountType FLEX = const AmountType._("flex");
  /** Represents ratio.
   */
  static const AmountType RATIO = const AmountType._("ratio");
  /** Represents content.
   */
  static const AmountType CONTENT = const AmountType._("content");
  /** Represents ignore.
   */
  static const AmountType IGNORE = const AmountType._("ignore");

  const AmountType._(String this.name);

  /** The name of this direction. */
  final String name;

  String toString() => name;
}

/**
 * The dimension information specified in layout and profile.
 *
 * Format: `#n | content | flex | flex #n | #n %`
 */
class AmountInfo {
  AmountType type;
  num value;

  /** Constructor.
   */
  AmountInfo(String profile) {
    //no need to trim since it was trimmed
    if (profile == null || profile.isEmpty || profile == "none") {
      type = AmountType.NONE;
    } else if (profile == "content") {
      type = AmountType.CONTENT;
    } else if (profile == "ignore") {
      type = AmountType.IGNORE;
    } else if (profile.startsWith("flex")) {
      type = AmountType.FLEX;
      value = profile.length > 4 ? int.parse(profile.substring(4).trim()): 1;
      if (value < 1) value = 1;
    } else if (profile.endsWith("%")) {
      type = AmountType.RATIO;
      value= double.parse(profile.substring(0, profile.length - 1).trim()) / 100;
    } else {
      type = AmountType.FIXED;
      value = Css.intOf(profile, reportError: true); //report error if no number at all
        //since it is common to end the number with px (because of CSS),
        //we retrieve only the number (and ignore the text following it).
    }
  }
  String toString() {
    return "$type:$value";
  }
}

/**
 * The side information specified in layout.
 *
 * Format: `#n1 [#n2 [#n3 #n4]]`
 */
class SideInfo {
  int top, bottom, left, right;

  SideInfo(String profile, [int defaultValue, SideInfo defaultInfo]) {
    if (profile != null && !profile.isEmpty) {
      List<int> wds = [];
      for (final Match m in _reNum.allMatches(profile)) {
        wds.add(int.parse(m.group(0)));
      }

      switch (wds.length) {
        case 0:
          break;
        case 1:
          top = bottom = left = right = wds[0];
          return;
        case 2:
          top = bottom = wds[0];
          left = right = wds[1];
          return;
        case 3:
          top = wds[0];
          left = right = wds[1];
          bottom = wds[2];
          return;
        default:
          top = wds[0];
          right = wds[1];
          bottom = wds[2];
          left = wds[3];
          return;
      }
    }
    if (defaultInfo != null) {
      top = defaultInfo.top;
      bottom = defaultInfo.bottom;
      left = defaultInfo.left;
      right = defaultInfo.right;
    } else if (defaultValue != null) {
      top = bottom = left = right = defaultValue;
    }
  }

  String toString() {
    return "($left,$top,$right,$bottom)";
  }
}
