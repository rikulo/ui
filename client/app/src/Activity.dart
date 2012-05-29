//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/** A switching effect for hiding [from] and displaying [to],
 * such as fade-out and slide-in.
 * <p>[mask] is the element inserted between [from] and [to]. It is used
 * to block the access of [from].
 */
typedef void ViewSwitchEffect(View from, View to, Element mask);

/**
 * An activity is a UI, aka., a desktop, that the user can interact with.
 * An activity is identified with an URL.
 */
class Activity {
	String _title = "";
	View _mainView;
	final List<View> _dialogs;

	Activity(): _dialogs = [] {
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
	 * (or the whole DOM element specified in the containerId parameter of [run] if
	 * there is one).
	 */
	View get mainView() => _mainView;
	/** Sets the main view.
	 */
	void set mainView(View main) {
		setMainView(main);
	}
	/** Sets the main view with an effect.
	 */
	void setMainView(View main, [ViewSwitchEffect effect]) {
		final View prevroot = _mainView;
		_mainView = main;
		if (prevroot != null) {
			if (main.width !== null)
				main.width = prevroot.width;
			if (main.height !== null)
				main.height = prevroot.height;

			if (prevroot.inDocument) {
				//TODO: effect
			}
		}
	}

	/** Returns the topmost dialog, or null if no dialog at all.
	 * A dialog is a view sitting on top of [mainView].
	 * A dialog is also a root view, i.e., it has no parent.
	 * <p>An activity has at most one [mainView], while it might have
	 * any number of dialogs. To add a dialog, please use [addPopup].
	 * The last added dialog will be on top of the rest, including [mainView].
	 */
	View get currentDialog() => _dialogs.isEmpty() ? null: _dialogs[0];
	/** Adds a dialog. The dialog will become the topmost view and obscure
	 * the other dialogs and [mainView].
	 *
	 * <p>If specified, [effect] controls how to make the given dialog visible,
	 * and the previous dialog or [mainView] invisible.
	 *
	 * <p>To obscure the dialogs and mainView under it, a semi-transparent mask
	 * will be inserted on top of them and underneath the given dialog.
	 * You can control the transparent and styles by giving a different CSS
	 * class with [maskClass]. If you don't want the mask at all, you can specify
	 * <code>null</code> to [maskClass].
	 */
	void addDialog(View dialog, [ViewSwitchEffect effect, String maskClass="v-mask"]) {
		if (dialog.inDocument)
			throw new UIException("Can't be in document: ${dialog}");
		_dialogs.insertRange(0, 1, dialog);

		if (_mainView !== null && _mainView.node !== null) { //dialog might be added in onCreate_()
			_createDialog(dialog, effect);
			broadcaster.sendEvent(new PopupEvent(dialog));
		}
	}
	void _createDialog(View dialog, [ViewSwitchEffect effect]) {
		//TODO: add a mask
		//TODO: effect
		dialog.addToDocument(_mainView.node.parent);
	}
	/** Removes the topmost dialog or the given dialog.
	 * If [dialog] is not specified, the topmost one is assumed.
	 * <p>If specified, [effect] controls how to make the given dialog invisible,
	 * and make the previous dialog or [mainView] visible.
	 * <p>It returns false if the given dialog is not found.
	 */
	bool removeDialog([View dialog, ViewSwitchEffect effect]) {
		if (dialog === null) {
			dialog = currentDialog;
			if (dialog === null)
				throw const UIException("No dialog at all");
			_dialogs.removeRange(0, 1);
		} else {
			int j = _dialogs.length;
			for (;;) {
				if (--j < 0)
					return false;
				if (dialog == _dialogs[j]) {
					_dialogs.removeRange(j, 1);
					break;
				}
			}
		}

		if (dialog.inDocument) {
			//TODO: remove a mask
			dialog.removeFromDocument();
			broadcaster.sendEvent(new PopupEvent(null));
		}
		return true;
	}

	/** Starts the activity.
	 * <p>By default, it creates [mainView] (if it was not created yet)
	 * and has it to occupies the whole screen.
	 *
	 * <p>If the DOM element specified in [containerId] is found, [mainView]
	 * will only occupy the DOM element. It is useful if you'd like
	 * to have multiple activities (i.e., Dart applications) running
	 * at the same time and each of them handles only a portion of the
	 * screen.
	 */
	void run([String containerId="v-main"]) {
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

			if (!_mainView.inDocument) { //app might add it to Document manually
				Element container = containerId !== null ? document.query("#$containerId"): null;
				_mainView.addToDocument(container != null ? container: document.body);

				//the user might add dialog in onCreate_()
				for (final View dialog in _dialogs)
					_createDialog(dialog);
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