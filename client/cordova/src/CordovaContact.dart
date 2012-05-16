//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  5:52:09 PM
// Author: henrichen

/**
 * A Cordova Contact implementation.
 */
class CordovaContact implements Contact {
	String get id() native "return this._jsContact.id;"; //global unique identifier
	String get displayName() native "return this._jsContact.displayName;"; //display name of this Contact
	String get nickname() native "return this._jsContact.nickname;"; //casual name of this Contact
	String get note() native "return this._jsContact.note;"; //note about this Contact

	set id(var x) native "this._jsContact.id = x;"; //global unique identifier
	set displayName(var x) native "this._jsContact.displayName = x;"; //display name of this Contact
	set nickname(var x) native "this._jsContact.nickname = x;"; //casual name of this Contact
	set note(var x) native "this._jsContact.note = x;"; //note about this Contact
	
	_create() native "navigator.contacts.create({});";
	_clone0(jsContact) native "return jsContact.clone();";
	_remove0(jsContact, ContactSuccessCallback onSuccess, ContactErrorCallback onError) native "jsContact.remove(onSuccess, onError);";
	_save0(jsContact, ContactSuccessCallback onSuccess, ContactErrorCallback onError) native "jsContact.save(onSuccess, onError);";

	_updateJsBirthday(jsContact, int msecs) native "jsContact.birthday = new Date(msecs);";
	_updateJsName(jsContact, String json) native "jsContact.name = JSON.parse(json);";
	_updateJsPhoneNumbers(jsContact, String json) native "jsContact.phoneNumbers = JSON.parse(json);";
	_updateJsEmails(jsContact, String json) native "jsContact.emails = JSON.parse(json);";
	_updateJsIms(jsContact, String json) native "jsContact.ims = JSON.parse(json);";
	_updateJsPhotos(jsContact, String json) native "jsContact.photos = JSON.parse(json);";
	_updateJsCategories(jsContact, String json) native "jsContact.categories = JSON.parse(json);";
	_updateJsUrls(jsContact, String json) native "jsContact.urls = JSON.parse(json);";
	_updateJsAddresses(jsContact, String json) native "jsContact.addresses = JSON.parse(json);";
	_updateJsOrganizations(jsContact, String json) native "jsContact.organizations = JSON.parse(json);";
	
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
		return new CordovaContact.from(_clone0(this._jsContact));
	}
	
	/** Remove this Contact from the device's contacts list.
	 */
	remove(ContactSuccessCallback onSuccess, ContactErrorCallback onError) {
		_remove0(this._jsContact, _wrapContactFunction(onSuccess), _wrapErrorFunction(onError));
	}
	/** Saves a new contact to the device contacts list; or updates an existing contact if exists the id.
	 */
	save(ContactSuccessCallback onSuccess, ContactErrorCallback onError) {
		_updateJsContact();
		_save0(this._jsContact, _wrapContactFunction(onSuccess), _wrapErrorFunction(onError));
	}

	_wrapContactFunction(dartFn) {   
		return ((jsContact) {
		  dartFn(_initContact0(jsContact));});
	}
	_wrapErrorFunction(dartFn) {
		return ((ContactError err) { //Use ContactError to trick frogc
			dartFn(new ContactError(err.code));});
	}

	Contact _initContact0(jsContact) {
		if (jsContact !==  null)
			this._jsContact = jsContact;
		return this;
	}
	
	_getJsContactFields(List<ContactField> fs) {
		StringBuffer n0 = new StringBuffer("[");
		bool first = true;
		for (ContactField f in fs) {
			if (!first) 
				n0.add(",");
			else 
				first = false;
			n0.add("{type:").add(f.type)
				.add(",value:").add(f.value)
				.add(",pref:").add(f.pref)
				.add("}");
		}
		n0.add("]");
		return n0;
	}
	
	_getJsContactAddresses(List<ContactAddress> fs) {
		StringBuffer n0 = new StringBuffer("[");
		bool first = true;
		for (ContactAddress f in fs) {
			if (!first) 
				n0.add(",");
			else 
				first = false;
			n0.add("{pref:").add(f.pref)
				.add(",type:").add(f.type)
				.add(",formatted:").add(f.formatted)
				.add(",streetAddress:").add(f.streetAddress)
				.add(",locality:").add(f.locality)
				.add(",region:").add(f.region)
				.add(",postalCode:").add(f.postalCode)
				.add(",country:").add(f.country)
				.add("}");
		}
		n0.add("]");
		return n0;
	}
	
	_getJsContactOrganizations(List<ContactOrganization> fs) {
		StringBuffer n0 = new StringBuffer("[");
		bool first = true;
		for (ContactOrganization f in fs) {
			if (!first) 
				n0.add(",");
			else 
				first = false;
			n0.add("{pref:").add(f.pref)
				.add(",type:").add(f.type)
				.add(",name:").add(f.name)
				.add(",department:").add(f.department)
				.add(",title:").add(f.title)
				.add("}");
		}
		n0.add("]");
		return n0;
	}
	
	_updateJsContact() {
		//birthday
		Date d0 = this.birthday;
		_updateJsBirthday(this._jsContact, d0.value);
		
		//name
		ContactName val0 = this.name;
		StringBuffer n0 = new StringBuffer("{formatted:").add(val0.formatted)
			.add(",familyName:").add(val0.familyName)
			.add(",givenName:").add(val0.givenName)
			.add(",middleName:").add(val0.middleName)
			.add(",honorificPrefix:").add(val0.honorificPrefix)
			.add(",honorificSuffix:").add(val0.honorificSuffix)
			.add("}");
		_updateJsName(this._jsContact, n0.toString());
		
		//addresses
		_updateJsAddresses(this._jsContact, _getJsContactAddresses(this.addresses));
		
		//organizations
		_updateJsOrganizations(this._jsContact, _getJsContactOrganizations(this.organizations));
				
		//phoneNumbers
		_updateJsPhoneNumbers(this._jsContact, _getJsContactFields(this.phoneNumbers));

		//emails
		_updateJsEmails(this._jsContact, _getJsContactFields(this.emails));

		//ims
		_updateJsIms(this._jsContact, _getJsContactFields(this.ims));

		//photos
		_updateJsPhotos(this._jsContact, _getJsContactFields(this.photos));
				
		//categories
		_updateJsCategories(this._jsContact, _getJsContactFields(this.categories));

		//urls
		_updateJsUrls(this._jsContact, _getJsContactFields(this.urls));
	}
	
	void _initDartContact() {
		Contact jsContact = this._jsContact; //trick frogc
		//birthday
		this.birthday = jsDateToDartDate(jsContact.birthday);
		//name
		ContactName val0 = jsContact.name;
		if (val0 !== null)
			this.name = new ContactName(val0.formatted, val0.familyName, val0.givenName, val0.middleName, val0.honorificPrefix, val0.honorificSuffix);
		//addresses
		this.addresses = _newAddressList(jsContact.addresses);
		//organizations
		this.organizations = _newOrganizationList(jsContact.organizations);
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
	
	List<ContactAddress> _newAddressList(jsAddresses) {
		List<ContactAddress> results = new List<ContactAddress>();
		jsForEach(jsAddresses, (ContactAddress addr) => 
			results.add(new ContactAddress(addr.pref, addr.type, addr.formatted, addr.streetAddress, 
									addr.locality, addr.region, addr.postalCode, addr.country)));
		return results;
	}
	
	List<ContactOrganization> _newOrganizationList(jsOrgs) {
		List<ContactOrganization> results = new List<ContactOrganization>();
		jsForEach(jsOrgs, (ContactOrganization org) => results.add(new ContactOrganization(org.pref, org.type, org.name, org.department, org.title)));
		return results;
	}

	List<ContactField> _newContactFieldList(jsFields) {
		List<ContactField> results = new List<ContactField>();
		jsForEach(jsFields, (ContactField field) => results.add(new ContactField(field.type, field.value, field.pref)));
		return results;
	}
}
