//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:49:01 PM
// Author: tomyeh
part of rikulo_util;

/**
 * The offset (aka., position).
 */
class Offset {
  /** The left offset. */
  final num left;
  /** The top offset. */
  final num top;
  /** The left offset (the same as [left], i.e., an alias). */
  num get x => left;
  /** The top offset (the same as [top], i.e., an alias). */
  num get y => top;

  const Offset(num this.left, num this.top);
  Offset.from(Offset other) : this(other.left, other.top);

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
  
  /** The Euclidean norm of the offset as a vector.
   */
  num norm() => left == null || top == null ? null : sqrt(left * left + top * top);
  
  /** Return an Offset with the same direction but unit length. i.e. the unit
   * vector of this Offset.
   */
  Offset unit() {
    num n = norm();
    return n != null && n > 0 ? this / n : null;
  }

  //@override  
  int get hashCode => (left + top).toInt();
  //@override  
  String toString() => "($left, $top)";
}
/**
 * The 3D offset.
 */
class Offset3d extends Offset {
  /** The Z index. */
  final num zIndex;
  /** The Z index (the same as [zIndex], i.e., an alias). */
  num get z => zIndex;

  const Offset3d(num x, num y, num z) : super(x, y), zIndex = z;
  Offset3d.from(Offset3d other) : this(other.x, other.y, other.z);

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
  
  //@override  
  num norm() => left == null || top == null || zIndex == null ? null : 
    sqrt(left * left + top * top + zIndex * zIndex);
  
  //@override  
  int get hashCode => (x + y + z).toInt();
  //@override  
  String toString() => "($x, $y, $z)";
}

/** An utility that supplies velocity based on given snapshot of position-time
 * pairs. This utility is designed to avoid calculating velocity from an 
 * excessively small denominator. 
 */
class VelocityProvider {
  Offset _pos, _vel;
  int _time;
  
  /** Initialize the provider with current time and position. */
  VelocityProvider(Offset position, int time) : _pos = position, _time = time {
    _vel = new Offset(0, 0);
  }
  
  /** Provide latest position and time. */
  void snapshot(Offset position, int time) {
    final int diffTime = time - _time;
    if (diffTime > 0) {
      _vel = (position - _pos) / diffTime;
      _time = time;
      _pos = position;
    }
  }
  
  /** Retrieve velocity. */
  Offset get velocity => _vel; 
}
