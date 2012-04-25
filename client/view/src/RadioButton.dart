//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:01:59 PM
// Author: tomyeh

/**
 * A radio button.
 * To group a collection of radio buttons, you have to create an instance of [RadioGroup]
 * to represent then group and then
 * handle the check event for the radio group. You don't need to handle
 * radio buttons seperately since the check event ([CheckEvent]) will be forwarded to the radio
 * group.
 * <p>To associate a radio button, you can make a radio button as a descendant
 * of a radio group, or you can assign it explicitly with [radioGroup].
 * 
 * <h3>Events</h3>
 * <ul>
 * <li>check: an instance of [CheckEvent] indicates the check state is changed.</li>
 * </ul>
 */
class RadioButton extends CheckBox {
	RadioGroup _radioGroup;

	RadioButton([String text="", String html="",
	bool checked=false, bool disabled=false, bool autofocus=false]):
	super(text, html, checked, disabled, autofocus) {
		vclass = "v-RadioButton";
	}

	/** Returns the radio group that this radio button belongs to.
	 * If no radio group is assigned, it assumed to be the nearest
	 * ancestor radio group.
	 */
	RadioGroup get radioGroup() {
		if (_radioGroup !== null)
			return _radioGroup;

		for (View view = this; (view = view.parent) !== null;)
			if (view is RadioGroup)
				return view;
		return null;
	}
	/** Sets the radio group that this radio button belongs to.
	 * You don't need to invoke this method if the radio group is ancestor of this radio button.
	 */
	void set radioGroup(RadioGroup group) {
		throw const UnsupportedOperationException("n/a"); //TODO
	}

	void _setGroupName(String name) {
		InputElement n = inputNode;
		if (n != null)
			n.name = name;
	}

	//@Override
	void onCheck_() {
		assert(_checked); //it must be checked for radio button

		final CheckEvent event = new CheckEvent(this, _checked);
		dispatchEvent(event);
		final RadioGroup group = radioGroup;
		if (group !== null)
			group._doCheck(event);
	}
	void _doUncheck() { //call from RadioGroup
		if (_checked) {
			_checked = false;
			dispatchEvent(new CheckEvent(this, false));
		}
	}

	//@Override
	String get domInputType_() => "radio";
	//@Override
	/** Default: [radioGroup]'s name.
	 */
	String get domInputName_() {
		final RadioGroup group = radioGroup;
		return group != null ? group.name: null;
	}
	//@Override
	String toString() => "RadioButton('$text$html', $checked)";
}
