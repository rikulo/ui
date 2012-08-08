//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Apr 10, 2012 12:52:49 PM
// Author: tomyeh

/**
 * The side information specified in layout.
 *
 * Format: `#n1 [#n2 [#n3 #n4]]`
 */
class LayoutSideInfo {
  int top, bottom, left, right;

  static final RegExp _reWord = const RegExp(@"(\w+)");

  LayoutSideInfo(String profile, [int defaultValue, LayoutSideInfo defaultInfo]) {
    if (profile != null && !profile.isEmpty()) {
      List<int> wds = [];
      for (final Match m in _reWord.allMatches(profile)) {
        wds.add(parseInt(m.group(0)));
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
    return "($left,$top:$right,$bottom)";
  }
}
