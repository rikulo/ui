//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:02:46 PM
// Author: tomyeh

/**
 * A radio group.
 * <h3>Events</h3>
 * <ul>
 * <li>check: an instance of [CheckEvent] indicates the check state is changed.
 * Notice that [CheckEvent.target] is an instance of [RadioButton] that has been checked.</li>
 * </ul>
 */
class RadioGroup extends View {
	String _name;

	RadioGroup([String name]) {
		_name = name;
		vclass = "v-RadioGroup";
	}

	/** Returns the name of a radio group.
	 * <p>Default: [uuid].
	 */
	String get name() => _name !== null ? _name: (_name = uuid);
	/** Sets the name of a radio group.
	 * <p>The name must be unique.
	 */
	void set name(String nm) {
		if (name === null || name.isEmpty())
			throw const UiException("RadioGroup's name can't be null");
		_name = name;
		//TODO: we have to handle all raio buttons
	}

	String toString() => "RadioGroup($name)";
}
