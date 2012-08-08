//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 25, 2012  11:34:48 PM
// Author: simon

/**
 * A collection of Offset utility as math vectors.
 */
class VectorUtil {
  
  /**
   * Return the length (Euclidean distance) of an Offset as a vertor. 
   */
  static num norm(Offset off) => sqrt(off.x * off.x + off.y * off.y);
  
  /**
   * Return the inner product of two Offsets as vertors. 
   */
  static num innerProduct(Offset off1, Offset off2) => off1.x * off2.x + off1.y * off2.y;
  
  // TODO: 3D version
  
}
