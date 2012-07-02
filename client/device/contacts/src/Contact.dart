typedef ContactSuccessCallback(Contact contact);
typedef ContactErrorCallback(ContactError error);

interface Contact {
  String id; //global unique identifier
  String displayName; //display name of this Contact
  ContactName name; //detail name of this Contact
  String nickname; //casual name of this Contact
  List<ContactField> phoneNumbers; //array of phone numbers of this Contact
  List<ContactField> emails; //array of emails of this Contact
  List<ContactAddress> addresses; //array of address of this Contact
  List<ContactField> ims; //array of im addresses of this Contact
  List<ContactOrganization> organizations; //array of organizations of this Contact
  Date birthday; //birthday of this Contact
  String note; //note about this Contact
  List<ContactField> photos; //array of photos of this Contact
  List<ContactField> categories; //array of user defined categories by this Contact
  List<ContactField> urls;//array of web pages associated to this Contact
  
  /** Returns a cloned Contact object except its id is set to null.
   */
  Contact clone();
  
  /** Remove this Contact from the device's contacts list.
   */
  void remove(ContactSuccessCallback success, ContactErrorCallback error);
  
  /** Saves a new contact to the device contacts list; or updates an existing contact if exists the id.
   */
  void save(ContactSuccessCallback success, ContactErrorCallback error);
}

