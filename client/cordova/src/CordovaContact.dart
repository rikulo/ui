//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  5:52:09 PM
// Author: henrichen

/**
 * A Cordova Contact implementation.
 */
class CordovaContact implements Contact {
	String get id() => jsCall("get", [_jsContact, "id"]); //global unique identifier
	String get displayName() => jsCall("get", [_jsContact, "displayName"]); //display name of this Contact
	String get nickname() => jsCall("get", [_jsContact, "nickname"]); //casual name of this Contact
	String get note() => jsCall("get", [_jsContact, "note"]); //note about this Contact

	set id(var x) => jsCall("set", [_jsContact, "id", x]); //global unique identifier
	set displayName(var x) => jsCall("set", [_jsContact, "displayName", x]); //display name of this Contact
	set nickname(var x) => jsCall("set", [_jsContact, "nickname", x]); //casual name of this Contact
	set note(var x) => jsCall("set", [_jsContact, "note", x]); //note about this Contact
	
	_create() => jsCall("contacts.create");
	_clone0() => jsCall("contact.clone", [_jsContact]);
	_remove0(ContactSuccessCallback onSuccess, ContactErrorCallback onError) => jsCall("contact.remove", [_jsContact, onSuccess, onError]);
	_save0(ContactSuccessCallback onSuccess, ContactErrorCallback onError) => jsCall("contact.save", [_jsContact, onSuccess, onError]);

	_updateJSBirthday() => jsCall("set", [_jsContact, "birthday", toJSDate(this.birthday)]);
	_updateJSContactName() => jsCall("set", [_jsContact, "name", _toJSContactName(this.name)]);
	_updateJSPhoneNumbers() => jsCall("set", [_jsContact, "phoneNumbers", _toJSContactFields(this.phoneNumbers)]);
	_updateJSEmails() => jsCall("set", [_jsContact, "emails", _toJSContactFields(this.emails)]);
	_updateJSIms() => jsCall("set", [_jsContact, "ims", _toJSContactFields(this.ims)]);
	_updateJSPhotos() => jsCall("set", [_jsContact, "photos", _toJSContactFields(this.photos)]);
	_updateJSCategories() => jsCall("set", [_jsContact, "categories", _toJSContactFields(this.categories)]);
	_updateJSUrls() => jsCall("set", [_jsContact, "urls", _toJSContactFields(this.urls)]);
	_updateJSAddresses() => jsCall("set", [_jsContact, "addresses", _toJSContactAddresses(this.addresses)]);
	_updateJSOrganizations() => jsCall("set", [_jsContact, "organizations", _toJSContactOrganizations(this.organizations)]);
	
	ContactName name; //detail name of this Contact
	List<ContactField> phoneNumbers; //array of phone numbers of this Contact
	List<ContactField> emails; //array of emails of this Contact
	List<ContactAddress> addresses; //array of address of this Contact
	List<ContactField> ims; //array of im addresses of this Contact
	List<ContactOrganization> organizations; //array of organizations of this Contact
	Date birthday; //birthday of this Contact
	List<ContactField> photos; //array of photos of this Contact
	List<ContactField> categories; //array of user defined categories by this Contact
	List<ContactField> urls;//array of web pages associated to this Contact
	
	var _jsContact; //associated javascript Contact
	
	CordovaContact() {
		this._jsContact = _create();
		_initDartContact();
	}
	
	CordovaContact.from(var jsContact) {
		this._jsContact = jsContact;
		_initDartContact();
	}
	
	/** Returns a cloned Contact object except its id is set to null.
	 */
	Contact clone() {
		return new CordovaContact.from(_clone0());
	}
	
	/** Remove this Contact from the device's contacts list.
	 */
	remove(ContactSuccessCallback onSuccess, ContactErrorCallback onError) {
		_remove0(_wrapContactFunction(onSuccess), _wrapErrorFunction(onError));
	}
	/** Saves a new contact to the device contacts list; or updates an existing contact if exists the id.
	 */
	save(ContactSuccessCallback onSuccess, ContactErrorCallback onError) {
		_updateJsContact();
		_save0(_wrapContactFunction(onSuccess), _wrapErrorFunction(onError));
	}

