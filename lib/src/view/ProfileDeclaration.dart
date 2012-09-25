//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:15:54 AM
// Author: tomyeh

/**
 * The position declaration of a view.
 */
interface ProfileDeclaration extends Declaration
default ProfileDeclarationImpl {
  ProfileDeclaration(View owner);

  /** The anchor, or null if [anchorView] was assigned and it isn't
   * assigned with an ID.
   *
   * Syntax: `anchor: | a_CSS_selector | parent`
   *
   * Default: *an empty string*.  
   * It means parent if [location] is specified.  
   * Otherwise, it means no anchor at all if both [location] and [anchor]
   * are empty (and [anchorView] is null).
   */
  String anchor;
  /** The anchor view. There are two ways to assign an anchor view:
   *
   * 1. assign a value to [anchor]
   * 2. assign a view to [anchorView].
   *
   * Notice that the anchor view must be the parent or one of the
   * siblings.
   */
  View anchorView;

  /** The location of the associated view.
   * It is used only if [anchor] is not assigned with an non-empty value
   * (or [anchorView] is assigned with a view).
   *
   * Default: *an empty string*.
   * It means `top left`, if [anchor] or [anchorView] is specified, 
   *
   * It can be one of the following.  
   * "north start", "north center", "north end",
   * "south start", "south center", "south end",
   * "west start", "west center", "west end",
   * "east start", "east center", "east end",
   * "top left", "top center", "top right",
   * "center left", "center center", "center right",
   * "bottom left", "bottom center", and "bottom right"
   */
  String location;

  /** The alignment.
   *
   * Syntax: `align: start | center | end`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   */
  String align;
  /** The spacing of the associated view.
   *
   * Syntax: `#n1 [#n2 [#n3 #n4]]`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   */
  String spacing;

  /** The expected width of the associated view.
   *
   * Syntax: `width: #n | content | flex | flex #n | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Notice that the width will be adjusted against [minWidth] and
   * [maxWidth] (if they are specified).
   */
  String width;
  /** The expected width of the associated view.
   *
   * Syntax: `height: #n | content | flex | flex #n | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Notice that the height will be adjusted against [minHeight] and
   * [maxHeight] (if they are specified).
   */
  String height;

  /** The expected minimal allowed width of the associated view.
   *
   * Syntax: `min-width: #n | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the width of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String minWidth;
  /** The expected minimal allowed width of the associated view.
   *
   * Syntax: `min-height: #n | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the height of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String minHeight;

  /** The expected maximal allowed width of the associated view.
   *
   * Syntax: `max-width: #n | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the width of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String maxWidth;
  /** The expected maximal allowed width of the associated view.
   *
   * Syntax: `max-height: #n | flex | #n %`
   *
   * Default: *an empty string*. It means it will depends on parent's [LayoutDeclaration].
   *
   * Currently, it is supported in the following cases:
   *
   * + Supported when measuring the height of a non-ViewGroup view such as
   * [TextView] and [Image] (See also [View.isViewGroup]).
   * + Supported by [TileLayout].
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String maxHeight;

  /** Which side of the view won't display another sibling.
   *
   * Syntax: `clear: left | right | both`
   *
   * Default: *an empty string*. It means there is no limitation.
   *
   * The real meaning depends on the layout. Currently, only the following
   * layouts support this property.
   *
   * ##[TileLayout]
   *
   * If `clear` is `left`, the view must be the first view in the row.  
   * If `right`, the view must be the last view in the row.  
   * If `both`, the view must be the only view in the row.
   */
  String clear;
}
