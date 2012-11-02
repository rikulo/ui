//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai
part of rikulo_view_select;

class Attribute {
  
  final String name;
  final String value;
  final int op;
  final bool quoted;
  
  Attribute(this.name, this.op, this.value, this.quoted);
  
  static const int OP_EQUALS = 0;
  static const int OP_BEGINS_WITH = 1;
  static const int OP_ENDS_WITH = 2;
  static const int OP_CONTAINS = 3;
}
