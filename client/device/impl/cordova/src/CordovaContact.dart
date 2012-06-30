//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  5:52:09 PM
// Author: henrichen

/**
 * A Cordova Contact implementation.
 */
class CordovaContact implements Contact {
  static final String _CREATE = "cont.1";
  static final String _CLONE = "cont.2";
  static final String _REMOVE = "cont.3";
  static final String _SAVE = "cont.4";
  
  String get id() => jsutil.getJSValue(_jsContact, "id"); //global unique identifier
  String get displayName() => jsutil.getJSValue(_jsContact, "displayName"); //display name of this Contact
  String get nickname() => jsutil.getJSValue(_jsContact, "nickname"); //casual name of this Contact
  String get note() => jsutil.getJSValue(_jsContact, "note"); //note about this Contact

  set id(var x) => jsutil.setJSValue(_jsContact, "id", x); //global unique identifier
  set displayName(var x) => jsutil.setJSValue(_jsContact, "displayName", x); //display name of this Contact
  set nickname(var x) => jsutil.setJSValue(_jsContact, "nickname", x); //casual name of this Contact
  set note(var x) => jsutil.setJSValue(_jsContact, "note", x); //note about this Contact
  
  _create() => jsutil.jsCall(_CREATE);
  _clone0() => jsutil.jsCall(_CLONE, [_jsContact]);
  _remove0(ContactSuccessCallback success, ContactErrorCallback error) => jsutil.jsCall(_REMOVE, [_jsContact, success, error]);
  _save0(ContactSuccessCallback success, ContactErrorCallback error) => jsutil.jsCall(_SAVE, [_jsContact, success, error]);

  _updateJSBirthday() => jsutil.setJSValue(_jsContact, "birthday", jsutil.toJSDate(this.birthday));
  _updateJSContactName() => jsutil.setJSValue(_jsContact, "name", _toJSContactName(this.name));
  _updateJSPhoneNumbers() => jsutil.setJSValue(_jsContact, "phoneNumbers", _toJSContactFields(this.phoneNumbers));
  _updateJSEmails() => jsutil.setJSValue(_jsContact, "emails", _toJSContactFields(this.emails));
  _updateJSIms() => jsutil.setJSValue(_jsContact, "ims", _toJSContactFields(this.ims));
  _updateJSPhotos() => jsutil.setJSValue(_jsContact, "photos", _toJSContactFields(this.photos));
  _updateJSCategories() => jsutil.setJSValue(_jsContact, "categories", _toJSContactFields(this.categories));
  _updateJSUrls() => jsutil.setJSValue(_jsContact, "urls", _toJSContactFields(this.urls));
  _updateJSAddresses() => jsutil.setJSValue(_jsContact, "addresses", _toJSContactAddresses(this.addresses));
  _updateJSOrganizations() => jsutil.setJSValue(_jsContact, "organizations", _toJSContactOrganizations(this.organizations));
  
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
    return (jsErr) => dartFn(new ContactError.from(jsutil.toDartMap(jsErr)));
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
    return jsutil.toJSArray(fields, (ContactField field) => jsutil.toJSMap(_toContactFieldMap(field)));
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
    return jsutil.toJSArray(addrs, (ContactAddress addr) => jsutil.toJSMap(_toContactAddressMap(addr)));
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
    return jsutil.toJSArray(addresses, (ContactOrganization org) => jsutil.toJSMap(_toContactOrganizationMap(org)));
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
    return jsutil.toJSMap(_toContactNameMap(name0));
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
    this.birthday = jsutil.toDartDate(jsutil.getJSValue(_jsContact, "birthday"));
    //name
    ContactName val0 = jsutil.getJSValue(_jsContact, "name");
    if (val0 !== null)
      this.name = new ContactName.from(jsutil.toDartMap(val0));
    //addresses
    this.addresses = jsutil.toDartList(jsutil.getJSValue(_jsContact, "addresses"), (jsAddr) => new ContactAddress.from(jsutil.toDartMap(jsAddr)));
    //organizations
    this.organizations = jsutil.toDartList(jsutil.getJSValue(_jsContact, "organizations"), (jsOrg) => new ContactOrganization.from(jsutil.toDartMap(jsOrg)));
    //phoneNumbers
    this.phoneNumbers = _newContactFieldList(jsutil.getJSValue(_jsContact, "phoneNumbers"));
    //emails
    this.emails = _newContactFieldList(jsutil.getJSValue(_jsContact, "emails"));
    //ims
    this.ims = _newContactFieldList(jsutil.getJSValue(_jsContact, "ims"));
    //photos
    this.photos = _newContactFieldList(jsutil.getJSValue(_jsContact, "photos"));
    //categories
    this.categories = _newContactFieldList(jsutil.getJSValue(_jsContact, "categories"));
    //urls
    this.urls = _newContactFieldList(jsutil.getJSValue(_jsContact, "urls"));
  }
  
  List<ContactField> _newContactFieldList(jsFields) {
    return jsutil.toDartList(jsFields, (jsField) => new ContactField.from(jsutil.toDartMap(jsField)));
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (!_doneInit) {
      jsutil.newJSFunction(_CREATE,  null, "return navigator.contacts.create({});");
      jsutil.newJSFunction(_CLONE, ["contact"], "return contact.clone();");
      jsutil.newJSFunction(_REMOVE, ["contact", "onSuccess", "onError"], '''
        var fnSuccess = function(contact0) {onSuccess.\$call\$1(contact0);},
            fnError = function(err) {onError.\$call\$1(err);};
        contact.remove(fnSuccess, fnError);
      ''');
      jsutil.newJSFunction(_SAVE, ["contact", "onSuccess", "onError"], '''
        var fnSuccess = function(contact0) {onSuccess.\$call\$1(contact0);},
            fnError = function(err) {onError.\$call\$1(err);};
        contact.save(fnSuccess, fnError);
      ''');
      _doneInit = true;
    }
  }
}
