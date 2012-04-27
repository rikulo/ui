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
	 * <p>Syntax: <code>anchor: auto | <i>CSS selector</i>;</code> | <code>parent</code>
	 * <p>Default: <code>auto</code>.
	 * <p>If <code>auto</code>, the position is decided by parent's layout.
	 */
	String anchor;
	/** The anchor view. There are two ways to assign an achor view:
	 * 1) assign a value to [anchor], or 2) assign a view to [anchorView].
	 * <p>Notice that the anchor view must be the parent or one of the
	 * siblings.
	 */
	View anchorView;

	/** The location of the associated view.
	 * It is used only if [anchor] is not assigned with an non-empty value
	 * (or [anchorView] is assigned with a view).
	 */
	String location;

	/** The alignment.
	 * <p>Syntax: <code>align: start | center | end;</code>
	 * <p>Default: <code>start</code>
	 */
	String align;
	/** The spacing of the associated view.
	 * <p>Syntax: <code>#n1 [#n2 [#n3 #n4]]</code>
	 */
	String spacing;

	/** The expected width of the associated view.
	 * <p>Syntax: <code>width: #n | content | flex | flex #n | #n %;</code>
	 * <p>Default: <code>content</code>.
	 */
	String width;
	/** The expected width of the associated view.
	 * <p>Syntax: <code>height: #n | content | flex | flex #n | #n %;</code>
	 * <p>Default: <code>content</code>.
	 */
	String height;

	/** The expected minimal allowed width of the associated view.
	 * <p>Syntax: <code>min-width: #n | flex | #n %;</code>
	 * <p>Default: no limitation.
	 * <p>Currently, it is supported only by [TextView], [Image] and their derives,
	 * when the width is being measured (i.e., the width depends on content).
	 * <p>Notice that, if, under your layout, the parent's width is decided by
	 * the child, don't use flex or percentage at child's profile.
	 * Otherwise, it will become zero.
	 */
	String minWidth;
	/** The expected minmal allowed width of the associated view.
	 * <p>Syntax: <code>min-height: #n | flex | #n %;</code>
	 * <p>Default: no limitation.
	 * <p>Currently, it is supported only by [TextView], [Image] and their derives,
	 * when the height is being measured (i.e., the height depends on content).
	 * <p>Notice that, if, under your layout, the parent's width is decided by
	 * the child, don't use flex or percentage at child's profile.
	 * Otherwise, it will become zero.
	 */
	String minHeight;

	/** The expected maximal allowed width of the associated view.
	 * <p>Syntax: <code>max-width: #n | flex | #n %;</code>
	 * <p>Default: no limitation.
	 * <p>Currently, it is supported only by [TextView], [Image] and their derives,
	 * when the width is being measured (i.e., the width depends on content).
	 * <p>Notice that, if, under your layout, the parent's width is decided by
	 * the child, don't use flex or percentage at child's profile.
	 * Otherwise, it will become zero.
	 */
	String maxWidth;
	/** The expected maximal allowed width of the associated view.
	 * <p>Syntax: <code>max-height: #n | flex | #n %;</code>
	 * <p>Default: no limitation.
	 * <p>Currently, it is supported only by [TextView], [Image] and their derives,
	 * when the height is being measured (i.e., the height depends on content).
	 * <p>Notice that, if, under your layout, the parent's width is decided by
	 * the child, don't use flex or percentage at child's profile.
	 * Otherwise, it will become zero.
	 */
	String maxHeight;
}
