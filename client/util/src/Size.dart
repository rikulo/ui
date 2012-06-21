//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:50:59 PM
// Author: tomyeh

/**
 * The direction enumeration.
 */
class Dir {
  final String _name;

  /** Represents the vertical direction.
   */
  static final Dir VERTICAL = const Dir("vertical");
  /** Represents the horizontal direction.
   */
  static final Dir HORIZONTAL = const Dir("horizontal");
  /** Represents the both direction.
   */
  static final Dir BOTH = const Dir("both");

  const Dir(String this._name);

  /** The name of this direction. */
  String get name() => _name;

  operator==(other) => this === other;
  String toString() => _name;
}

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

/**
 * A rectange.
 */
interface Rectangle extends Offset, Size default _Rectangle {
  /** The X coordinate of the right side (excluded).
   *
   * Note: its meaning is different from CSS's right property
   * (which is the distance to the right edge)
   */
  int right;
  /** The Y coordinate of the bottom side (excluded).
   *
   * Note: its meaning is different from CSS's bottom property
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
  Rectangle operator -(Rectangle other)
  => new Rectangle(left - other.left, top - other.top, right - other.right, bottom - other.bottom);
  Rectangle operator +(Rectangle other)
  => new Rectangle(left + other.left, top + other.top, right + other.right, bottom + other.bottom);

  int hashCode() => left + top + right + bottom;
  String toString() => "($left, $top ,$right, $bottom)";
}
