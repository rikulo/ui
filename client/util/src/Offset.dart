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

	Offset(this.left, this.top);

	String toString() => "($left, $top)";
}
