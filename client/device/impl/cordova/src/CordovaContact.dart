//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  5:52:09 PM
// Author: henrichen

/**
 * A Cordova Contact implementation.
 */
class CordovaContact implements Contact {
  static final String _CREATE = "contacts.create";
  static final String _CLONE = "contact.clone";
  static final String _REMOVE = "contact.remove";
  static final String _SAVE = "contact.save";
  
  String get id() => jsCall("get", [_jsContact, "id"]); //global unique identifier
  String get displayName() => jsCall("get", [_jsContact, "displayName"]); //display name of this Contact
  String get nickname() => jsCall("get", [_jsContact, "nickname"]); //casual name of this Contact
  String get note() => jsCall("get", [_jsContact, "note"]); //note about this Contact

  set id(var x) => jsCall("set", [_jsContact, "id", x]); //global unique identifier
  set displayName(var x) => jsCall("set", [_jsContact, "displayName", x]); //display name of this Contact
  set nickname(var x) => jsCall("set", [_jsContact, "nickname", x]); //casual name of this Contact
  set note(var x) => jsCall("set", [_jsContact, "note", x]); //note about this Contact
  
  _create() => jsCall(_CREATE);
  _clone0() => jsCall(_CLONE, [_jsContact]);
  _remove0(ContactSuccessCallback success, ContactErrorCallback error) => jsCall(_REMOVE, [_jsContact, success, error]);
  _save0(ContactSuccessCallback success, ContactErrorCallback error) => jsCall(_SAVE, [_jsContact, success, error]);

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
    _initJSFunctions();
    this._jsContact = _create();
    _initDartContact();
  }
  
  CordovaContact.from(var jsContact) {
    _initJSFunctions();
    this._jsContact = jsContact;
    _initDartContact();
  }
  
  /** Returns a cloned Contact object except its id is set to null.
   */
  Contact clone() {
    _initJSFunctions();
    return new CordovaContact.from(_clone0());
  }
  
  /** Remove this Contact from the device's contacts list.
   */
  remove(ContactSuccessCallback success, ContactErrorCallback error) {
    _remove0(_wrapContactFunction(success), _wrapErrorFunction(error));
  }
  /** Saves a new contact to the device contacts list; or updates an existing contact if exists the id.
   */
  save(ContactSuccessCallback success, ContactErrorCallback error) {
    _updateJsContact();
    _save0(_wrapContactFunction(success), _wrapErrorFunction(error));
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
    //birthday
    this.birthday = toDartDate(jsCall("get", [_jsContact, "birthday"]));
    //name
    ContactName val0 = jsCall("get", [_jsContact, "name"]);
    if (val0 !== null)
      this.name = new ContactName.from(toDartMap(val0));
    //addresses
    this.addresses = toDartList(jsCall("get", [_jsContact, "addresses"]), (jsAddr) => new ContactAddress.from(toDartMap(jsAddr)));
    //organizations
    this.organizations = toDartList(jsCall("get", [_jsContact, "organizations"]), (jsOrg) => new ContactOrganization.from(toDartMap(jsOrg)));
    //phoneNumbers
    this.phoneNumbers = _newContactFieldList(jsCall("get", [_jsContact, "phoneNumbers"]));
    //emails
    this.emails = _newContactFieldList(jsCall("get", [_jsContact, "emails"]));
    //ims
    this.ims = _newContactFieldList(jsCall("get", [_jsContact, "ims"]));
    //photos
    this.photos = _newContactFieldList(jsCall("get", [_jsContact, "photos"]));
    //categories
    this.categories = _newContactFieldList(jsCall("get", [_jsContact, "categories"]));
    //urls
    this.urls = _newContactFieldList(jsCall("get", [_jsContact, "urls"]));
  }
  
  List<ContactField> _newContactFieldList(jsFields) {
    return toDartList(jsFields, (jsField) => new ContactField.from(toDartMap(jsField)));
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (!_doneInit) {
      newJSFunction(_CREATE,  null, "return navigator.contacts.create({});");
      newJSFunction(_CLONE, ["contact"], "return contact.clone();");
      newJSFunction(_REMOVE, ["contact", "onSuccess", "onError"], '''
        var fnSuccess = function(contact0) {onSuccess.\$call\$1(contact0);},
            fnError = function(err) {onError.\$call\$1(err);};
        contact.remove(fnSuccess, fnError);
      ''');
      newJSFunction(_SAVE, ["contact", "onSuccess", "onError"], '''
        var fnSuccess = function(contact0) {onSuccess.\$call\$1(contact0);},
            fnError = function(err) {onError.\$call\$1(err);};
        contact.save(fnSuccess, fnError);
      ''');
      _doneInit = true;
    }
  }
}
