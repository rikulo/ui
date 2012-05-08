//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun, Apr 29, 2012 11:22:57 AM
// Author: tomyeh

typedef void ThenCallback();
typedef void ReadyCallback(ThenCallback then);

/**
 * An application.
 */
class Application {
	/** The name of the application.
	 * Default: "" (an empty string)
	 */
	String name;
	/** Whether it is running on a simulator. */
	bool inSimulator = false;

	ReadyCallback _readyCB;
	int _uuid;

	Application([String name=""]) {
		this.name = name;
		_app = this;

		this.inSimulator = document.query("#v-simulator") !== null;

		if (browser === null)
			browser = new Browser();
		if (viewConfig === null)
			viewConfig = new ViewConfig();
		if (layoutManager == null)
			layoutManager = new LayoutManager();

		onCreate_();
	}

	/** Adds a ready callback which will be invoked to start the activity.
	 * It is useful if you want the activity to run until some criteria
	 * is satisfied.
	 * <p>A typical implementation of the callback:
	 *<pre><code>
(ThenCallback then) {
	if (_ready) {
		then(); //do it immediately
	} else {
		_doUntilReady(then); //queue then and call it when it is ready.
	}
}</code></pre>
	 */
	void addReadyCallback(ReadyCallback callback) {
		if (_readyCB === null) {
			_readyCB = callback;
		} else {
			final ReadyCallback prev = _readyCB;
			_readyCB = (then) {
				prev(() {
					callback(then);
				});
			};
		}
	}
	//called by Activity to start an activity
	void _ready(ThenCallback then) {
		if (_readyCB !== null) _readyCB(then);
		else then();
	}

	/** Called when the application is starting.
	 */
	void onCreate_() {
	}
	/** Returns UUID representing this application.
	 */
	int get uuid() {
		if (_uuid === null) {
			final Element body = document.body;
			if (body === null)
				throw const UiException("document not ready yet");

			String sval = body.$dom_getAttribute(_APP_COUNT);
			if (sval !== null) {
				_uuid = Math.parseInt(sval);
				body.$dom_setAttribute(_APP_COUNT, (_uuid + 1).toString());
			} else {
				_uuid = 0;
				body.$dom_setAttribute(_APP_COUNT, "1");
			}
		}
		return _uuid;
	}
	static final String _APP_COUNT = "data-rikuloAppCount";

	String toString() => "Application($name, ${_uuid})";
}
/** The application.
 * If you extend [Application], you can initialize it as follows:<br/>
 * <code>application = new MyApp()</code>
 * <p>Notice that you must initialize your custom appliction, before instantiating
 * your first activity.
 */
Application get application() { //initialized by Activity
	if (_app === null)
		_app = new Application();
	return _app;
}
Application _app;
