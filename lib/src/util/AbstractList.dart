//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue Feb 7 10:42:56 TST 2012
// Author: tomyeh

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
//abstract
class AbstractList<T> implements List<T> {
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
  int indexOf(T element, [int start]) {
    return Arrays.indexOf(this, element, start != null ? start: 0, this.length);
  }
  int lastIndexOf(T element, [int start]) {
    if (start == null) start = length - 1;
    return Arrays.lastIndexOf(this, element, start);
  }
  void clear() {
    removeRange(0, length);
  }
  T removeLast() {
    final T e = last();
    removeRange(length - 1, 1);
    return e;
  }
  T last() {
    return this[length - 1];
  }
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

final List EMPTY_LIST = const [];
