//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

class ContactError {
  //constant value based on cordova's android implementation
  static final int UNKNOWN_ERROR = 0;
  static final int INVALID_ARGUMENT_ERROR = 1;
  static final int TIMEOUT_ERROR = 2;
  static final int PENDING_OPERATION_ERROR = 3;
  static final int IO_ERROR = 4;
  static final int NOT_SUPPORTED_ERROR = 5;
  static final int PERMISSION_DENIED_ERROR = 20;
  
  /** error code */
  final int code;
  
  ContactError(this.code);
  
  ContactError.from(Map err) : this(err["code"]);
}