//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  6:17:34 PM
// Author: tomyeh

/**
 * A timing function used to calculate the value of the given time point.
 * The time point is ranged from 0 to 1. The caller has to scale it if necessary.
 * <p>The value is also ranged from 0 to 1, unless [add] was called
 * to assign a value other than 1 to the initial (0) or ending time (1),
 * such as <code>add(1, 100)</code>.
 * <p>The caller can also control the value 
 */
interface TimingFunction {
	/** Returns the value of the give time point.
	 */
	num operator[](num time);

	/** Assigns the value for the given time point.
	 */
	num operator[]=(num time, num value);

	/** Removes the value for the given time point.
	 */
	void remove(num time, num value);
	/** Returns all defined time points.
	 */
	//Collectin<num> getTimePoints(); //CONSIDER whether it is useful
}
