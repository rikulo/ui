//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/**
 * An activity is a UI, aka., a desktop, that the user can interact with.
 * An activity is identified with an URL.
 */
class Activity {
	Activity() {
		if (device === null)
			device = new Device();
	}

	/** Start the activity.
	 */
	void run() {
		if (activity !== null)
			throw const UiException("Only one activity is allowed");
		activity = this;
		onCreate_(createMainWindow_());
	}

	/** Called to instantiate the main window.
	 * Don't call this method directly. It is a callback that
	 * you can override to provide a different instance if necessary.
	 * <p>Default: it creates an instance of [Zone] and initializes
	 * it to fill the whole screen.
	 */
	View createMainWindow_() {
		final View main = new Zone();
		main.classes.add("v-main");
		main.addToDocument(document.body);
		return main;
	}
	/** Called when the activity is starting.
	 */
	void onCreate_(View mainWindow) {
	}
	/** Called when the activity is going into background.
	 */
	void onPause_() {
	}
	/** Called when the activity is resumed to start interacting
	 * with the user.
	 */
	void onResume_() {
	}
	/** Called when the activity is destroyed.
	 */
	void onDestroy_() {
	}
}
/** The current activity. */
Activity activity;