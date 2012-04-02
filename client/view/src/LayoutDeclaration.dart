//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:03:14 AM
// Author: tomyeh

/**
 * The layout declaration of a view.
 */
interface LayoutDeclaration extends Declaration
default LayoutDeclarationImpl {
	LayoutDeclaration(View owner);

	/** The type of the layout.
	 * <p>Syntax: <code>type: none | linear | stack | tiles | table;</code>
	 * <p>Default: an empty string, i.e., <code>none</code>.
	 * <p>Notice you can plug in addition custom layouts. Refer to [LayoutManager]
	 * for details.
	 */
	String type;
	/** The orientation.
	 * <p>Syntax: <code>orient: horizontal | vertical;</code>
	 * <p>Default: <code>horizontal</code>
	 */
	String orient;
	/** The spacing among child views.
	 * <p>Syntax: <code>spacing: #n1 [#n2 [#n3 #n4]];</code>
	 */
	String spacing;
	/** The width of each child view.
	 * <p>Syntax: <code>width: #n | content | flex | flex #n;</code>
	 * <p>Default: depends on [type]
	 */
	String width;
	/** The width of each child view.
	 * <p>Syntax: <code>height: #n | content | flex | flex #n;</code>
	 * <p>Default: depends on [type]
	 */
	String height;
}
