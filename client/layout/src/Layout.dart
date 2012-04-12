//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:38 AM
// Author: tomyeh

/**
 * A layout controller that arranges the layout of the child views.
 */
interface Layout default FreeLayout {
	/** Measure the width of the given view.
	 */
	int measureWidth(MeasureContext ctx, View view);
	/** Measure the width of the given view.
	 */
	int measureHeight(MeasureContext ctx, View view);

	/** Handles the layout of the given view.
	 */
	void layout(MeasureContext ctx, View view);

	/** Returns the default value of the given profile's property.
	 */
	String getDefaultProfileProperty(View view, String propertyName);
	/** Returns the default value of the given layout's property.
	 */
	String getDefaultLayoutProperty(View view, String propertyName);
}

/**
 * A skeletal implementation of [Layout].
 */
//abstract //TODO: until Dart allows it
class AbstractLayout implements Layout {
	String getDefaultLayoutProperty(View view, String name)	=> "";
	String getDefaultProfileProperty(View view, String name) => "";
}
