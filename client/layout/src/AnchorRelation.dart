//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 02, 2012  6:31:09 PM
// Author: tomyeh

typedef void _AnchorHandler(int offset, var anchor, View view);

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
        if (av.parent !== view && av !== view)
          throw new UIException("Anchor can be parent or sibling, not $av");

        List<View> deps = anchored[av];
        if (deps == null)
          anchored[av] = deps = new List();
        deps.add(child);
      }
    }
  }

  /** Handles the layout of the anchored views.
   */
  void layoutAnchored(MeasureContext mctx) {
    _layoutAnchored(mctx, parent);
    for (final View view in indeps) {
      _layoutAnchored(mctx, view);
    }
  }
  void _layoutAnchored(MeasureContext mctx, View anchor) {
    final List<View> views = anchored[anchor];
    if (views !== null && !views.isEmpty()) {
      final AsInt
        anchorOuterWidth = () => anchor.outerWidth,
        anchorOuterHeight = () => anchor.outerHeight,
        anchorInnerWidth = () => anchor.innerWidth,
        anchorInnerHeight = () => anchor.innerHeight;

      for (final View view in views) {
        //1) size
        mctx.setWidthByProfile(view,
          anchor === view.parent ? anchorInnerWidth: anchorOuterWidth);
        mctx.setHeightByProfile(view,
          anchor === view.parent ? anchorInnerHeight: anchorOuterHeight);

        //2) position
        final List<int> handlers = _getHandlers(view.profile.location);
        final Offset offset = _getOffset(anchor, view);
        _anchorXHandlers[handlers[0]](offset.left, anchor, view);
        _anchorYHandlers[handlers[1]](offset.top, anchor, view);
      }

      for (final View view in views) {
        _layoutAnchored(mctx, view); //recursive
      }
    }
  }
  //called by LayoutManager
  static void _positionRoot(View view) {
    final String loc = view.profile.location;
    if (!loc.isEmpty()) { //nothing to do if empty (since no achor at all)
      final List<int> handlers = _getHandlers(loc);
      _anchorXHandlers[handlers[0]](0, _anchorOfRoot, view);
      _anchorYHandlers[handlers[1]](0, _anchorOfRoot, view);
    }
  }
  /** Positions the given view at the given offset.
   *
   * Please refer to [ViewUtil]'s `position` for more information.
   */
  static void position(View view, int x, int y, String location) {
    if (location === null || location.isEmpty()) {
      view.left = x;
      view.top = y;
    } else {
      final List<int> handlers = _getHandlers(location);
      _anchorXHandlers[handlers[0]](x, _anchorOfPoint, view);
      _anchorYHandlers[handlers[1]](y, _anchorOfPoint, view);
    }
  }

  static List<int> _getHandlers(String loc) {
    if (loc.isEmpty()) //assume a value if empty since there is an anchor
      loc = "top left";

    List<int> handlers = _locations[loc];
    if (handlers != null)
      return handlers;

    final int j = loc.indexOf(' ');
    if (j > 0) {
      final String loc2 = "${loc.substring(j + 1)} ${loc.substring(0, j)}";
      handlers = _locations[loc2];
      if (handlers != null)
        return handlers;
    }
    throw new UIException("Unknown loation ${loc}");
  }
  /** Returns the offset between two views.
   */
  static Offset _getOffset(View anchor, View view) {
    return view.style.position == "fixed" ? anchor.documentOffset:
      anchor === view.parent ? new Offset(0, 0):
        new Offset(anchor.left, anchor.top);
  }
}
final Map<String, List<int>> _locations = const {
  "north start": const [1, 0], "north center": const [2, 0], "north end": const [3, 0],
  "south start": const [1, 4], "south center": const [2, 4], "south end": const [3, 4],
  "west start": const [0, 1], "west center": const [0, 2], "west end": const [0, 3],
  "east start": const [4, 1], "east center": const [4, 2], "east end": const [4, 3],
  "top left": const [1, 1], "top center": const [2, 1], "top right": const [3, 1],
  "center left": const [1, 2], "center center": const [2, 2], "center right": const [3, 2],
  "bottom left": const [1, 3], "bottom center": const [2, 3], "bottom right": const [3, 3]
};
//TODO: use const when Dart considers Closure as constant
List<_AnchorHandler> get _anchorXHandlers() {
  if (_$anchorXHandlers == null)
    _$anchorXHandlers = [
      (int offset, var anchor, View view) { //outer left
        view.left = offset - view.outerWidth;
      },
      (int offset, var anchor, View view) { //inner left
        view.left = offset;
      },
      (int offset, var anchor, View view) { //center
        view.left = offset + (anchor.outerWidth - view.outerWidth) ~/ 2;
      },
      (int offset, var anchor, View view) { //inner right
        view.left = offset
          + (anchor === view.parent ? anchor.innerWidth: anchor.outerWidth)
          - view.outerWidth;
      },
      (int offset, var anchor, View view) { //outer right
        view.left = offset + anchor.outerWidth;
      }
    ];
  return _$anchorXHandlers;
}
List<_AnchorHandler> _$anchorXHandlers;
List<_AnchorHandler> get _anchorYHandlers() {
  if (_$anchorYHandlers == null)
    _$anchorYHandlers = [
      (int offset, var anchor, View view) {
        view.top = offset - view.outerHeight;
      },
      (int offset, var anchor, View view) {
        view.top = offset;
      },
      (int offset, var anchor, View view) {
        view.top = offset + (anchor.outerHeight - view.outerHeight) ~/ 2;
      },
      (int offset, var anchor, View view) { //inner bottom
        view.top = offset
          + (anchor === view.parent ? anchor.innerHeight: anchor.outerHeight)
          - view.outerHeight;
      },
      (int offset, var anchor, View view) {
        view.top = offset + anchor.outerHeight;
      }
    ];
  return _$anchorYHandlers;
}
List<_AnchorHandler> _$anchorYHandlers;

//Used by _positionRoot to simulate an achor for root views
class _AnchorOfRoot {
  const _AnchorOfRoot();
  int get outerWidth() => browser.size.width;
  int get innerWidth() => browser.size.width;
  int get outerHeight() => browser.size.height;
  int get innerHeight() => browser.size.height;
}
final _anchorOfRoot = const _AnchorOfRoot();

class _AnchorOfPoint {
  const _AnchorOfPoint();
  int get outerWidth() => 0;
  int get innerWidth() => 0;
  int get outerHeight() => 0;
  int get innerHeight() => 0;
}
final _anchorOfPoint = const _AnchorOfPoint();
