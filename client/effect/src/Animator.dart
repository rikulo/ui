//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  7:12:55 PM
// Author: tomyeh

/**
 * The animator used to play [Animation].
 * <p>Instead of instantiating an instance of [Animator], a global
 * object called [animator] can be used for better performance.
 */
interface Animator {
	/** Starts an animation.
	 */
	void play(Animation animation);
	/** Pauses this animation.
	 */
	void pause(Animation animation);
	/** Stops this animation.
	 * <p>Once the animation is stopped, it is no longer
	 * managed by the animator.
	 */
	void stop(Animation animation);
}
/** Returns the animator.
 */
Animator get animator() {
}
