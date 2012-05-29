//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

/**
 * Access to the contacts list of this device.
 */
typedef ContactsSuccessCallback(List<Contact> contacts);
typedef ContactsErrorCallback(ContactError error);

interface Contacts {
	/** Create a new Contact object but not persist it; must call contact.save() to persit it.
	 */
//	Contact create(Map properties); //TODO: why not call new Contact() directly?
	
	/**
	* Returns the Contacts queried by this method.
	* @param fields specified the fields name in Contact you want to query back; return Contact id only if empty; return all fields if provide ["*"].
	* @param contactOptions the filter string to apply the query.
	*/
	void find(List<String> fields, ContactsSuccessCallback onSuccess, ContactsErrorCallback onError, ContactsFindOptions contactOptions);
}

typedef ContactSuccessCallback(Contact contact);
typedef ContactErrorCallback(ContactError error);

interface Contact {
	String id; //global unique identifier
	String displayName; //display name of this Contact
	ContactName name; //detail name of this Contact
	String nickname; //casual name of this Contact
	List<ContactField> phoneNumbers; //array of phone numbers of this Contact
	List<ContactField> emails; //array of emails of this Contact
	List<ContactAddress> addresses; //array of address of this Contact
	List<ContactField> ims; //array of im addresses of this Contact
	List<ContactOrganization> organizations; //array of organizations of this Contact
	Date birthday; //birthday of this Contact
	String note; //note about this Contact
	List<ContactField> photos; //array of photos of this Contact
	List<ContactField> categories; //array of user defined categories by this Contact
	List<ContactField> urls;//array of web pages associated to this Contact
	
	/** Returns a cloned Contact object except its id is set to null.
	 */
	Contact clone();
	
	/** Remove this Contact from the device's contacts list.
	 */
	void remove(ContactSuccessCallback onSuccess, ContactErrorCallback onError);
	
	/** Saves a new contact to the device contacts list; or updates an existing contact if exists the id.
	 */
	void save(ContactSuccessCallback onSuccess, ContactErrorCallback onError);
}

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
	
	ContactName(this.formatted, this.familyName, this.givenName, this.middleName, this.honorificPrefix, this.honorificSuffix);
	
	ContactName.from(Map name) : this.formatted = name["formatted"], this.familyName = name["familyName"],
	    this.givenName = name["givenName"], this.middleName = name["middleName"], 
	    this.honorificPrefix = name["honorificPrefix"], this.honorificSuffix = name["honorificSuffix"];
}

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
	
	ContactAddress(this.pref, this.type, this.formatted, this.streetAddress, this.locality,
		this.region, this.postalCode, this.country);
	
	ContactAddress.from(Map addr) : this.pref = addr["pref"], this.type = addr["type"], 
	  this.formatted = addr["formatted"], this.streetAddress = addr["streetAddress"], 
	  this.locality = addr["locality"], this.region = addr["region"], 
	  this.postalCode = addr["postalCode"], this.country = addr["country"];
}

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
	
  ContactOrganization.from(Map org) : this.pref = org["pref"], this.type = org["type"], 
      this.name = org["name"], this.department = org["department"], this.title = org["title"];
}

class ContactField {
	/** Tells what kind of field this is for; e.g. 'email' */
	String type; 
	/** The value of the field (such as a phone number or email address). */
	String value;
	/** Set to true if this ContactField contains the user's preferred value. */
	bool pref;
	
	ContactField(this.type, this.value, this.pref);

  ContactField.from(Map field) : this.type = field["type"], this.value = field["value"], this.pref = field["pref"];
}

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
	
	ContactError.from(Map err) : code = err["code"];
}
