//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

class ContactName {
  /** The Contact's complete name. */
  String formatted; 
  /** The Contact's family name. */
  String familyName;
  /** The Contact's given name. */
  String givenName; 
  /** The Contact's middle name. */
  String middleName; 
  /** The Contact's prefix; e.g. Mr., Mrs., Miss, or Dr. */
  String honorificPrefix; 
  /** The Contact's suffix */
  String honorificSuffix;
  
  ContactName(this.formatted, this.familyName, this.givenName,
    this.middleName, this.honorificPrefix, this.honorificSuffix);
  
  ContactName.from(Map name) :
    this(name["formatted"], name["familyName"], name["givenName"],
      name["middleName"], name["honorificPrefix"], name["honorificSuffix"]);
}