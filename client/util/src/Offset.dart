//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:49:01 PM
// Author: tomyeh

/**
 * The offset (aka., position).
 */
class Offset {
	/** The left offset. */
	int left;
	/** The top offset. */
	int top;

	Offset(int this.left, int this.top);

	/** The X offset (the same as [left]).
	 */
	int get x() => left;
	/** The X offset (the same as [left]).
	 */
	void set x(int x) {
		left = x;
	}
	/** The Y offset (the same as [top]).
	 */
	int get y() => top;
	/** The Y offset (the same as [top]).
	 */
	void set y(int y) {
		top = y;
	}

	String toString() => "($left, $top)";
}

/**
 * The 3D offset.
 */
class Offset3d extends Offset {
	int zIndex;

	Offset3d(int x, int y, int z): super(x, y), zIndex = z {
	}

	/** The Z offset (the same as [zIndex]).
	 */
	int get z() => zIndex;
	/** The Y offset (the same as [zIndex]).
	 */
	void set z(int z) {
		zIndex = z;
	}

	String toString() => "($x, $y, $z)";
}