//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:01:59 PM
// Author: tomyeh

/**
 * A radio button.
 * <p>There are a couple ways to use radio buttons.
 * <p><b>Approach 1:</b>
 * You can assign [groupName] to radio buttons that belong to
 * the same group. Then, handle the check event for every radio button.
 * It is useful if you'd like to handle each radio button individually.
 * <p><b>Approach 2:</b>
 * You can create an instance of [RadioGroup] to represent a group and then
 * handle the check event for the radio group. You don't need to handle
 * radio buttons seperately since the check event will be forwarded to the radio
 * group.
 * <p>To associate a radio button, you can make a radio button as a descendant
 * of a radio group, or you can assign it explicitly with [radioGroup].
 * <p>Notice that [groupName] has the higher priority than [radioGroup].
 * <h3>Events</h3>
 * <ul>
 * <li>check: an instance of [CheckEvent] indicates the check state is changed.</li>
 * </ul>
 */
class RadioButton extends CheckBox {
	String _groupName;
	RadioGroup _radioGroup;

	RadioButton([String text="", String html="",
	bool checked=false, String groupName, bool disabled=false, bool autofocus=false]):
	super(text, html, checked, disabled, autofocus) {
		_groupName = groupName;
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

	/** Returns the group's name, or null if not assigned and it is not assigned
	 * with a radio group.
	 * <p>Default: [radioGroup]'s [RadioGroup.name], or null if no radio group either.
	 * <p>Note: the name assigned to [groupName] has the higher priority.
	 * To clean it up, assign <code>null</code> to it.
	 */
	String get groupName() {
		if (_groupName !== null)
			return _groupName;

		final RadioGroup group = radioGroup;
		return group !== null ? group.name: null;
	}
	/** Sets the group's name.
	 * If [radioGroup] is found, the group name set by this method is ignored.
	 */
	void set groupName(String name) {
		_groupName = name;
		final InputElement n = inputNode;
		if (n !== null) {
			String nm = groupName;
			n.name = nm !== null ? nm: "";
		}
	}

	//@Override
	void onCheck_() {
		final CheckEvent event = new CheckEvent(this, _checked);
		dispatchEvent(event);
		final RadioGroup group = radioGroup;
		if (group !== null)
			group.dispatchEvent(event);
	}
	//@Override
	String get domInputType_() => "radio";
	//@Override
	/** Default: [groupName].
	 */
	String get domInputName_() => groupName;
	String toString() => "RadioButton('$text$html', $checked)";
}
