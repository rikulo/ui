//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 10, 2012

/** An UI exception.
 */
class UIException implements Exception {
	final String message;

	const UIException(String this.message);
	String toString() => "UIException: $message";
}
