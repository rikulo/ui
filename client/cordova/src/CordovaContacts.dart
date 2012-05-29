//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova Contacts implementation.
 */
class CordovaContacts implements Contacts {
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
}


