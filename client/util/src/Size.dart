//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:50:59 PM
// Author: tomyeh

/**
 * The size.
 */
class Size {
	/** The width. */
	int width;
	/** The height. */
	int height;

	Size(int this.width, int this.height);

	bool operator ==(Size other) {
		return other !== null && width == other.width && height == other.height;
	}

	String toString() => "($width, $height)";
}
