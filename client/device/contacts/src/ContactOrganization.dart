//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

class ContactOrganization {
  /** Set to true if this ContactOrganization contains the user's preferred value. */
  bool pref;
  /** Tells what type this organization is; e.g. 'home'. */
  String type;
  /** The name of the organization the Contact works for. */
  String name;
  /** The department the Contact works for. */
  String department;
  /** The Contact's title at the organization.*/
  String title;
  
  ContactOrganization(this.pref, this.type, this.name, this.department, this.title);
  
  ContactOrganization.from(Map org) :
    this(org["pref"], org["type"], org["name"], org["department"], org["title"]);
}