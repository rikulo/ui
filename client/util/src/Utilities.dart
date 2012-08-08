//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 06, 2012  5:11:49 PM
// Author: tomyeh

/** A task that is a function taking no argument and returning nothing.
 */
typedef void Task();
/** A function that returns an integer.
 */
typedef int AsInt();
/** A function that returns a double.
 */
typedef double AsDouble();
/** A function that returns a string.
 */
typedef String AsString();
/** A function that returns a bool.
 */
typedef bool AsBool();
/** A function that returns a [Offset].
 */
typedef Offset AsOffset();
/** A function that returns a [Offset3d].
 */
typedef Offset3d AsOffset3d();
/** A function that returns a [Size].
 */
typedef Size AsSize();
/** A function that returns a [Rectangle].
 */
typedef Rectangle AsRectangle();

/** A function that returns a map.
 */
typedef Map AsMap();
/** A function that returns a list.
 */
typedef List AsList();

/**
 * Represents an input that store a value.
 */
interface Input<T> {
  /** The value. */
  T value;
}
