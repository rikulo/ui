//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova connection  implementation.
 */
class CordovaConnection implements Connection {
  static final String _TYPE = "connection.type";
  CordovaConnection() {
    _initJSFunctions();
  }
  String get type() {
    return jsCall(_TYPE);
  }
  void _initJSFunctions() {
    newJSFunction(_TYPE, null, "return navigator.network.connection.type;");
  }
}
