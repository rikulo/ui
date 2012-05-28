//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/**
 * An activity is a UI, aka., a desktop, that the user can interact with.
 * An activity is identified with an URL.
 */
class Activity {
	String _title = "";
	View _mainView;
	final List<View> _popups;

	Activity(): _popups = [] {
		_title = application.name; //also force "get application()" to be called
	}

	/** Returns the main view.
	 * The main view is the view the activity is working on.
	 * A default view (an instance of [Section]) is created when [run]
	 * is called. You can change it to any view you like at any time by
	 * calling [set mainView].
	 *
	 * <p>The main view is a root view, i.e., it doesn't have any parent.
	 * In additions, its size has been adjusted to cover the whole screen
	 * (or the whole DOM element specified in the nodeId parameter of [run] if
	 * there is one).
	 */
	View get mainView() => _mainView;
	/** Sets the main view.
	 */
	void set mainView(View main) {
		final View prevroot = _mainView;
		_mainView = main;
		if (prevroot != null) {
			if (main.width !== null)
				main.width = prevroot.width;
			if (main.height !== null)
				main.height = prevroot.height;

			if (prevroot.inDocument) {
				throw const UIException("TODO");
			}
		}
	}

	/** Returns the topmost popup, or null if no popup at all.
	 * A popup is a view sitting on top of [mainView].
	 * A popup is also a root view, i.e., it has no parent.
	 * <p>An activity has at most one [mainView], while it might have
	 * any number of popups. To add a popup, please use [addPopup].
	 * The last added popup will be on top of the rest, including [mainView].
	 */
	View get popup() => _popups.isEmpty() ? null: _popups[0];
	/** Adds a popup. The popup will become the topmost view and obscure
	 * the other popups and [mainView].
	 *
	 * <p>If specified, [effect] controls how to make the given popup visible.
	 *
	 * <p>To obscure the popups and mainView under it, a semi-transparent mask
	 * will be inserted on top of them and underneath the given popup.
	 * You can control the transparent and styles by giving a different CSS
	 * class with [maskClass]. If you don't want the mask at all, you can specify
	 * <code>null</code> to [maskClass].
	 */
	void addPopup(View popup, [ViewEffect effect, String maskClass="v-mask"]) {
	}
	/** Removes the topmost popup or the given popup.
	 * If [popup] is not specified, the topmost one is assumed.
	 * <p>If specified, [effect] controls how to make the given popup invisible.
	 */
	void removePopup([View popup, ViewEffect effect]) {
	}

	/** Starts the activity.
	 * <p>By default, it creates [mainView] (if it was not created yet)
	 * and has it to occupies the whole screen.
	 *
	 * <p>If the DOM element specified in [nodeId] is found, [mainView]
	 * will only occupy the DOM element. It is useful if you'd like
	 * to have multiple activities (i.e., Dart applications) running
	 * at the same time and each of them handles only a portion of the
	 * screen.
	 */
	void run([String nodeId="v-main"]) {
		if (activity !== null) //TODO: switching activity
			throw const UIException("Only one activity is allowed");

		activity = this;
		mount_();

		if (_mainView === null)
			_mainView = new Section();
		_mainView.width = browser.size.width;
		_mainView.height = browser.size.height;
		_mainView.style.overflow = "hidden"; //crop

		application._ready(() {
			onCreate_();

			if (!_mainView.inDocument && nodeId !== null) {//app might add it to Document manually
				final Element main = document.query("#$nodeId");
				mainView.addToDocument(main != null ? main: document.body);
			}

			onEnterDocument_();
		});
	}
	/** Initializes the browser window, such as registering the events.
	 */
	void mount_() {
		window.on[browser.mobile || application.inSimulator ? 'deviceOrientation': 'resize'].add(
			(event) { //DOM event
				updateSize();
			});
		document.on[browser.touch ? 'touchStart': 'mouseDown'].add(
			(event) { //DOM event
				broadcaster.sendEvent(new PopupEvent(event.target));
			});
	}
	/** Handles resizing, including device's orientation is changed.
	 * It is called automatically, so the application rarely need to call it.
	 */
	void updateSize() {
		final Element caveNode = document.query("#v-main");
		final DOMQuery qcave = new DOMQuery(caveNode !== null ? caveNode: window);
		browser.size.width = qcave.innerWidth;
		browser.size.height = qcave.innerHeight;

		//Note: we have to check if the size is changed, since deviceOrientation
		//will be always fired when the listener is added.
		if (mainView !== null && (mainView.width != browser.size.width
		|| mainView.height != browser.size.height)) {
			mainView.width = browser.size.width;
			mainView.height = browser.size.height;
			mainView.requestLayout();
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
	 * Before calling this method, [mainView] will be instantiated, but
	 * it won't be attached to the document until this method has returned
	 * (for better performaance).
	 * If you'd really like to attach it earlier, you can
	 * invoke [View.addToDocument] manually.
	 *
	 * <p>If you prefer to instantiate a different main view, you can
	 * create an instance and then assign to [mainView] directly.
	 *
	 * <p>See also [run].
	 */
	void onCreate_() {
	}
	/**Called after [onCreate_] is called and [mainView] has been
	 * added to the document.
	 *<p>Tasks that depends on DOM elements can be done in this method.
	 */
	void onEnterDocument_() {
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