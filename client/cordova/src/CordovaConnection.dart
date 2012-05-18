//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova connection  implementation.
 */
class CordovaConnection implements Connection {
	String get type() {
		_getType();
	}
	String _getType() native
		"return navigator.network.connection.type;";
}
