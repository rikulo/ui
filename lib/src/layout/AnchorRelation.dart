//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 02, 2012  6:31:09 PM
// Author: tomyeh
part of rikulo_layout;

typedef void _AnchorLocator(int offset, var anchor, View view);

/**
 * The anchor relationship.
 */
class AnchorRelation {
  /** A list of independent views. An independent view is a view whose
   * position doesn't depend on others.
   */
  final List<View> indeps;
  /** A map of an anchor view and a list of views that depends on the anchor.
   */
  final Map<View, List<View>> anchored;
  /** the parent of this relation.
   */
  final View parent;

  /** Contructors of the anchor relation of all children of the given view.
   */
  AnchorRelation(View view) : indeps = new List(), anchored = new Map(), parent = view {
    for (final View child in view.children) {
      final View av = child.profile.anchorView;
      if (av == null) {
        indeps.add(child);
      } else {
        if (!identical(av.parent, view) && !identical(av, view))
          throw new UiError("Anchor can be parent or sibling, not $av");

        final deps = anchored[av];
        if (deps != null)
          deps.add(child);
        else
          anchored[av] = [child];
      }
    }
  }

  /** Handles the layout of the anchored views.
   */
  void layoutAnchored(MeasureContext mctx) {
    _layoutAnchored(mctx, parent);

    for (final View view in indeps)
      _layoutAnchored(mctx, view);
  }
  void _layoutAnchored(MeasureContext mctx, View anchor, [View thisOnly]) {
    final List<View> views = anchored[anchor];
    if (views != null && !views.isEmpty) {
      for (final View view in views) {
        if (thisOnly == null || view == thisOnly) {
          //0) preLayout callback
          mctx.preLayout(view);

          //1) size
          mctx.setWidthByProfile(view, () => _anchorWidth(anchor, view));
          mctx.setHeightByProfile(view, () => _anchorHeight(anchor, view));

          //2) position
          locateToView(mctx, view, view.profile.location, anchor);

          if (thisOnly != null)
            return; //done
        }
      }

      for (final View view in views)
        _layoutAnchored(mctx, view, thisOnly); //recursive
    }
  }
}
/** Places the given view at the given offset relative to an optional anchor.
 *
 * [x] and [y] are used only if [anchor] (the reference view) is null.
 * Please refer to [View]'s `locateTo` for more information.
 *
 * [mctx] is ignored if null.
 */
void locateToView(MeasureContext mctx, View view, String location,
[View anchor, int x=0, int y=0]) {
  final mi = new SideInfo(view.profile.margin, 0);
  final locators = _getLocators(location);
  if (anchor != null) {
    final offset =
      view.style.position == "fixed" ? anchor.pageOffset:
      identical(anchor, view.parent) ? new Offset(0, 0): //parent
      identical(anchor.parent, view.parent) ?
        new Offset(anchor.left, anchor.top): //sibling (the same coordiante system)
        anchor.pageOffset - view.pageOffset + new Offset(view.left, view.top); //neither parent nor sibling

    _anchorXLocators[locators[0]](offset.left + mi.left, anchor, view);
    _anchorYLocators[locators[1]](offset.top + mi.top, anchor, view);
  } else {
    _anchorXLocators[locators[0]](x + mi.left, _anchorOfPoint, view);
    _anchorYLocators[locators[1]](y + mi.top, _anchorOfPoint, view);
  }

  int diff = mi.left + mi.right;
  if (diff != 0 && (mctx == null || mctx.getWidthByApp(view) == null))
    view.width -= diff;
  diff = mi.top + mi.bottom;
  if (diff != 0 && (mctx == null || mctx.getHeightByApp(view) == null))
    view.height -= diff;
}
List<int> _getLocators(String loc) {
  if (loc.isEmpty) //assume a value if empty since there is an anchor
    loc = "top left";

  List<int> locators = _locators[loc];
  if (locators != null)
    return locators;

  final int j = loc.indexOf(' ');
  if (j > 0) {
    final String loc2 = "${loc.substring(j + 1)} ${loc.substring(0, j)}";
    locators = _locators[loc2];
    if (locators != null)
      return locators;
  }
  throw new UiError("Unknown loation ${loc}");
}
const Map<String, List<int>> _locators = const {
  "north start": const [1, 0], "north center": const [2, 0], "north end": const [3, 0],
  "south start": const [1, 4], "south center": const [2, 4], "south end": const [3, 4],
  "west start": const [0, 1], "west center": const [0, 2], "west end": const [0, 3],
  "east start": const [4, 1], "east center": const [4, 2], "east end": const [4, 3],
  "top left": const [1, 1], "top center": const [2, 1], "top right": const [3, 1],
  "center left": const [1, 2], "center center": const [2, 2], "center right": const [3, 2],
  "bottom left": const [1, 3], "bottom center": const [2, 3], "bottom right": const [3, 3]
};

int _anchorWidth(var anchor, View view)
=> identical(anchor, view.parent) ? anchor.innerWidth: anchor.realWidth;
int _anchorHeight(var anchor, View view)
=> identical(anchor, view.parent) ? anchor.innerHeight: anchor.realHeight;

//TODO: use const to instantiate List when Dart considers Closure as constant
final List<_AnchorLocator> _anchorXLocators = [
    (int offset, var anchor, View view) { //outer left
      view.left = offset - view.realWidth;
    },
    (int offset, var anchor, View view) { //inner left
      view.left = offset;
    },
    (int offset, var anchor, View view) { //center
      view.left = offset + (_anchorWidth(anchor, view) - view.realWidth) ~/ 2;
    },
    (int offset, var anchor, View view) { //inner right
      view.left = offset + _anchorWidth(anchor, view) - view.realWidth;
    },
    (int offset, var anchor, View view) { //outer right
      view.left = offset + _anchorWidth(anchor, view);
    }
  ];
final List<_AnchorLocator> _anchorYLocators = [
    (int offset, var anchor, View view) {
      view.top = offset - view.realHeight;
    },
    (int offset, var anchor, View view) {
      view.top = offset;
    },
    (int offset, var anchor, View view) {
      view.top = offset + (_anchorHeight(anchor, view) - view.realHeight) ~/ 2;
    },
    (int offset, var anchor, View view) { //inner bottom
      view.top = offset + _anchorHeight(anchor, view) - view.realHeight;
    },
    (int offset, var anchor, View view) { //bottom
      view.top = offset + _anchorHeight(anchor, view);
    }
  ];

class _AnchorOfPoint { //mimic View API
  const _AnchorOfPoint();
  int get realWidth => 0;
  int get innerWidth => 0;
  int get realHeight => 0;
  int get innerHeight => 0;
}
const _anchorOfPoint = const _AnchorOfPoint();
