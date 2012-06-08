//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  6:17:34 PM
// Author: tomyeh

/**
 * An effect function used with [Effect] to calculate the value over time.
 */
interface EffectFunction {
  /** Constructor.
   *
   * + [endValue] specifies the value when the time runs out,
   * while the initial value is assumed to be zero.
   * + [duration] specifies the duration of time to elapse in milliseconds.
   */
  //EffectFunction(int endValue, int duration);

  /** Returns the value of the give time point.
   */
  int operator[](int millisec);

  /** Assigns the value for the given time point.
   */
  int operator[]=(int millisec, int value);

  /** Removes the value for the given time point.
   */
  void remove(int millisec, int value);
  /** Returns all defined time points.
   */
  //Collectin<num> get timePoints(); //CONSIDER whether it is useful
}
