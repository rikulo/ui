//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/**
 * An activity is a UI, aka., a desktop, that the user can interact with.
 * An activity is identified with an URL.
 */
class Activity {
	/** Start the activity.
	 */
	void run() {
		onCreate();
	}

	/** Called when the activity is starting.
	 */
	void onCreate() {
	}
	/** Called when the activity is going into background.
	 */
	void onPause() {
	}
	/** Called when the activity is resumed to start interacting
	 * with the user.
	 */
	void onResume() {
	}
	/** Called when the activity is destroyed.
	 */
	void onDestroy() {
	}
}
