//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/**
 * An activity is a UI, aka., a desktop, that the user can interact with.
 * An activity is identified with an URL.
 */
class Activity {
	String _title = "";
	View _rootView;

	Activity() {
		_title = application.name; //also force "get application()" to be called
	}

	/** Returns the root view.
	 */
	View get rootView() => _rootView;
	/** Sets the root view.
	 */
	void set rootView(View root) {
		final View prevroot = _rootView;
		_rootView = root;
		if (prevroot != null) {
			if (root.width !== null)
				root.width = prevroot.width;
			if (root.height !== null)
				root.height = prevroot.height;

			if (prevroot.inDocument) {
				throw const UiException("TODO");
			}
		}
	}

	/** Starts the activity.
	 */
	void run([String nodeId="v-main"]) {
		if (activity !== null)
			throw const UiException("Only one activity is allowed");

		activity = this;
		mount_();

		_rootView = new Section();
		_rootView.width = browser.size.width;
		_rootView.height = browser.size.height;
		_rootView.style.overflow = "hidden"; //crop

		application._ready(() {
			onCreate_();

			if (!_rootView.inDocument) {//app might add it to Document manually
				final Element main = document.query("#$nodeId");
				rootView.addToDocument(main != null ? main: document.body);
			}
		});
	}
	/** Initializes the browser window, such as registering the events.
	 */
	void mount_() {
		window.on[browser.mobile || application.inSimulator ? 'deviceOrientation': 'resize'].add((event) {
			updateSize();
		});
	}
	/** Handles resizing, including device's orientation is changed.
	 * It is called automatically, so the application rarely need to call it.
	 */
	void updateSize() {
		final Element caveNode = document.query("#v-main");
		final DomQuery qcave = new DomQuery(caveNode !== null ? caveNode: window);
		browser.size.width = qcave.innerWidth;
		browser.size.height = qcave.innerHeight;

		//Note: we have to check if the size is changed, since deviceOrientation
		//will be always fired when the listener is added.
		if (rootView !== null && (rootView.width != browser.size.width
		|| rootView.height != browser.size.height)) {
			rootView.width = browser.size.width;
			rootView.height = browser.size.height;
			rootView.requestLayout();
		}
	}

	/** Returns the title of this activity.
	 */
	String get title() => _title;
	/** Sets the title of this activity.
	 */
	void set title(String title) {
		document.title = _title = title != null ? title: "";
	}

	/** Called when the activity is starting.
	 * Before calling this method, [rootView] will be instantiated, but
	 * it won't be attached to the document until this method has returned
	 * (for better performaance).
	 * If you'd really like to attach it earlier, you can
	 * invoke [View.addToDocument] manually.
	 * <p>If you prefer to instantiate a different root view, you can
	 * create an instance and then assign to [rootView] directly.
	 */
	void onCreate_() {
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