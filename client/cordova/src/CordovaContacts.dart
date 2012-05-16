//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova Contacts implementation.
 */
class CordovaContacts implements Contacts {
	void find(List<String> fields, ContactsSuccessCallback onSuccess, ContactsErrorCallback onError, ContactsFindOptions contactOptions) {
		String fs = fields === null || fields.isEmpty() ? "['id']" : JSON.stringify(fields);
		String opts = contactOptions === null ? "{'filter':'','multiple':false}" : JSON.stringify(_toMap(contactOptions));
		_find(fs, _wrapContactsFunction(onSuccess), _wrapErrorFunction(onError), opts);
	}
	
	Map _toMap(ContactsFindOptions opts) {
		return {
		  /** The search string used to filter Contacts; default "" */
		  "filter" : opts.filter,
		  /** Whether return multiple Contacts; default false */
		  "multiple" : opts.multiple};
	}
	
	void _find(String fs, ContactsSuccessCallback onSuccess, ContactsErrorCallback onError, String opts) native
		"navigator.contacts.find(JSON.parse(fs), onSuccess, onError, JSON.parse(opts));";
		
	List<Contact> _newContactList(jsContacts) { //trick frogc
		List<Contact> results = new List<Contact>();
		jsForEach(jsContacts, (jsContact) => results.add(new CordovaContact.from(jsContact)));
		return results;
	}
	
	//parameter called back from javascript Cordova would be a json object {}, must convert paremeter type back to dart Contact
	_wrapContactsFunction(dartFn) {   
		return ((Object contacts) { //Use Object to trick frogc to generate proper code
		  dartFn(_newContactList(contacts));});
	}
		
	_wrapErrorFunction(dartFn) {
		return ((ContactError err) { //Use ContactError to trick frogc
			dartFn(new ContactError(err.code));});
	}
}


