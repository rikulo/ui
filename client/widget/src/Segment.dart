//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A segment that is a division ([Div]
 * and also an ID space ([IdSpace]).
 */
class Segment extends Widget implements IdSpace {
	//The fellows. Used only if this is IdSpace
	Map<String, Widget> _fellows = {};

	Segment() {
		wclass = "w-segment";
	}

	Widget getFellow(String id) => _fellows[id];
	void bindFellow_(String id, Widget fellow) {
		if (fellow !== null) _fellows[id] = fellow;
		else _fellows.remove(id);
	}
}
