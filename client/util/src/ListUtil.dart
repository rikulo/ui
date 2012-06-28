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
    if (list !== null) {
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

  /** A readonly and empty collection.
   */
  static final Collection emptyCollection = const _EmptyColl();
  /** A readonly and empty iterator.
   */
  static final Iterator emptyIterator = const _EmptyIter();
}

class _EmptyColl<E> implements Collection<E> {
  const _EmptyColl();

  Iterator<E> iterator() => ListUtil.emptyIterator;
  void forEach(void f(E element)) {}
  Collection map(f(E element)) => ListUtil.emptyCollection;
  Collection<E> filter(bool f(E element)) => ListUtil.emptyCollection;
  bool every(bool f(E element)) => false;
  bool some(bool f(E element)) => false;
  bool isEmpty() => true;
  int get length() => 0;
}
class _EmptyIter<E> implements Iterator<E> {
  const _EmptyIter();

  E next() {
    throw const NoMoreElementsException();
  }
  bool hasNext() => false;
}