//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

class ContactsFindOptions {
  /** The search string used to filter Contacts; default "" */
  String filter = "";
  /** Whether return multiple Contacts; default false */
  bool multiple = false;
  
  ContactsFindOptions(String filter, bool multiple) : 
  this.filter = filter === null ? "" : filter,
  this.multiple = multiple;
  
  ContactsFindOptions.from(Map opts) : this.filter = opts["filter"], this.multiple = opts["multiple"];
}