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

	/** The expected width of the associated view.
	 * <p>Syntax: <code>width: #n | content | flex | flex #n;</code>
	 * <p>Default: <code>content</code>.
	 */
	String width;
	/** The expected width of the associated view.
	 * <p>Syntax: <code>height: #n | content | flex | flex #n;</code>
	 * <p>Default: <code>content</code>.
	 */
	String height;

	/** The expected minimal allowed width of the associated view.
	 * <p>Syntax: <code>min-width: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String minWidth;
	/** The expected minmal allowed width of the associated view.
	 * <p>Syntax: <code>min-height: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String minHeight;

	/** The expected maximal allowed width of the associated view.
	 * <p>Syntax: <code>max-width: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String maxWidth;
	/** The expected maximal allowed width of the associated view.
	 * <p>Syntax: <code>max-height: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String maxHeight;
}
