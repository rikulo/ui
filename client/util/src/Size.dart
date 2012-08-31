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
  String get name => _name;

  operator==(other) => this === other;
  String toString() => _name;
}

/**
 * The size.
 */
interface Size default _Size {
  
  /** The width. */
  num get width;
  
  /** The height. */
  num get height;
  
  /** Construct a Size object with given width and height. */
  Size(num width, num height);
  
  /** Construct a Size object by cloning another. */
  Size.from(Size other);
  
  /** Return true if two Size have the same values on both dimensions. */
  bool operator ==(Size other);
  
}

/**
 * The 3d size.
 */
interface Size3d extends Size default _Size3d {
  
  /** The depth. */
  num get depth;
  
  /** Construct a Size3d object with given width, height, and depth. */
  Size3d(num width, num height, num depth);
  
  /** Construct a Size3d object by cloning another. */
  Size3d.from(Size3d otehr);
  
  /** Return true if two Size3d have the same values on all dimensions. */
  bool operator ==(Size3d other);
  
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
  num get right;
  
  /** The Y coordinate of the bottom side (excluded).
   *
   * Note: its meaning is different from CSS's bottom property
   * (which is the distance to the bottom edge)
   */
  num get bottom;
  
  /** Construct a Rectangle with give boundary values. */
  Rectangle(num left, num top, num right, num bottom);
  
  /** Construct a Rectangle by cloning another. */
  Rectangle.from(Rectangle other);
  
  /** Return true if the two Rectangles have the same left, right, top, bottom values. */
  bool operator ==(Rectangle other);
  
  /** Return true if offset is contained in the Rectangle. */
  bool contains(Offset offset);
  
  /** Return the closest Offset contained in the Rectangle. */
  Offset snap(Offset offset);
  
}

class _Size implements Size {
  
  final num width, height;
  
  const _Size(this.width, this.height);
  _Size.from(Size other) : this(other.width, other.height);
  
  bool operator ==(Size other)
  => other is Size && width == other.width && height == other.height;
  
  int hashCode() => (width + height).toInt();
  String toString() => "($width, $height)";
  
}

class _Size3d extends _Size implements Size3d {
  
  final num depth;
  
  const _Size3d(num width, num height, this.depth) : super(width, height);
  _Size3d.from(Size3d other): this(other.width, other.height, other.depth);
  
  bool operator ==(Size3d other)
  => other is Size3d && width == other.width && height == other.height
  && depth == other.depth;
  
  int hashCode() => (width + height + depth).toInt();
  String toString() => "($width, $height, $depth)";
  
}

class _Rectangle extends _Offset implements Rectangle {
  
  final num right, bottom;
  
  const _Rectangle(num left, num top, this.right, this.bottom) : super(left, top);
  _Rectangle.from(Rectangle other)
  : this(other.left, other.top, other.right, other.bottom);
  
  num get width => right - left;
  num get height => bottom - top;
  
  bool operator ==(Rectangle other)
  => other is Rectangle && left == other.left && top == other.top
  && right == other.right && bottom == other.bottom;
  
  bool contains(Offset offset) => 
      (left == null || left <= offset.left) && 
      (right == null || right > offset.left) && 
      (top == null || top <= offset.top) && 
      (bottom == null || bottom > offset.top);
  
  Offset snap(Offset offset) => 
      new Offset(
        min(max(offset.left, left), right),
        min(max(offset.top, top), bottom));
  
  int hashCode() => (left + top + right + bottom).toInt();
  String toString() => "($left, $top, $right, $bottom)";
  
}
