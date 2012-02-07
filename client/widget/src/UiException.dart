//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 10, 2012

/** An UI exception.
 */
class UiException implements Exception {
	final String message;

	const UiException(String this.message);
	String toString() => "UiException: $message";
}
