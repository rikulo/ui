class ContactAddress {
  /** Set to true if this ContactAddress contains the user's preferred value.*/
  bool pref;
  /** Tells which address this is; e.g. 'home'. */
  String type;
  /** The full address formatted for display. */
  String formatted;
  /** The full street address. */
  String streetAddress;
  /** The city or locality */
  String locality;
  /** The state or region. */
  String region;
  /** The zip code or postal code. */
  String postalCode;
  /** The country or area name */
  String country;
  
  ContactAddress(this.pref, this.type, this.formatted, this.streetAddress,
    this.locality, this.region, this.postalCode, this.country);
  
  ContactAddress.from(Map addr) :
    this(addr["pref"], addr["type"], addr["formatted"], addr["streetAddress"], 
    addr["locality"], addr["region"], addr["postalCode"], addr["country"]);
}