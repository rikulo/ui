//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012 10:56:48 AM
// Author: tomyeh

/** A system exception.
 */
class SystemException implements Exception {
  final String message;

  const SystemException(String this.message);
  String toString() => "SystemException($message)";
}
