//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:15:54 AM
// Author: tomyeh

/**
 * The position declaration of a view.
 */
interface ProfileDeclaration extends Declaration
default ProfileDeclarationImpl {
	ProfileDeclaration(View owner);

	/** The anchor.
	 * <p>Syntax: <code>anchor: auto | <i>CSS selector</i>;</code>
	 * <p>Default: <code>auto</code>.
	 * <p>If <code>auto</code>, the position is decided by parent's layout.
	 */
	String anchor;

	/** The expected width of this view.
	 * <p>Syntax: <code>width: #n | content | flex | flex #n;</code>
	 * <p>Default: <code>content</code>.
	 */
	String width;
	/** The expected width of this view.
	 * <p>Syntax: <code>height: #n | content | flex | flex #n;</code>
	 * <p>Default: <code>content</code>.
	 */
	String height;

	/** The expected minimal allowed width of this view.
	 * <p>Syntax: <code>min-width: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String minWidth;
	/** The expected minmal allowed width of this view.
	 * <p>Syntax: <code>min-height: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String minHeight;

	/** The expected maximal allowed width of this view.
	 * <p>Syntax: <code>max-width: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String maxWidth;
	/** The expected maximal allowed width of this view.
	 * <p>Syntax: <code>max-height: #n | content | flex | flex #n;</code>
	 * <p>Default: no limitation.
	 */
	String maxHeight;
}
