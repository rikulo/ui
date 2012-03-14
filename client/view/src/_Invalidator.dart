//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 13, 2012  2:14:29 PM
// Author: tomyeh

/**
 * 
 */
class _Invalidator {
}

_Invalidator get _invalidator() {
	if (_cacheInvalidator == null)
		_cacheInvalidator = new _Invalidator();
	return _cacheInvalidator;
}
_Invalidator _cacheInvalidator;