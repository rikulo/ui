//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

interface ContactsFindOptions default _ContactsFindOptions {
  /** The search string used to filter Contacts; default "" */
  String filter = "";
  /** Whether return multiple Contacts; default false */
  bool multiple = false;
  
  ContactsFindOptions([String filter, bool multiple]);
}

class _ContactsFindOptions implements ContactsFindOptions {
  /** The search string used to filter Contacts; default "" */
  String filter = "";
  /** Whether return multiple Contacts; default false */
  bool multiple = false;
  
  _ContactsFindOptions([String filter = "", bool multiple = false]) :
    this.filter = filter, this.multiple = multiple;
}