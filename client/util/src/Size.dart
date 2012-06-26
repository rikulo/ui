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
  num width;
  /** The height. */
  num height;

  Size(num width, num height);
  Size.from(Size other);

  bool operator ==(Size other);
}

class _Size implements Size {
  num width, height;

  _Size(num this.width, num this.height);
  _Size.from(Size other): this(other.width, other.height);

  bool operator ==(Size other)
  => other !== null && width == other.width && height == other.height;

  int hashCode() => (width + height).toInt();
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
  num right;
  /** The Y coordinate of the bottom side (excluded).
   *
   * Note: its meaning is different from CSS's bottom property
   * (which is the distance to the bottom edge)
   */
  num bottom;
  /** The width.
   */
  num width;
  /** The height.
   */
  num height;

  Rectangle(num left, num top, num right, num bottom);
  Rectangle.from(Rectangle other);
}

class _Rectangle extends _Offset implements Rectangle {
  num right, bottom;

  _Rectangle(num left, num top, num this.right, num this.bottom)
  : super(left, top);
  _Rectangle.from(Rectangle other)
  : this(other.left, other.top, other.right, other.bottom);

  num get width() => right - left;
  void set width(num width) {
    right = left + width;
  }
  num get height() => bottom - top;
  void set height(num height) {
    bottom = top + height;
  }
  bool operator ==(Rectangle other)
  => other !== null && left == other.left && top == other.top
  && right == other.right && bottom == other.bottom;
  Rectangle operator -(Rectangle other)
  => new Rectangle(left - other.left, top - other.top, right - other.right, bottom - other.bottom);
  Rectangle operator +(Rectangle other)
  => new Rectangle(left + other.left, top + other.top, right + other.right, bottom + other.bottom);

  int hashCode() => (left + top + right + bottom).toInt();
  String toString() => "($left, $top ,$right, $bottom)";
}
