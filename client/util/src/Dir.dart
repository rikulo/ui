//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 04, 2012 11:57:39 AM
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
  String get name() => _name;

  operator==(other) => this === other;
  String toString() => _name;
}
