//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

class ContactError {
  //constant value based on cordova's android implementation
  static const int UNKNOWN_ERROR = 0;
  static const int INVALID_ARGUMENT_ERROR = 1;
  static const int TIMEOUT_ERROR = 2;
  static const int PENDING_OPERATION_ERROR = 3;
  static const int IO_ERROR = 4;
  static const int NOT_SUPPORTED_ERROR = 5;
  static const int PERMISSION_DENIED_ERROR = 20;
  
  /** error code */
  final int code;
  
  ContactError(this.code);
  
  ContactError.from(Map err) : this(err["code"]);
}