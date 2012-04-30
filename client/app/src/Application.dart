//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun, Apr 29, 2012 11:22:57 AM
// Author: tomyeh

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

	int _uuid;

	Application([String name="", bool inSimulator]) {
		this.name = name;
		application = this;

		this.inSimulator = inSimulator !== null ?
			 inSimulator: document.query("#v-simulator") !== null;

		if (browser === null)
			browser = new Browser();
		if (viewConfig === null)
			viewConfig = new ViewConfig();
		if (layoutManager == null)
			layoutManager = new LayoutManager();

		if (this.inSimulator)
			new SimulatorStub(); //after browser has been initialized

		onCreate_();
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
			if (body !== null) {
				String sval = body.$dom_getAttribute(_APP_COUNT);
				if (sval !== null) {
					_uuid = Math.parseInt(sval);
					body.$dom_setAttribute(_APP_COUNT, (_uuid + 1).toString());
				} else {
					_uuid = 0;
					body.$dom_setAttribute(_APP_COUNT, "1");
				}
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
Application application; //initialized by Activity