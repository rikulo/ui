//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:17:04 AM
// Author: henrichen

/** PositionErrorImpl */
class PositionErrorImpl implements PositionError {
  int code;
  String message;
  
  PositionErrorImpl(this.code, this.message);
}
