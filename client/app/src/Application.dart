//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun, Apr 29, 2012 11:22:57 AM
// Author: tomyeh

/** A callback to be invoked when Rikulo is ready to run. */
typedef void ReadyCallback(Task then);

/**
 * An application. It is the base class for holding global application states.
 *
 * You can provide your own implementation by instantiating as follows:
 *
 *     application = new MyApp();
 *
 * Notice that you must initialize your custom application, before instantiating
 * your first activity.
 *
 * Also notice that, instead of extending [Application], you can manage
 * global application states in global variables. It is generally more convenient.
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

    this.inSimulator = document.query("#v-simulator") != null;

    if (browser == null)
      browser = new Browser();
    if (viewConfig == null)
      viewConfig = new ViewConfig();
    if (layoutManager == null)
      layoutManager = new LayoutManager();
  }

  /** Adds a ready callback which will be invoked to start the activity.
   * It is useful if you want the activity to run until some criteria
   * is satisfied.
   *
   * A typical implementation of the callback:
   *
   *     (Task then) {
   *       if (_checkIfReady()) {
   *         then(); //do it immediately
   *       } else {
   *         _doUntilReady(then); //queue then and call it when it is ready.
   *       }
   *     }
   */
  void addReadyCallback(ReadyCallback callback) {
    if (_readyCB == null) {
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
  void _ready(Task then) {
    if (_readyCB != null) _readyCB(then);
    else then();
  }

  /** Returns UUID representing this application.
   */
  int get uuid {
    if (_uuid == null) {
      final Element body = document.body;
      if (body == null)
        throw const SystemException("document not ready yet");

      String sval = body.$dom_getAttribute(_APP_COUNT);
      if (sval != null) {
        _uuid = parseInt(sval);
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
 * If you extend [Application], you can initialize it as follows:
 *
 *     application = new MyApp();
 *
 * Notice that you must initialize your custom application, before instantiating
 * your first activity.
 */
Application get application { //initialized by Activity
  if (_app == null)
    _app = new Application();
  return _app;
}
Application _app;
