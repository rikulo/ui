//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue Feb  7 09:08:49 TST 2012
// Author: tomyeh

/**
 * A list of child widgets.
 * Notice that [set length] are not supported
 */
class WidgetChildren extends AbstractList<Widget> {
	final Widget _owner;

	WidgetChildren(this._owner);

	//Iterable//
	Iterator<Widget> iterator() {
		return new _WCIterator(_owner);
	}

	//Collection//
	int get length() => _owner.childCount;

	//List//
	Widget operator[](int index) {
		Arrays.rangeCheck(this, index, 1);

		int index2 = length - index - 1;
		if (index <= index2) {
			Widget child = _owner.firstChild;
			while (--index >= 0)
				child = child.nextSibling;
			return child;
		} else {
			Widget child = _owner.lastChild;
			while (--index2 >= 0)
				child = child.previousSibling;
			return child;
		}
	}
			
	void operator[]=(int index, Widget value) {
		if (value === null)
			throw const IllegalArgumentException("null");

		final Widget w = this[index];
		if (w !== value) {
			final Widget next = w.nextSibling;
			_owner.removeChild(w);
			_owner.insertBefore(value, next);
		}
	}
	void add(Widget widget) {
		_owner.appendChild(widget);
	}
	void sort(int compare(Widget a, Widget b)) {
		List<Widget> copy = new List.from(this);
		copy.sort(compare);
		setRange(0, length, copy);
	}
	Widget removeLast() {
		final Widget last = last();
		if (last != null)
			_owner.removeChild(last);
		return last;
	}
	Widget last() {
		return _owner.lastChild;
	}
	void setRange(int start, int length, List<Widget> from, [int startFrom = 0]) {
		if (length <= 0)
			return; //nothing to do

		if (start > this.length) {
			throw new IndexOutOfRangeException(start);
		} else if (start == this.length) { //append
			if (startFrom == 0) { //optimize
				for (Iterator<Widget> it = from.iterator(); --length >= 0;)
					add(it.next());
			} else {
				while (--length >= 0)
					add(from[startFrom++]);
			}
		} else if (startFrom == 0) { //optimize
			Widget w = this[start];
			Iterator<Widget> it = from.iterator();
			while (--length >= 0) { //replace
				Widget value = it.next();
				final Widget next = w.nextSibling;
				if (w !== value) {
					_owner.removeChild(w);
					_owner.insertBefore(value, next);
				}
				if (next === null)
					break;
				w = next;
			}
			while (--length >= 0) //append
				add(it.next());
		} else {
			Widget w = this[start];
			while (--length >= 0) { //replace
				Widget value = from[startFrom++];
				final Widget next = w.nextSibling;
				if (w !== value) {
					_owner.removeChild(w);
					_owner.insertBefore(value, next);
				}
				if (next === null)
					break;
				w = next;
			}
			while (--length >= 0) //append
				add(from[startFrom++]);
		}
	}
	void removeRange(int start, int length) {
		if (length <= 0)
			return; //nothing to do

		Widget child = this[start];
		while (--length >= 0 && child != null) {
			Widget next = child.nextSibling;
			_owner.removeChild(child);
			child = next;
		}
	}
	void insertRange(int start, int length, [Widget initialValue = null]) {
		if (length != 1)
			throw const IllegalArgumentException("Allow only one widget");
		if (initialValue === null)
			throw const IllegalArgumentException("Require initialValue");
		if (start == this.length) {
			add(initialValue);
		} else {
			Widget w = this[start];
			_owner.insertBefore(initialValue, w);
		}
	}
}

class _WCIterator implements Iterator<Widget> {
	Widget _next;

	_WCIterator(Widget owner) {
		_next = owner.firstChild;
	}

	bool hasNext() {
		return _next != null;
	}
	Widget next() {
		if (_next === null)
			throw const NoMoreElementsException();
		Widget next = _next;
		_next = _next.nextSibling;
		return next;
	}
}
