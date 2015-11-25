//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:49:01 PM
// Author: tomyeh
part of rikulo_html;

///A collection of [Point] utilities
class Points {
  /** The Euclidean norm of the offset as a vector.
   */
  static num norm(Point pt) {
    num val = pt.x * pt.x + pt.y * pt.y;
    if (pt is Point3D) {
      final z = pt.z;
      val += z * z;
    }
    return sqrt(val);
  }
  /** Return an [Point] with the same direction but unit length. i.e. the unit
   * vector of this [Point].
   */
  static Point unit(Point pt) {
    num n = norm(pt);
    return n > 0 ? divide(pt, n) : null;
  }

  ///Divides a factor for each coordinates
  static Point divide(Point pt, num factor) {
    final x = pt.x / factor,
          y = pt.y / factor;
    return pt is Point3D ? new Point3D(x, y, pt.z / factor): new Point(x, y);
  }

  ///Instantiate a poitn form a rectangle
  static Point from(Rectangle rect) => new Point(rect.left, rect.top);

  ///Return the closest dimension contained in a rectangle.
  static Point snap(Rectangle rect, Point pt) => 
      new Point(min(max(pt.x, rect.left), rect.right), 
          min(max(pt.y, rect.top), rect.bottom));
}

/**
 * The 3D point.
 */
class Point3D<T extends num> extends Point<T> {
  /** The Z index. */
  final T z;

  const Point3D(T x, T y, T z) : this.z = z, super(x, y);
  Point3D.from(Point3D other) : this(other.x, other.y, other.z);

  @override
  bool operator ==(Point3D other)
  => other is Point3D && x == other.x && y == other.y && z == other.z;
  @override
  Point3D operator -(Point other)
  => new Point3D(x - other.x, y - other.y,
      other is Point3D ? z - other.z: z);
  @override
  Point3D operator +(Point other)
  => new Point3D(x + other.x, y + other.y,
      other is Point3D ? z + other.z: z);
  @override
  Point3D operator *(num scalar)
  => new Point3D(x * scalar, y * scalar, z * scalar);
  Point3D operator /(num factor)
  => new Point3D(x / factor, y / factor, z / factor);
  
  @override  
  double distanceTo(Point3D other) {
    var dx = x - other.x;
    var dy = y - other.y;
    var dz = other is Point3D ? z - other.z: z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }
  ///Applies [ceil] to each element
  Point3D ceil() => new Point3D(x.ceil(), y.ceil(), z.ceil());
  ///Applies [floor] to each element
  Point3D floor() => new Point3D(x.floor(), y.floor(), z.floor());
  ///Applies [round] to each element
  Point3D round() => new Point3D(x.round(), y.round(), z.round());
  ///Applies [toInt] to each element
  Point3D<int> toInt() => new Point3D(x.toInt(), y.toInt(), z.toInt());

  @override  
  int get hashCode => (x + y + z).toInt();
  @override  
  String toString() => "($x, $y, $z)";
}

/** An utility that supplies velocity based on given snapshot of position-time
 * pairs. This utility is designed to avoid calculating velocity from an 
 * excessively small denominator. 
 */
class VelocityProvider {
  Point _pos, _vel;
  int _time;
  
  /** Initialize the provider with current time and position. */
  VelocityProvider(Point position, int time) : _pos = position, _time = time {
    _vel = new Point(0, 0);
  }
  
  /** Provide latest position and time. */
  void snapshot(Point position, int time) {
    final int diffTime = time - _time;
    if (diffTime > 0) {
      _vel = Points.divide(position - _pos, diffTime);
      _time = time;
      _pos = position;
    }
  }
  
  /** Retrieve velocity. */
  Point get velocity => _vel; 
}