	_wrapContactFunction(dartFn) {   
		return (jsContact) => dartFn(_initContact0(jsContact));
	}
	_wrapErrorFunction(dartFn) {
		return (jsErr) => dartFn(new ContactError.from(toDartMap(jsErr)));
	}

	Contact _initContact0(jsContact) {
		if (jsContact !==  null)
			this._jsContact = jsContact;
		return this;
	}
	_toContactFieldMap(ContactField field) {
	  return {
	    "type" : field.type, 
	    "value" : field.value,
	    "pref" : field.pref

	  };
	}
	_toJSContactFields(List<ContactField> fields) {
	  return toJSArray(fields, (ContactField field) => toJSMap(_toContactFieldMap(field)));
	}

	_toContactAddressMap(ContactAddress addr) {
    return {
      "pref" : addr.pref,
      "type" : addr.type,
      "formatted" : addr.formatted,
      "streetAddress" : addr.streetAddress,
      "locality" : addr.locality,
      "region" : addr.region,
      "postalCode" : addr.postalCode,
      "country" : addr.country
    };
	}
	_toJSContactAddresses(List<ContactAddress> addrs) {
	  return toJSArray(addrs, (ContactAddress addr) => toJSMap(_toContactAddressMap(addr)));
	}
	
  _toContactOrganizationMap(ContactOrganization org) {
    return {
      "pref" : org.pref,
      "type" : org.type,
      "name" : org.name,
      "department" : org.department,
      "title" : org.title
    };
  }
	_toJSContactOrganizations(List<ContactOrganization> orgs) {
    return toJSArray(addresses, (ContactOrganization org) => toJSMap(_toContactOrganizationMap(org)));
  }
	
	_toContactNameMap(ContactName name0) {
	  return {
	  "formatted:" : name0.formatted,
    "familyName:" : name0.familyName,
    "givenName:" : name0.givenName,
    "middleName:" : name0.middleName,
    "honorificPrefix:" : name0.honorificPrefix,
    "honorificSuffix:" : name0.honorificSuffix
	  };
	}
	_toJSContactName(ContactName name0) {
	  return toJSMap(_toContactNameMap(name0));
	}
	
	_updateJsContact() {
		//birthday
		_updateJSBirthday();
		
		//name
		_updateJSContactName();
		
		//addresses
		_updateJSAddresses();
		
		//organizations
		_updateJSOrganizations();
				
		//phoneNumbers
		_updateJSPhoneNumbers();

		//emails
		_updateJSEmails();

		//ims
		_updateJSIms();

		//photos
		_updateJSPhotos();
				
		//categories
		_updateJSCategories();

		//urls
		_updateJSUrls();
	}
	
	void _initDartContact() {
		Contact jsContact = this._jsContact; //trick frogc
		//birthday
		this.birthday = toDartDate(jsContact.birthday);
		//name
		ContactName val0 = jsContact.name;
		if (val0 !== null)
			this.name = new ContactName.from(toDartMap(val0));
		//addresses
		this.addresses = toDartList(jsContact.addresses, (jsAddr) => new ContactAddress.from(toDartMap(jsAddr)));
		//organizations
		this.organizations = toDartList(jsContact.organizations, (jsOrg) => new ContactOrganization.from(toDartMap(jsOrg)));
		//phoneNumbers
		this.phoneNumbers = _newContactFieldList(jsContact.phoneNumbers);
		//emails
		this.emails = _newContactFieldList(jsContact.emails);
		//ims
		this.ims = _newContactFieldList(jsContact.ims);
		//photos
		this.photos = _newContactFieldList(jsContact.photos);
		//categories
		this.categories = _newContactFieldList(jsContact.categories);
		//urls
		this.urls = _newContactFieldList(jsContact.urls);
	}
	
	List<ContactField> _newContactFieldList(jsFields) {
	  return toDartList(jsFields, (jsField) => new ContactField.from(toDartMap(jsField)));
	}
}
