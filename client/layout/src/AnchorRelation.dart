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
    if (views != null && !views.isEmpty()) {
      for (final View view in views) {
        if (thisOnly == null || view == thisOnly) {
          //0) preLayout callback
          mctx.preLayout(view);

          //1) size
          mctx.setWidthByProfile(view, () => _anchorWidth(anchor, view));
          mctx.setHeightByProfile(view, () => _anchorHeight(anchor, view));

          //2) position
          locate(view, view.profile.location, anchor);

          if (thisOnly != null)
            return; //done
        }
      }

      for (final View view in views)
        _layoutAnchored(mctx, view, thisOnly); //recursive
    }
  }
  //called by LayoutManager
  //No need to call preLayout since LayoutManager will do it
  static void _layoutRoot(MeasureContext mctx, View root) {
    final anchor = root.profile.anchorView;
    mctx.setWidthByProfile(root,
      () => anchor != null ? _anchorWidth(anchor, root): browser.size.width);
    mctx.setHeightByProfile(root,
      () => anchor != null ? _anchorHeight(anchor, root): browser.size.height);

    final String loc = root.profile.location;
    if (!loc.isEmpty()) { //nothing to do if empty (since no achor at all)
      final List<int> handlers = _getHandlers(loc);
      _anchorXHandlers[handlers[0]](0, anchor != null ? anchor: _anchorOfRoot, root);
      _anchorYHandlers[handlers[1]](0, anchor != null ? anchor: _anchorOfRoot, root);
    }
  }
  /** Locates the given view at the given offset.
   *
   * Please refer to [View]'s `locateTo` for more information.
   */
  static void locate(View view, String location, View anchor, [int x=0, int y=0]) {
    if (anchor != null) {
      final handlers = _getHandlers(location);
      final offset =
        view.style.position == "fixed" ? anchor.pageOffset:
        anchor === view.parent ? new Offset(0, 0): //parent
        anchor.parent === view.parent ?
          new Offset(anchor.left, anchor.top): //sibling (the same coordiante system)
          anchor.pageOffset - view.pageOffset; //neither parent nor sibling
      _anchorXHandlers[handlers[0]](offset.left, anchor, view);
      _anchorYHandlers[handlers[1]](offset.top, anchor, view);
    } else if (location == null || location.isEmpty()) {
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

int _anchorWidth(var anchor, View view)
=> anchor === view.parent ? anchor.innerWidth: anchor.outerWidth;
int _anchorHeight(var anchor, View view)
=> anchor === view.parent ? anchor.innerHeight: anchor.outerHeight;

//TODO: use const when Dart considers Closure as constant
List<_AnchorHandler> get _anchorXHandlers {
  if (_$anchorXHandlers == null)
    _$anchorXHandlers = [
      (int offset, var anchor, View view) { //outer left
        view.left = offset - view.outerWidth;
      },
      (int offset, var anchor, View view) { //inner left
        view.left = offset;
      },
      (int offset, var anchor, View view) { //center
        view.left = offset + (_anchorWidth(anchor, view) - view.outerWidth) ~/ 2;
      },
      (int offset, var anchor, View view) { //inner right
        view.left = offset + _anchorWidth(anchor, view) - view.outerWidth;
      },
      (int offset, var anchor, View view) { //outer right
        view.left = offset + _anchorWidth(anchor, view);
      }
    ];
  return _$anchorXHandlers;
}
List<_AnchorHandler> _$anchorXHandlers;
List<_AnchorHandler> get _anchorYHandlers {
  if (_$anchorYHandlers == null)
    _$anchorYHandlers = [
      (int offset, var anchor, View view) {
        view.top = offset - view.outerHeight;
      },
      (int offset, var anchor, View view) {
        view.top = offset;
      },
      (int offset, var anchor, View view) {
        view.top = offset + (_anchorHeight(anchor, view) - view.outerHeight) ~/ 2;
      },
      (int offset, var anchor, View view) { //inner bottom
        view.top = offset + _anchorHeight(anchor, view) - view.outerHeight;
      },
      (int offset, var anchor, View view) { //bottom
        view.top = offset + _anchorHeight(anchor, view);
      }
    ];
  return _$anchorYHandlers;
}
List<_AnchorHandler> _$anchorYHandlers;

//Used by _locateRoot to simulate an achor for root views
class _AnchorOfRoot {
  const _AnchorOfRoot();
  int get outerWidth => browser.size.width;
  int get innerWidth => browser.size.width;
  int get outerHeight => browser.size.height;
  int get innerHeight => browser.size.height;
}
final _anchorOfRoot = const _AnchorOfRoot();

class _AnchorOfPoint {
  const _AnchorOfPoint();
  int get outerWidth => 0;
  int get innerWidth => 0;
  int get outerHeight => 0;
  int get innerHeight => 0;
}
final _anchorOfPoint = const _AnchorOfPoint();
