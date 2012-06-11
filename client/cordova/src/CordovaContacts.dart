//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova Contacts implementation.
 */
class CordovaContacts implements Contacts {
  CordovaContacts() {
    _initJSFunctions();
  }
  void find(List<String> fields, ContactsSuccessCallback onSuccess, ContactsErrorCallback onError, ContactsFindOptions contactOptions) {
    jsCall("contacts.find", [toJSArray(fields), _wrapContactsFunction(onSuccess), _wrapErrorFunction(onError), toJSMap(_toMap(contactOptions))]);
  }
  
  Map _toMap(ContactsFindOptions opts) {
    return {
      /** The search string used to filter Contacts; default "" */
      "filter" : opts.filter,
      /** Whether return multiple Contacts; default false */
      "multiple" : opts.multiple
    };
  }
    
  //parameter called back from javascript Cordova would be a json object {}, must convert paremeter type back to dart Contact
  _wrapContactsFunction(dartFn) {   
    return (jsContacts) => dartFn(toDartList(jsContacts, (jsContact) => new CordovaContact.from(toDartMap(jsContact))));
  }
    
  _wrapErrorFunction(dartFn) {
    return (jsErr) => dartFn(new ContactError.from(toDartMap(jsErr)));
  }
  
  void _initJSFunctions() {
    newJSFunction("contacts.create",  null, "return navigator.contacts.create({});");
    newJSFunction("contacts.find", ["fields", "onSuccess", "onError", "opts"], '''
      var fnSuccess = function(contacts) {onSuccess.\$call\$1(contacts);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.contacts.find(fields, fnSuccess, fnError, opts);
    ''');
    newJSFunction("contact.clone", ["contact"], "return contact.clone();");
    newJSFunction("contact.remove", ["contact", "onSuccess", "onError"], '''
      var fnSuccess = function(contact0) {onSuccess.\$call\$1(contact0);},
          fnError = function(err) {onError.\$call\$1(err);};
      contact.remove(fnSuccess, fnError);
    ''');
    newJSFunction("contact.save", ["contact", "onSuccess", "onError"], '''
      var fnSuccess = function(contact0) {onSuccess.\$call\$1(contact0);},
          fnError = function(err) {onError.\$call\$1(err);};
      contact.save(fnSuccess, fnError);
    ''');
  }
}


