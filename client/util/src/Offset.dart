//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:49:01 PM
// Author: tomyeh

/**
 * The offset (aka., position).
 */
interface Offset default _Offset {
  /** The left offset. */
  num left;
  /** The top offset. */
  num top;

  /** The left offset (the same as [left], i.e., an alias).
   */
  num x;
  /** The top offset (the same as [top], i.e., an alias).
   */
  num y;

  Offset(num left, num top);
  Offset.from(Offset other);

  bool operator ==(Offset other);
  Offset operator -(Offset other);
  Offset operator +(Offset other);
}
/**
 * The 3D offset.
 */
interface Offset3d extends Offset default _Offset3d {
  /** The Z index. */
  num zIndex;
  /** The Z index (the same as [zIndex], i.e., an alias). */
  num z;

  Offset3d(num x, num y, num z);
  Offset3d.from(Offset3d other);
}

class _Offset implements Offset {
  num left, top;

  _Offset(num this.left, num this.top);
  _Offset.from(Offset other): this(other.left, other.top);

  num get x() => left;
  void set x(num x) {
    left = x;
  }
  num get y() => top;
  void set y(num y) {
    top = y;
  }

  bool operator ==(Offset other)
  => other !== null && left == other.left && top == other.top;
  Offset operator -(Offset other)
  => new Offset(left - other.left, top - other.top);
  Offset operator +(Offset other)
  => new Offset(left + other.left, top + other.top);

  int hashCode() => left + top;
  String toString() => "($left, $top)";
}

class _Offset3d extends _Offset implements Offset3d {
  num zIndex;

  _Offset3d(num x, num y, num z): super(x, y), zIndex = z;
  _Offset3d.from(Offset3d other): this(other.x, other.y, other.z);

  num get z() => zIndex;
  void set z(num z) {
    zIndex = z;
  }

  bool operator ==(Offset3d other)
  => other !== null && left == other.left && top == other.top && zIndex == other.zIndex;
  Offset3d operator -(Offset3d other)
  => new Offset3d(left - other.left, top - other.top, zIndex - other.zIndex);
  Offset3d operator +(Offset3d other)
  => new Offset3d(left + other.left, top + other.top, zIndex + other.zIndex);

  int hashCode() => x + y + z;
  String toString() => "($x, $y, $z)";
}