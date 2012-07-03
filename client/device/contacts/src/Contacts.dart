//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 14, 2012  02:28:13 PM
// Author: henrichen

/**
 * Access to the contacts list of this device.
 */
typedef ContactsSuccessCallback(List<Contact> contacts);
typedef ContactsErrorCallback(ContactError error);

interface Contacts {
  /**
  * Returns the Contacts queried by this method.
  * + [fields] the fields name in Contact you want to query back; return Contact id only if empty; return all fields if provide ["*"].
  * + [contactOptions] the filter string to apply the query.
  */
  void find(List<String> fields, ContactsSuccessCallback success, ContactsErrorCallback error, ContactsFindOptions contactOptions);
}


