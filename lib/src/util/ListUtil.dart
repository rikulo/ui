//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jun 05, 2012  9:16:58 AM
// Author: tomyeh

/**
 * A collection of List related utilities.
 */
class ListUtil {
  /** Removes the given object from the list.
   * It returns whether the object is found (and removed).
   * If [list] is null, false is returned.
   */
  static bool remove(List list, var obj) {
    if (list != null) {
      final int j = list.indexOf(obj);
      if (j >= 0) {
        list.removeRange(j, 1);
        return true;
      }
    }
    return false;
  }

  /** Checks if the given range is allowed in the given list.
   */
  static void rangeCheck(List a, int start, int length) {
    if (length < 0) {
      throw new IllegalArgumentException("negative length $length");
    }
    if (start < 0 || start >= a.length) {
      throw new IndexOutOfRangeException(start);
    }
    if (start + length > a.length) {
      throw new IndexOutOfRangeException(start + length);
    }
  }

  /** Returns the first element of the given collection, or null.
   */
  static first(Collection col)
  => col.isEmpty() ? null: col.iterator().next();

  /** A readonly and empty list.
   */
  static const List EMPTY_LIST = const [];
  /** A readonly and empty iterator.
   */
  static const Iterator EMPTY_ITERATOR = const _EmptyIter();
}

/**
 * A skeletal implementation of List.
 *
 * For unmodifiable sequential list, you need only to implement
 * [iterator] and [length].
 *
 * If it is not a equential list, you shall override [operator[]]
 * for better performance.
 *
 * If you don't override [operator[]], you shall consider to override
 * [last] for better performance.
 *
 * For mutable list, you shall override [operator[]=], [set length],
 * [add], [setRange], [insertRange], and [removeRange].
 */
abstract class AbstractList<T> implements List<T> {
  const AbstractList();

  //Collection//
  bool every(bool f(T element)) => Collections.every(this, f);
  Collection map(f(T element)) => Collections.map(this, [], f);
  Collection filter(bool f(T element)) => Collections.filter(this, [], f);
  void forEach(f(T element)) => Collections.forEach(this, f);
  Dynamic reduce(Dynamic initialValue, Dynamic combine(Dynamic previousValue, T element))
  => Collections.reduce(this, initialValue, combine);
  bool isEmpty() => this.length == 0;
  bool some(bool f(T element)) => Collections.some(this, f);

  //List//
  T operator[](int index) {
    ListUtil.rangeCheck(this, index, 1);

    final Iterator<T> it = iterator();
    while (--index >= 0)
      it.next();
    return it.next();
  }
  void operator[]=(int index, T value) {
    throw const UnsupportedOperationException("Cannot modify");
  }
  void set length(int newLength) {
    throw const UnsupportedOperationException("Cannot modify");
  }
  void add(T element) {
    throw const UnsupportedOperationException("Cannot modify");
  }
  void addLast(T element) {
    add(element);
  }
  void addAll(Collection<T> elements) {
    for (final T e in elements) {
      add(e);
    }
  }
  void sort(int compare(T a, T b)) {
    DualPivotQuicksort.sort(this, compare);
  }
  int indexOf(T element, [int start=0])
  => Arrays.indexOf(this, element, start, this.length);
  int lastIndexOf(T element, [int start]) {
    if (start == null) start = length - 1;
    return Arrays.lastIndexOf(this, element, start);
  }
  void clear() {
    removeRange(0, length);
  }
  T removeAt(int index) {
    T v = this[index];
    removeRange(index, 1);
    return v;
  }
  T removeLast() => removeAt(length - 1);
  T last() => this[length - 1];
  List<T> getRange(int start, int length) {
    if (length == 0) return [];
    ListUtil.rangeCheck(this, start, length);
    List list = new List<T>();
    list.length = length;
    Arrays.copy(this, start, list, 0, length);
    return list;
  }
  void setRange(int start, int length, List<T> from, [int startFrom]) {
    throw const UnsupportedOperationException("Cannot modify");
  }
  void removeRange(int start, int length) {
    throw const UnsupportedOperationException("Cannot modify");
  }
  void insertRange(int start, int length, [T initialValue]) {
    throw const UnsupportedOperationException("Cannot modify");
  }

  //@Override
  bool equals(var other) {
    if (other is Collection && other.length == length) {
      final Iterator<T> it = iterator();
      for (final o in other) {
        if (o != it.next())
          return false;
      }
      return true;
    }
    return false;
  }
  //@Override
  String toString() {
    StringBuffer result = new StringBuffer("[");
    bool comma;
    for (final T obj in this) {
      if (comma) result.add(", ");
      else comma = true;
      result.add(obj != null ? obj.toString(): "null");
    }
    return result.toString();
  }
}

class _EmptyIter<T> implements Iterator<T> {
  const _EmptyIter();

  T next() {
    throw const NoMoreElementsException();
  }
  bool hasNext() => false;
}