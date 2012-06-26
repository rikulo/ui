//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
// Author: simon

/**
 * A two dimentional vector.
 */
interface Vector extends Offset default _Vector {
  
  Vector(num x, num y);
  
  Vector operator -(Vector other); // overload to return Vector
  Vector operator +(Vector other); // overload to return Vector
  
  /**
   * Return the magnitude of this Vector.
   */
  num get length();
  
  // TODO: product, rotation, scalar
  
}

class _Vector extends _Offset implements Vector {
  
  num x, y;
  
  _Vector(num x, num y) : super(x, y);
  
  Vector operator -(Vector other) => new _Vector(x - other.x, y - other.y);
  Vector operator +(Vector other) => new _Vector(x + other.x, y + other.y);
  
  num get length() => Math.sqrt(x*x + y*y);
  
}
