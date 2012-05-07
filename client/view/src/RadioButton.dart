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
	RadioGroup _group;

	RadioButton([String text="", String html="",
	bool checked=false, bool disabled=false, bool autoFocus=false]):
	super(text, html, checked, disabled, autoFocus) {
		vclass = "v-RadioButton";
	}

	/** Returns the radio group that this radio button belongs to.
	 * If no radio group is assigned, it assumed to be the nearest
	 * ancestor radio group.
	 */
	RadioGroup get radioGroup() {
		return _group !== null ? _group: _groupOf(this);
	}
	/** Sets the radio group that this radio button belongs to.
	 * You don't need to invoke this method if the radio group is ancestor of this radio button.
	 */
	void set radioGroup(RadioGroup group) {
		final RadioGroup oldgroup = radioGroup;

		_group = group;

		group = radioGroup;
		if (group !== oldgroup)
			_groupChanged(oldgroup, group);
	}

	//@Override
	void set checked(bool checked) {
		_setChecked(checked, true); //yes, sync the radio group
	}
	void _setChecked(bool checked, bool updateGroup) {
		if (_checked != checked) {
			super.checked = checked;

			if (updateGroup) {
				RadioGroup group = radioGroup;
				if (group !== null)
					group._updateSelected(this, checked);
			}
		}
	}
	//@Override
	void onCheck_() {
		assert(_checked); //it must be checked for radio button

		final CheckEvent event = new CheckEvent(this, _checked);
		dispatchEvent(event);

		final RadioGroup group = radioGroup;
		if (group !== null) {
			final RadioButton oldradio = group.selectedItem;
			group._updateSelected(this, _checked);

			if (oldradio !== null)
				oldradio.dispatchEvent(new CheckEvent(oldradio, !_checked));
			group.dispatchEvent(event);
		}
	}
	//@Override
	void onParentChanged_(View oldParent) {
		super.onParentChanged_(oldParent);

		if (_group === null)
			_groupChanged(_groupOf(oldParent), _groupOf(parent));
	}
	RadioGroup _groupOf(View view) {
		for (;; view = view.parent)
			if (view === null || view is RadioGroup)
				return view;
	}
	void _groupChanged(RadioGroup oldgroup, RadioGroup newgroup) {
		if (checked) {
			if (oldgroup !== null)
				oldgroup._updateSelected(this, false);

			if (newgroup !== null) {
				if (newgroup.selectedItem !== null)
					_setChecked(false, false);
				else
					newgroup._updateSelected(this, true);
			}
			final InputElement n = inputNode;
			if (n !== null)
				n.name = newgroup !== null ? newgroup.uuid: "";
		}
	}

	//@Override
	String get domInputType_() => "radio";
	//@Override
	/** Default: [radioGroup]'s UUID.
	 */
	String get domInputName_() {
		final RadioGroup group = radioGroup;
		return group != null ? group.uuid: null;
	}
	//@Override
	String toString() => "RadioButton('$text$html', $checked)";
}
