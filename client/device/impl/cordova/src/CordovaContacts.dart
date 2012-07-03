//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova Contacts implementation.
 */
class CordovaContacts implements Contacts {
  static final String _FIND = "conts.1";  
  CordovaContacts() {
    _initJSFunctions();
  }
  void find(List<String> fields, ContactsSuccessCallback success, ContactsErrorCallback error, ContactsFindOptions contactOptions) {
    var jsSuccess = _wrapContactsFunction(success);
    var jsError = _wrapErrorFunction(error);
    JSUtil.jsCall(_FIND, [JSUtil.toJSArray(fields), jsSuccess, jsError, JSUtil.toJSMap(_toMap(contactOptions))]);
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
    return JSUtil.toJSFunction((jsContacts) => dartFn(JSUtil.toDartList(jsContacts, (jsContact) => new CordovaContact.from(JSUtil.toDartMap(jsContact)))), 1);
  }
    
  _wrapErrorFunction(dartFn) {
    return JSUtil.toJSFunction((jsErr) => dartFn(new ContactError.from(JSUtil.toDartMap(jsErr))), 1);
  }
  
  void _initJSFunctions() {
    JSUtil.newJSFunction(_FIND, ["fields", "onSuccess", "onError", "opts"],
      "navigator.contacts.find(fields, onSuccess, onError, opts);");
  }
}


