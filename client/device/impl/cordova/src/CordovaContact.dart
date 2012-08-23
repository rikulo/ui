//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  5:52:09 PM
// Author: henrichen

/**
 * A Cordova Contact implementation.
 */
class CordovaContact implements Contact, JSAgent {
  static final String _CLONE = "cont.1";
  static final String _REMOVE = "cont.2";
  static final String _SAVE = "cont.3";
  
  String get id => JSUtil.getJSValue(_jsContact, "id"); //global unique identifier
  String get displayName => JSUtil.getJSValue(_jsContact, "displayName"); //display name of this Contact
  String get nickname => JSUtil.getJSValue(_jsContact, "nickname"); //casual name of this Contact
  String get note => JSUtil.getJSValue(_jsContact, "note"); //note about this Contact

  set id(var x) => JSUtil.setJSValue(_jsContact, "id", x); //global unique identifier
  set displayName(var x) => JSUtil.setJSValue(_jsContact, "displayName", x); //display name of this Contact
  set nickname(var x) => JSUtil.setJSValue(_jsContact, "nickname", x); //casual name of this Contact
  set note(var x) => JSUtil.setJSValue(_jsContact, "note", x); //note about this Contact
  
  _clone0() => JSUtil.jsCall(_CLONE, [_jsContact]);
  _remove0(ContactSuccessCallback success, ContactErrorCallback error) => JSUtil.jsCall(_REMOVE, [_jsContact, success, error]);
  _save0(ContactSuccessCallback success, ContactErrorCallback error) => JSUtil.jsCall(_SAVE, [_jsContact, success, error]);

  _updateJSBirthday() => JSUtil.setJSValue(_jsContact, "birthday", JSUtil.toJSDate(this.birthday));
  _updateJSContactName() => JSUtil.setJSValue(_jsContact, "name", _toJSContactName(this.name));
  _updateJSPhoneNumbers() => JSUtil.setJSValue(_jsContact, "phoneNumbers", _toJSContactFields(this.phoneNumbers));
  _updateJSEmails() => JSUtil.setJSValue(_jsContact, "emails", _toJSContactFields(this.emails));
  _updateJSIms() => JSUtil.setJSValue(_jsContact, "ims", _toJSContactFields(this.ims));
  _updateJSPhotos() => JSUtil.setJSValue(_jsContact, "photos", _toJSContactFields(this.photos));
  _updateJSCategories() => JSUtil.setJSValue(_jsContact, "categories", _toJSContactFields(this.categories));
  _updateJSUrls() => JSUtil.setJSValue(_jsContact, "urls", _toJSContactFields(this.urls));
  _updateJSAddresses() => JSUtil.setJSValue(_jsContact, "addresses", _toJSContactAddresses(this.addresses));
  _updateJSOrganizations() => JSUtil.setJSValue(_jsContact, "organizations", _toJSContactOrganizations(this.organizations));
  
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
  
  CordovaContact._from(var jsContact) {
    _initJSFunctions();
    this._jsContact = jsContact;
    _initDartContact();
  }
  
  toJSObject() {
    return _jsContact;
  }
  
  /** Returns a cloned Contact object except its id is set to null.
   */
  Contact clone() {
    _initJSFunctions();
    return new CordovaContact._from(_clone0());
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
    return JSUtil.toJSFunction((jsContact) => dartFn(_initContact0(jsContact)),1);
  }
  _wrapErrorFunction(dartFn) {
    return JSUtil.toJSFunction((jsErr) => dartFn(new ContactError.from(JSUtil.toDartMap(jsErr))), 1);
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
    return JSUtil.toJSArray(fields, (ContactField field) => JSUtil.toJSMap(_toContactFieldMap(field)));
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
    return JSUtil.toJSArray(addrs, (ContactAddress addr) => JSUtil.toJSMap(_toContactAddressMap(addr)));
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
    return JSUtil.toJSArray(addresses, (ContactOrganization org) => JSUtil.toJSMap(_toContactOrganizationMap(org)));
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
    return JSUtil.toJSMap(_toContactNameMap(name0));
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
    this.birthday = JSUtil.toDartDate(JSUtil.getJSValue(_jsContact, "birthday"));
    //name
    ContactName val0 = JSUtil.getJSValue(_jsContact, "name");
    if (val0 != null)
      this.name = new ContactName.from(JSUtil.toDartMap(val0));
    //addresses
    this.addresses = JSUtil.toDartList(JSUtil.getJSValue(_jsContact, "addresses"), (jsAddr) => new ContactAddress.from(JSUtil.toDartMap(jsAddr)));
    //organizations
    this.organizations = JSUtil.toDartList(JSUtil.getJSValue(_jsContact, "organizations"), (jsOrg) => new ContactOrganization.from(JSUtil.toDartMap(jsOrg)));
    //phoneNumbers
    this.phoneNumbers = _newContactFieldList(JSUtil.getJSValue(_jsContact, "phoneNumbers"));
    //emails
    this.emails = _newContactFieldList(JSUtil.getJSValue(_jsContact, "emails"));
    //ims
    this.ims = _newContactFieldList(JSUtil.getJSValue(_jsContact, "ims"));
    //photos
    this.photos = _newContactFieldList(JSUtil.getJSValue(_jsContact, "photos"));
    //categories
    this.categories = _newContactFieldList(JSUtil.getJSValue(_jsContact, "categories"));
    //urls
    this.urls = _newContactFieldList(JSUtil.getJSValue(_jsContact, "urls"));
  }
  
  List<ContactField> _newContactFieldList(jsFields) {
    return JSUtil.toDartList(jsFields, (jsField) => new ContactField.from(JSUtil.toDartMap(jsField)));
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;

    JSUtil.newJSFunction(_CLONE, ["contact"], "return contact.clone();");
    JSUtil.newJSFunction(_REMOVE, ["contact", "onSuccess", "onError"],
      "contact.remove(onSuccess, onError);");
    JSUtil.newJSFunction(_SAVE, ["contact", "onSuccess", "onError"],
      "contact.save(onSuccess, onError);");

    _doneInit = true;
  }
}
