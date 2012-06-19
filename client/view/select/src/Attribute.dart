//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class Attribute {
  
  final String name;
  final String value;
  final int op;
  final bool quoted;
  
  Attribute(this.name, this.op, this.value, this.quoted);
  
  static final int OP_EQUALS = 0;
  static final int OP_BEGINS_WITH = 1;
  static final int OP_ENDS_WITH = 2;
  static final int OP_CONTAINS = 3;
  
}
