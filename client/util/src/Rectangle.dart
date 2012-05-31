//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 11, 2012 11:28:53 PM
// Author: tomyeh

/**
 * A rectange.
 */
interface Rectangle extends Offset, Size default _Rectangle {
	/** The X coordinate of the right side (excluded).
	 * <p>Note: its meaning is different from CSS's right property
	 * (which is the distance to the right edge)
	 */
	int right;
	/** The Y coordinate of the bottom side (excluded).
	 * <p>Note: its meaning is different from CSS's bottom property
	 * (which is the distance to the bottom edge)
	 */
	int bottom;
	/** The width.
	 */
	int width;
	/** The height.
	 */
	int height;

	Rectangle(int left, int top, int right, int bottom);
}

class _Rectangle extends _Offset implements Rectangle {
	int right, bottom;

	_Rectangle(int left, int top, int this.right, int this.bottom)
	: super(left, top);

	int get width() => right - left;
	void set width(int width) {
		right = left + width;
	}
	int get height() => bottom - top;
	void set height(int height) {
		bottom = top + height;
	}
	bool operator ==(Rectangle other)
	=> other !== null && left == other.left && top == other.top
	&& right == other.right && bottom == other.bottom;
	Offset operator -(Rectangle other)
	=> new Rectangle(left - other.left, top - other.top, right - other.right, bottom - other.bottom);
	Offset operator +(Rectangle other)
	=> new Rectangle(left + other.left, top + other.top, right + other.right, bottom + other.bottom);

	int hashCode() => left + top + right + bottom;
	String toString() => "($left, $top ,$right, $bottom)";
}
