//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012 12:33:28 PM
// Author: tomyeh

/**
 * An animation.
 */
interface Animation {
	/** Callback to update the animation.
	 * It is called when the animation is playing.
	 * <p>If false is returned, the animation will be stopped
	 * automatically.
	 * <p>[time] is the milliseconds from 1970-01-01 (UTC).
	 * In other words, it is the same as <code>new Date.now().value</code>.
	 */
	bool next(int time);

	/** Callback when this animation is stopped.
	 * <p>The application shall not invoke this method directly.
	 * Rather, it shall invoke [Animator.stop] instead.
	 */
	void stop();
	/** Callback when this animation is paused.
	 * <p>The application shall not invoke this method directly.
	 * Rather, it shall invoke [Animator.pause] instead.
	 */
	void pause();

	/** Returns if the animation is ended.
	 */
	bool get ended();
	/** Returns if the animation is paused.
	 */
	bool get paused();
}
