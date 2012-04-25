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
class RadioGroup extends View implements Selection<RadioButton> {
	RadioButton _selItem;

	RadioGroup() {
		vclass = "v-RadioGroup";
	}

	/** Returns the selected radio button, or null if none is selected.
	 */
	RadioButton get selectedItem() => _selItem;
	//@Override
	Set<RadioButton> get selectedItems() {
		final Set<RadioButton> sels = new Set();
		if (_selItem !== null)
			sels.add(_selItem);
		return sels;
	}

	/** Handles the selected item when a radio button's check state is changed.
	 */
	void _updateSelected(RadioButton changed, bool checked) { //called from RadioButton
		if (checked) {
			if (_selItem !== null)
				_selItem._setChecked(false, false);
			_selItem = changed;
		} else if (_selItem === changed) {
			_selItem = null;
		}
	}

	String toString() => "RadioGroup($uuid)";
}
