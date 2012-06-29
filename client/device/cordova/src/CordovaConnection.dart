//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova connection  implementation.
 */
class CordovaConnection implements Connection {
  static final String _TYPE = "conn.1";
  CordovaConnection() {
    _initJSFunctions();
  }
  String get type() {
    return jsutil.jsCall(_TYPE);
  }
  void _initJSFunctions() {
    jsutil.newJSFunction(_TYPE, null, "return navigator.network.connection.type;");
  }
}
