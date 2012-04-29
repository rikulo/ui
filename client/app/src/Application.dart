//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun, Apr 29, 2012 11:22:57 AM
// Author: tomyeh

/**
 * An application.
 */
class Application {
	int _uuid;
	/** The name of the application.
	 * Default: "" (an empty string)
	 */
	String name;

	Application([String name=""]) {
		this.name = name;
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
 * <p>It is suggested to initialize it before instantiates
 * you own application.
 */
Application application; //initialized by Activity