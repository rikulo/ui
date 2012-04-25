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
	String _name;
	RadioButton _selItem;

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
		if (nm === null || nm.isEmpty())
			throw const UiException("RadioGroup's name can't be null");
		_name = nm;

		if (inDocument)
			for (final RadioButton radio in items)
				radio._setGroupName(name);
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

	/** Returns all radio buttons in this group.
	 * <p>Notice that the iterator (returned by Iterator.iterator())
	 * assumes the view tree under this radio group
	 * doesn't change when iterating through all radio buttons.
	 */
	Iterable<RadioButton> get items() {
		//TODO: Use this.queryAll("RadioButton") when it is ready
		List<RadioButton> items = [];
		_findItems(items, this);
		return items;
	}
	void _findItems(List<RadioButton> items, View view) { //TODO: remove if queryAll ready
		if (view is RadioButton)
			items.add(view);
		for (final View child in view.children)
			_findItems(items, child);
	}

	String toString() => "RadioGroup($name)";
}
