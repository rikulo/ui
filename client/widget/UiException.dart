//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 10, 2012
#library("artra:widget:UiException");

/** An UI exception.
 */
class UiException implements Exception {
  final String message;

  UiException(this.message);
}
