//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  9:57:18 PM
// Author: tomyeh

/**
 * An effect used to change values of the given object
 * in the given duration.
 */
interface Effect {
	/** The target to apply the effect.
	 */
	get target();
	/** The duration to play the effect.
	 */
	int duration;
	/** Stops this effect.
	 */
	void stop();
}
