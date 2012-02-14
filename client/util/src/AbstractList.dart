//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue Feb 7 10:42:56 TST 2012
// Author: tomyeh

/**
 * A skeletal implementation of List.
 * <p>For unmodifiable sequential list, you need only to implement
 * [iterator] and [length].
 * <p>If it is not a equential list, you shall override [operator[]]
 * for better performance.
 * <p>If you don't override [operator[]], you shall consider to override
 * [last] for better performance.
 * <p>For mutable list, you shall override [operator[]=], [set length],
 * [add], [setRange], [insertRange], and [removeRange].
 */
class AbstractList<E> implements List<E> {

	//Collection//
	bool every(bool f(E element)) {
		return Collections.every(this, f);
	}
	Collection map(f(E element)) {
		return Collections.map(this, [], f);
	}
	Collection filter(bool f(E element)) {
		return Collections.filter(this, [], f);
	}
	void forEach(f(E element)) {
		Collections.forEach(this, f);
	}
	bool isEmpty() {
		return this.length === 0;
	}
	bool some(bool f(E element)) {
		return Collections.some(this, f);
	}

	//List//
	E operator[](int index) {
		Arrays.rangeCheck(this, index, 1);

		final Iterator<E> it = iterator();
		while (--index >= 0)
			it.next();
		return it.next();
	}
	void operator[]=(int index, E value) {
		throw const UnsupportedOperationException("Cannot modify");
	}
	void set length(int newLength) {
		throw const UnsupportedOperationException("Cannot modify");
	}
	void add(E element) {
		throw const UnsupportedOperationException("Cannot modify");
	}
	void addLast(E element) {
		add(element);
	}
	void addAll(Collection<E> elements) {
		for (final E e in elements)
			add(e);
	}
	void sort(int compare(E a, E b)) {
		DualPivotQuicksort.sort(this, compare);
	}
	int indexOf(E element, [int start = 0]) {
		return Arrays.indexOf(this, element, start, this.length);
	}
	int lastIndexOf(E element, [int start = null]) {
		if (start === null) start = length - 1;
		return Arrays.lastIndexOf(this, element, start);
	}
	void clear() {
		removeRange(0, length);
	}
	E removeLast() {
		removeRange(length - 1, 1);
	}
	E last() {
		return this[length - 1];
	}
	List<E> getRange(int start, int length) {
		if (length == 0) return [];
		Arrays.rangeCheck(this, start, length);
		List list = new List<E>();
		list.length = length;
		Arrays.copy(this, start, list, 0, length);
		return list;
	}
	void setRange(int start, int length, List<E> from, [int startFrom = 0]) {
		throw const UnsupportedOperationException("Cannot modify");
	}
	void removeRange(int start, int length) {
		throw const UnsupportedOperationException("Cannot modify");
	}
	void insertRange(int start, int length, [E initialValue = null]) {
		throw const UnsupportedOperationException("Cannot modify");
	}

	String toString() {
		StringBuffer result = new StringBuffer("[");
		bool comma;
		for (final E obj in this) {
			if (comma) result.add(", ");
			else comma = true;
			result.add(obj != null ? obj.toString(): "null");
		}
		return result.toString();
	}
}
