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
   * Syntax: `anchor: auto | *CSS selector*;` | `parent`
   *
   * Default: `auto`.
   *
   * If `auto`, the position is decided by parent's layout.
   */
  String anchor;
  /** The anchor view. There are two ways to assign an achor view:
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
   * Default: `top left`
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
   * Default: `start`
   */
  String align;
  /** The spacing of the associated view.
   *
   * Syntax: `#n1 [#n2 [#n3 #n4]]`
   */
  String spacing;

  /** The expected width of the associated view.
   *
   * Syntax: `width: #n | content | flex | flex #n | #n %;`
   *
   * Default: `content`.
   */
  String width;
  /** The expected width of the associated view.
   *
   * Syntax: `height: #n | content | flex | flex #n | #n %`
   *
   * Default: `content`.
   */
  String height;

  /** The expected minimal allowed width of the associated view.
   *
   * Syntax: `min-width: #n | flex | #n %`
   *
   * Default: no limitation.
   *
   * Currently, it is supported only by [TextView], [Image] and their derives,
   * when the width is being measured (i.e., the width depends on content).
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String minWidth;
  /** The expected minmal allowed width of the associated view.
   *
   * Syntax: `min-height: #n | flex | #n %`
   *
   * Default: no limitation.
   *
   * Currently, it is supported only by [TextView], [Image] and their derives,
   * when the height is being measured (i.e., the height depends on content).
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
   * Default: no limitation.
   *
   * Currently, it is supported only by [TextView], [Image] and their derives,
   * when the width is being measured (i.e., the width depends on content).
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
   * Default: no limitation.
   *
   * Currently, it is supported only by [TextView], [Image] and their derives,
   * when the height is being measured (i.e., the height depends on content).
   *
   * Notice that, if, under your layout, the parent's width is decided by
   * the child, don't use flex or percentage at child's profile.
   * Otherwise, it will become zero.
   */
  String maxHeight;
}
