//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:50:59 PM
// Author: tomyeh
part of rikulo_util;

/**
 * The direction enumeration.
 */
class Dir {
  /** Represents the vertical direction.
   */
  static const Dir VERTICAL = const Dir._("vertical");
  /** Represents the horizontal direction.
   */
  static const Dir HORIZONTAL = const Dir._("horizontal");
  /** Represents the both direction.
   */
  static const Dir BOTH = const Dir._("both");

  const Dir._(String this.name);

  /** The name of this direction. */
  final String name;

  operator==(other) => identical(this, other);
  String toString() => name;
}

/**
 * The size.
 */
class Size {
  
  /** The width. */
  final num width;
  
  /** The height. */
  final num height;
  
  /** Construct a Size object with given width and height. */
  const Size(num this.width, num this.height);
  /** Construct a Size object by cloning another. */
  Size.from(Size other) : this(other.width, other.height);
  
  /** Return true if two Size have the same values on both dimensions. */
  bool operator ==(Size other)
  => other is Size && width == other.width && height == other.height;

  //@override  
  int get hashCode => (width + height).toInt();
  //@override  
  String toString() => "($width, $height)";
}

/**
 * The 3d size.
 */
class Size3d extends Size  {
  
  /** The depth. */
  final num depth;
  
  /** Construct a Size3d object with given width, height, and depth. */
  const Size3d(num width, num height, num this.depth): super(width, height);
  /** Construct a Size3d object by cloning another. */
  Size3d.from(Size3d other) : this(other.width, other.height, other.depth);
  
  /** Return true if two Size3d have the same values on all dimensions. */
  bool operator ==(Size3d other)
  => other is Size3d && width == other.width && height == other.height
  && depth == other.depth;
  
  int get hashCode => (width + height + depth).toInt();
  String toString() => "($width, $height, $depth)";
}

/**
 * A rectange.
 */
class Rectangle extends Offset implements Size {
  
  /** The X coordinate of the right side (excluded).
   *
   * Note: its meaning is different from CSS's right property
   * (which is the distance to the right edge)
   */
  final num right;
  /** The Y coordinate of the bottom side (excluded).
   *
   * Note: its meaning is different from CSS's bottom property
   * (which is the distance to the bottom edge)
   */
  final num bottom;
  
  /** Construct a Rectangle with give boundary values. */
  const Rectangle(num left, num top, this.right, this.bottom) : super(left, top);
  /** Construct a Rectangle by cloning another. */
  Rectangle.from(Rectangle other)
  : this(other.left, other.top, other.right, other.bottom);

  //@override
  num get width => right - left;
  //@override
  num get height => bottom - top;

  /** Return true if the two Rectangles have the same left, right, top, bottom values. */
  bool operator ==(Rectangle other)
  => other is Rectangle && left == other.left && top == other.top
  && right == other.right && bottom == other.bottom;
  
  /** Return true if offset is contained in the Rectangle. */
  bool contains(Offset offset) => 
      (left == null || left <= offset.left) && 
      (right == null || right > offset.left) && 
      (top == null || top <= offset.top) && 
      (bottom == null || bottom > offset.top);
  
  /** Return the closest Offset contained in the Rectangle. */
  Offset snap(Offset offset) => 
      new Offset(
        min(max(offset.left, left), right),
        min(max(offset.top, top), bottom));

  int get hashCode => (left + top + right + bottom).toInt();
  String toString() => "($left, $top, $right, $bottom)";
}

