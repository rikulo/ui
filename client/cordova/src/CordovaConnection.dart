//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova connection  implementation.
 */
class CordovaConnection implements Connection {
  CordovaConnection() {
    _initJSFunctions();
  }
  String get type() {
    return jsCall("connection.type");
  }
  void _initJSFunctions() {
    newJSFunction("connection.type", null, "return navigator.network.connection.type;");
  }
}
