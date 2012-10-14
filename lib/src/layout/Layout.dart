//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:38 AM
// Author: tomyeh

/**
 * A layout controller that arranges the layout of the child views.
 */
interface Layout default FreeLayout {
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
  bool isProfileInherited();
  /** Returns whether its dimension depends on the parent.
   * If `true` is returned, the default width of the associate view's
   * [LayoutDeclaration] will be `flex` (rather than `content`).
   *
   * For example, [TileLayout] returns true since there is no way to measure
   * the dimension without knowing the parent's dimension.
   */
  bool isFlex();

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
abstract class AbstractLayout implements Layout {
  /** Arranges the layout of non-anchored views.
   * Instead of overriding [doLayout], it is simpler to override this method.
   */
  abstract void doLayout_(MeasureContext mctx, View view, List<View> children);

  /** Default: true.
   */
  bool isProfileInherited() => true;
  /** Default: false.
   */
  bool isFlex() => false;
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
final int _DEFAULT_SPACING = 3;
/** Returns the layout amount info for the given view.
 */
LayoutAmountInfo _getLayoutAmountInfo(View view, String value) {
  final amt = new LayoutAmountInfo(value);
  if (amt.type == LayoutAmountType.NONE
  && layoutManager.getLayoutOfView(view).isFlex()) {
    amt.type = LayoutAmountType.FLEX;
    amt.value = 1;
  }
  return amt;
}

/**
 * The free layout (default).
 */
class FreeLayout extends AbstractLayout {
  int measureWidth(MeasureContext mctx, View view) {
    int wd = mctx.getWidthSetByApp(view);
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
    int hgh = mctx.getHeightSetByApp(view);
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
  bool isProfileInherited() => false;
  void doLayout_(MeasureContext mctx, View view, List<View> children) {
    final AsInt innerWidth = () => view.innerWidth,
      innerHeight = () => view.innerHeight; //future: introduce cache
    for (final View child in children) {
      mctx.setWidthByProfile(child, innerWidth);
      mctx.setHeightByProfile(child, innerHeight);
    }
  }
}

/** The function type used to handle the layout of the root views.
 */
typedef void RootLayout(MeasureContext mctx, View root);
/** The function used to handle the layout of the root views.
 */
RootLayout rootLayout(MeasureContext mctx, View root) {
  Element cave = root.node.parent;
  if (cave == document.body)
    cave = null;
  Size size = cave == null ? browser.innerSize: new DOMQuery(cave).innerSize;

  final anchor = root.profile.anchorView;
  mctx.setWidthByProfile(root,
    () => anchor != null ? _anchorWidth(anchor, root): size.width);
  mctx.setHeightByProfile(root,
    () => anchor != null ? _anchorHeight(anchor, root): size.height);

  String loc = root.profile.location;
  final locators = _getLocators(loc);
  final ref = anchor != null ? anchor:
    cave != null ? new DOMQuery(cave): _anchorOfRoot;
if (anchor != null)
print("${anchor.pageOffset}, ${root.pageOffset}, ${anchor.left}");
  final ofs = anchor != null ?
    cave != anchor.parent ? anchor.pageOffset - root.pageOffset:
      new Offset(anchor.left, anchor.top):
    cave != null ? new DOMQuery(cave).offset:
    browser.innerOffset;
  _anchorXLocators[locators[0]](ofs.left, ref, root);
  _anchorYLocators[locators[1]](ofs.top, ref, root);
}
//Used by _locateRoot to simulate an achor for root views
class _AnchorOfRoot {
  const _AnchorOfRoot();
  int get outerWidth => browser.innerSize.width;
  int get innerWidth => browser.innerSize.width;
  int get outerHeight => browser.innerSize.height;
  int get innerHeight => browser.innerSize.height;
}
final _anchorOfRoot = const _AnchorOfRoot();
