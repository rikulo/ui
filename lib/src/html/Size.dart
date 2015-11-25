//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 14, 2012  4:50:59 PM
// Author: tomyeh
part of rikulo_html;

/**
 * The size.
 */
class Size {
  
  /** The width. */
  final num width;
  
  /** The height. */
  final num height;
  
  /** Construct a Size object with given width and height. */
  const Size(this.width, this.height);
  /** Construct a Size object by cloning another. */
  Size.from(Size other) : this(other.width, other.height);
  
  /** Return true if two Size have the same values on both dimensions. */
  bool operator ==(Size other)
  => other is Size && width == other.width && height == other.height;

  @override  
  int get hashCode => (width + height).toInt();
  @override  
  String toString() => "($width, $height)";
}

/**
 * The 3d size.
 */
class Size3D extends Size  {
  
  /** The depth. */
  final num depth;
  
  /** Construct a Size3D object with given width, height, and depth. */
  const Size3D(num width, num height, this.depth): super(width, height);
  /** Construct a Size3D object by cloning another. */
  Size3D.from(Size3D other) : this(other.width, other.height, other.depth);
  
  /** Return true if two Size3D have the same values on all dimensions. */
  bool operator ==(Size3D other)
  => other is Size3D && width == other.width && height == other.height
  && depth == other.depth;
  
  int get hashCode => (width + height + depth).toInt();
  String toString() => "($width, $height, $depth)";
}
