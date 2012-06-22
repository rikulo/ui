//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:49:01 PM
// Author: tomyeh

/**
 * The offset (aka., position).
 */
interface Offset default _Offset {
  /** The left offset. */
  int left;
  /** The top offset. */
  int top;

  /** The left offset (the same as [left], i.e., an alias).
   */
  int x;
  /** The top offset (the same as [top], i.e., an alias).
   */
  int y;

  Offset(int left, int top);

  bool operator ==(Offset other);
  Offset operator -(Offset other);
  Offset operator +(Offset other);
}
/**
 * The 3D offset.
 */
interface Offset3d extends Offset default _Offset3d {
  /** The Z index. */
  int zIndex;
  /** The Z index (the same as [zIndex], i.e., an alias). */
  int z;

  Offset3d(int x, int y, int z);
}

class _Offset implements Offset {
  int left, top;

  _Offset(int this.left, int this.top);

  int get x() => left;
  void set x(int x) {
    left = x;
  }
  int get y() => top;
  void set y(int y) {
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
  int zIndex;

  _Offset3d(int x, int y, int z): super(x, y), zIndex = z;

  int get z() => zIndex;
  void set z(int z) {
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