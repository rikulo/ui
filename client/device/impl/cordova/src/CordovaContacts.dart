//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova Contacts implementation.
 */
class CordovaContacts implements Contacts {
  static final String _FIND = "conts.1";
  static final String _CREATE = "conts.2";
  
  CordovaContacts() {
    _initJSFunctions();
  }
  Contact create(Map properties) {
    return new CordovaContact._from(JSUtil.jsCall(_CREATE, 
      [properties == null ? JSUtil.jsCall("{}") : JSUtil.toJSMap(properties)]));
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
    return JSUtil.toJSFunction((jsContacts) => dartFn(JSUtil.toDartList(jsContacts, (jsContact) => new CordovaContact._from(jsContact))), 1);
  }
    
  _wrapErrorFunction(dartFn) {
    return JSUtil.toJSFunction((jsErr) => dartFn(new ContactError.from(JSUtil.toDartMap(jsErr))), 1);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;
    
    JSUtil.newJSFunction(_FIND, ["fields", "onSuccess", "onError", "opts"],
      "navigator.contacts.find(fields, onSuccess, onError, opts);");
    JSUtil.newJSFunction(_CREATE, ["props"], 
      "return navigator.contacts.create(props);");

    _doneInit = true;
  }
}


