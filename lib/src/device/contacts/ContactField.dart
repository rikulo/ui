//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

class ContactField {
  /** Tells what kind of field this is for; e.g. 'email' */
  String type; 
  /** The value of the field (such as a phone number or email address). */
  String value;
  /** Set to true if this ContactField contains the user's preferred value. */
  bool pref;
  
  ContactField(this.type, this.value, this.pref);

  ContactField.from(Map field) : this(field["type"], field["value"], field["pref"]);
}