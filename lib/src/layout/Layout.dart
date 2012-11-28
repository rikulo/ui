//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:38 AM
// Author: tomyeh
part of rikulo_layout;

/**
 * A layout controller that arranges the layout of the child views.
 */
abstract class Layout {
  /** Measure the width of the given view.
   */
  int measureWidth(MeasureContext mctx, View view);
  /** Measure the height of the given view.
   */
  int measureHeight(MeasureContext mctx, View view);

  /** Returns whether the subview's profile shall inherit the layout of
   * its parent.
   *
   * For example, it is true for [LinearLayout], since the profile's width and
   * height in the subviews shall inherit from [LayoutDeclaration] of the parent
   * (that is associated with [LinearLayout]).
   */
  bool get isProfileInherited;
  /** Returns whether its dimension depends on the parent.
   * If `true` is returned, the default width of the associate view's
   * [LayoutDeclaration] will be `flex` (rather than `content`).
   *
   * For example, [TileLayout] returns true since there is no way to measure
   * the dimension without knowing the parent's dimension.
   */
  bool get isFlex;

  /** Handles the layout of the given view.
   */
  void doLayout(MeasureContext mctx, View view);
}

/** A skeletal implementation of [Layout].
 * By extending from this class, the derive can implement only [measureWidth],
 * [measureHeight] and [doLayout_].
 *
 * Notice the default implementation of [doLayout] already handles the `preLayout`
 * callback, anchored views and the recursive callback of [doLayout] of sub views.
 * The derive shall override [doLayout_] and handle only the give sub views.
 */
abstract class AbstractLayout extends Layout {
  /** Arranges the layout of non-anchored views.
   * Instead of overriding [doLayout], it is simpler to override this method.
   */
  void doLayout_(MeasureContext mctx, View view, List<View> children);

  /** Default: true.
   */
  bool get isProfileInherited => true;
  /** Default: false.
   */
  bool get isFlex => false;
  void doLayout(MeasureContext mctx, View view) {
    if (view.firstChild != null) {
      final AnchorRelation ar = new AnchorRelation(view);
      for (final View child in ar.indeps) {
        mctx.preLayout(child);
        //unlike View.onLayout_, the layout shall invoke mctx.preLayout
      }

      //1) layout independents
      doLayout_(mctx, view, ar.indeps);

      //2) do anchored
      ar.layoutAnchored(mctx);

      //3) pass control to children
      for (final View child in view.children) {
        if (child.visible)
          child.doLayout_(mctx); //no matter shallLayout_(child)
      }
    }
  }
}

//Utilities//
final int _SPACING = browser.touch ? 8: 4;
/** Returns the layout amount info for the given view.
 */
AmountInfo _getAmountInfo(View view, String value) {
  final amt = new AmountInfo(value);
  if (amt.type == AmountType.NONE && view.layout.handler.isFlex) {
    amt.type = AmountType.FLEX;
    amt.value = 1;
  }
  return amt;
}

/**
 * The free layout (default).
 */
class FreeLayout extends AbstractLayout {
  int measureWidth(MeasureContext mctx, View view) {
    int wd = mctx.getWidthByApp(view);
    if (wd == null) {
      wd = view.innerWidth;
      for (final View child in view.children) {
        if (view.shallLayout_(child) && child.profile.anchorView == null) {
          int subsz = child.measureWidth_(mctx);
          subsz = child.left + (subsz != null ? subsz: 0);
          if (wd == null || subsz > wd)
            wd = subsz;
        }
      }

      if (wd != null)
        wd += mctx.getBorderWidth(view);
    }
    return wd;
  }
  int measureHeight(MeasureContext mctx, View view) {
    int hgh = mctx.getHeightByApp(view);
    if (hgh == null) {
      hgh = view.innerHeight;
      for (final View child in view.children) {
        if (view.shallLayout_(child) && child.profile.anchorView == null) {
          int subsz = child.measureHeight_(mctx);
          subsz = child.top + (subsz != null ? subsz: 0);
          if (hgh == null || subsz > hgh)
            hgh = subsz;
        }
      }

      if (hgh != null)
        hgh += mctx.getBorderHeight(view);
    }
    return hgh;
  }
  bool get isProfileInherited => false;
  void doLayout_(MeasureContext mctx, View view, List<View> children) {
    final AsInt innerWidth = () => view.innerWidth,
      innerHeight = () => view.innerHeight; //future: introduce cache
    for (final View child in children) {
      mctx.setWidthByProfile(child, innerWidth);
      mctx.setHeightByProfile(child, innerHeight);
    }
  }
}

/** The function used to handle the layout of the root views.
 */
void rootLayout(MeasureContext mctx, View root) {
  final node = root.node;
  final dlgInfo = dialogInfos[root];
  Element cave = dlgInfo != null ? dlgInfo.cave.parent: node.parent;
  if (cave == document.body)
    cave = null;
  final size = cave == null ? browser.size: new DomAgent(cave).innerSize;

  final anchor = root.profile.anchorView;
  mctx.setWidthByProfile(root,
    () => anchor != null ? _anchorWidth(anchor, root): size.width);
  mctx.setHeightByProfile(root,
    () => anchor != null ? _anchorHeight(anchor, root): size.height);

  final loc = root.profile.location,
  	leftByApp = loc.isEmpty && mctx.getLeftByApp(root) != null,
    topByApp = loc.isEmpty && mctx.getTopByApp(root) != null;
    //if !loc.isEmpty, the layout is still required (since it is related to cave)
  if (!leftByApp || !topByApp) {
    final ref = anchor != null ? anchor:
      cave != null ? new _AnchorOfNode(cave): _anchorOfRoot;
    final ofs = anchor != null ?
      cave != anchor.parent ?
        anchor.pageOffset - root.pageOffset + new Offset(root.left, root.top):
        new Offset(anchor.left, anchor.top):
      cave != null && node.offsetParent != node.parent ? //if parent is relative/absolute/fixed
          new DomAgent(cave).offset: new Offset(0,0);

    final locators = _getLocators(loc);
    final mi = new SideInfo(root.profile.margin, 0);
    if (!leftByApp)
      _anchorXLocators[locators[0]](ofs.left + mi.left, ref, root);
    if (!topByApp)
      _anchorYLocators[locators[1]](ofs.top + mi.top, ref, root);

    int diff = mi.left + mi.right;
    if (diff != 0 && mctx.getWidthByApp(root) == null)
      root.width -= diff;
    diff = mi.top + mi.bottom;
    if (diff != 0 && mctx.getHeightByApp(root) == null)
      root.height -= diff;
  }
}
//Used by _locateRoot to simulate an achor for root views
class _AnchorOfRoot { //mimic View API
  const _AnchorOfRoot();
  int get realWidth => browser.size.width;
  int get innerWidth => browser.size.width;
  int get realHeight => browser.size.height;
  int get innerHeight => browser.size.height;
}
const _anchorOfRoot = const _AnchorOfRoot();

class _AnchorOfNode { //mimic View API
  final DomAgent _q;
  _AnchorOfNode(Element n): _q = new DomAgent(n);
  int get realWidth => _q.width;
  int get innerWidth => _q.innerWidth;
  int get realHeight => _q.height;
  int get innerHeight => _q.innerHeight;
}
