//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:50:59 PM
// Author: tomyeh

/**
 * The size.
 */
interface Size default _Size {
	/** The width. */
	int width;
	/** The height. */
	int height;

	Size(int width, int height);
	bool operator ==(Size other);
}

class _Size implements Size {
	int width, height;

	_Size(int this.width, int this.height);

	bool operator ==(Size other)
	=> other !== null && width == other.width && height == other.height;

	int hashCode() => width + height;
	String toString() => "($width, $height)";
}
