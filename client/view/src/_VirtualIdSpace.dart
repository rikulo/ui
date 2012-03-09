//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 17, 2012

/** A virtual ID space. Used only internally.
 */
class _VirtualIdSpace implements IdSpace {
	View _owner;
	Map<String, View> _fellows;

	_VirtualIdSpace(this._owner): _fellows = {};
	
	View query(String selector) => _owner.query(selector);
	List<View> queryAll(String selector) => _owner.queryAll(selector);

	View getFellow(String id) => _fellows[id];
	void bindFellow_(String id, View fellow) {
		if (fellow !== null) _fellows[id] = fellow;
		else _fellows.remove(id);
	}
}
