//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012

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
