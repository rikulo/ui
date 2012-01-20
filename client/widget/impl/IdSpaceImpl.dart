/* IdSpaceImpl.dart

  IdSpace utilities for implementation
  It is included by ../Widget.dart

  History:
    Tue Jan 17 17:00:49 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/

/** A virtual ID space. Used only internally.
 */
class _VirtualIdSpace implements IdSpace {
  Widget _owner;
  Map<String, Widget> _fellows;

  _VirtualIdSpace(this._owner): _fellows = {};
  
  Widget query(String selector) => _owner.query(selector);
  List<Widget> queryAll(String selector) => _owner.queryAll(selector);
  Widget getFellow(String id) => _fellows[id];
}
