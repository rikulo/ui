//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:49:01 PM
// Author: tomyeh

/**
 * The offset (aka., position).
 */
interface Offset extends Hashable default _Offset {
  
  /** The left offset. */
  num left;
  /** The top offset. */
  num top;
  /** The left offset (the same as [left], i.e., an alias). */
  num x;
  /** The top offset (the same as [top], i.e., an alias). */
  num y;

  Offset(num left, num top);
  Offset.from(Offset other);

  bool operator ==(Offset other);
  Offset operator -(Offset other);
  Offset operator +(Offset other);
  Offset operator *(num scalar);
  Offset operator /(num scalar);
  
  /** The Euclidean norm of the offset as a vector.
   */
  num norm();
  
  /** Return an Offset with the same direction but unit length. i.e. the unit
   * vector of this Offset.
   */
  Offset unit();
  
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
  => other is Offset && left == other.left && top == other.top;
  Offset operator -(Offset other)
  => new Offset(left - other.left, top - other.top);
  Offset operator +(Offset other)
  => new Offset(left + other.left, top + other.top);
  Offset operator *(num scalar)
  => new Offset(left * scalar, top * scalar);
  Offset operator /(num scalar)
  => new Offset(left / scalar, top / scalar);
  
  num norm() => left == null || top == null ? null : sqrt(left * left + top * top);
  
  Offset unit() {
    num n = norm();
    return n != null && n > 0 ? this / n : null;
  }
  
  int hashCode() => (left + top).toInt();
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
  => other is Offset3d && left == other.left && top == other.top && zIndex == other.zIndex;
  Offset3d operator -(Offset3d other)
  => new Offset3d(left - other.left, top - other.top, zIndex - other.zIndex);
  Offset3d operator +(Offset3d other)
  => new Offset3d(left + other.left, top + other.top, zIndex + other.zIndex);
  Offset3d operator *(num scalar)
  => new Offset3d(left * scalar, top * scalar, zIndex * scalar);
  Offset3d operator /(num scalar)
  => new Offset3d(left / scalar, top / scalar, zIndex / scalar);
  
  num norm() => left == null || top == null || zIndex == null ? null : 
    sqrt(left * left + top * top + zIndex * zIndex);
  
  int hashCode() => (x + y + z).toInt();
  String toString() => "($x, $y, $z)";
}

/** An utility that supplies velocity based on given snapshot of position-time
 * pairs. This utility is designed to avoid calculating velocity from an 
 * excessively small denominator. 
 */
class VelocityProvider {
  
  final int _threshold;
  Offset _pos, _vel = new Offset(0, 0);
  int _time;
  
  /** Initialize the provider with current time and position, which guarantees
   * to supply velocity value from calculation that uses a denominator greater 
   * than the [threshold]. As a tradeoff, the velocity will only be updated
   * roughly in a period of [threshold] milliseconds.
   */
  VelocityProvider(Offset position, int time, [int threshold = 0]) : 
    _pos = position, _time = time, _threshold = max(threshold, 0);
  
  /** Provide latest position and time.
   */
  void snapshot(Offset position, int time) {
    final int diffTime = time - _time;
    if (diffTime > _threshold) {
      _vel = (position - _pos) / diffTime;
      _time = time;
      _pos = position;
    }
  }
  
  /** Retrieve velocity.
   */
  Offset get velocity() => _vel;
  
}
