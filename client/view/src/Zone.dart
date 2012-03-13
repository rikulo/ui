//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A segment that is a division ([Div]
 * and also an ID space ([IdSpace]).
 */
class Segment extends View implements IdSpace {
	//The fellows. Used only if this is IdSpace
	Map<String, View> _fellows;

	Segment() {
	  _fellows = {};
		wclass = "v-segment";
	}

	View getFellow(String id) => _fellows[id];
	void bindFellow_(String id, View fellow) {
		if (fellow !== null) _fellows[id] = fellow;
		else _fellows.remove(id);
	}
}
