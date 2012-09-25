//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue Feb  7 09:08:49 TST 2012
// Author: tomyeh

/**
 * A list of child views.
 * Notice that [set length] are not supported
 */
class _SubviewList extends AbstractList<View> {
  final View _owner;

  _SubviewList(this._owner);

  //Iterable//
  Iterator<View> iterator() {
    return new _WCIterator(_owner);
  }

  //Collection//
  int get length => _owner.childCount;

  //List//
  View operator[](int index) {
    ListUtil.rangeCheck(this, index, 1);

    int index2 = length - index - 1;
    if (index <= index2) {
      View child = _owner.firstChild;
      while (--index >= 0)
        child = child.nextSibling;
      return child;
    } else {
      View child = _owner.lastChild;
      while (--index2 >= 0)
        child = child.previousSibling;
      return child;
    }
  }
      
  void operator[]=(int index, View value) {
    if (value == null)
      throw const IllegalArgumentException("null");

    final View w = this[index];
    if (w !== value) {
      final View next = w.nextSibling;
      w.removeFromParent();
      _owner.addChild(value, next);
    }
  }
  void add(View view) {
    _owner.addChild(view);
  }
  void sort(int compare(View a, View b)) {
    List<View> copy = new List.from(this);
    copy.sort(compare);
    setRange(0, length, copy);
  }
  View removeLast() {
    final View w = last();
    if (w != null)
      w.removeFromParent();
    return w;
  }
  View last() {
    return _owner.lastChild;
  }
  void setRange(int start, int length, List<View> from, [int startFrom]) {
    if (length <= 0)
      return; //nothing to do
    if (startFrom == null)
      startFrom = 0;

    if (start > this.length) {
      throw new IndexOutOfRangeException(start);
    } else if (start == this.length) { //append
      if (startFrom == 0) { //optimize
        for (Iterator<View> it = from.iterator(); --length >= 0;) {
          add(it.next());
        }
      } else {
        while (--length >= 0)
          add(from[startFrom++]);
      }
    } else if (startFrom == 0) { //optimize
      View w = this[start];
      Iterator<View> it = from.iterator();
      while (--length >= 0) { //replace
        View value = it.next();
        final View next = w.nextSibling;
        if (w !== value) {
          w.removeFromParent();
          _owner.addChild(value, next);
        }
        if (next == null)
          break;
        w = next;
      }
      while (--length >= 0) //append
        add(it.next());
    } else {
      View w = this[start];
      while (--length >= 0) { //replace
        View value = from[startFrom++];
        final View next = w.nextSibling;
        if (w !== value) {
          w.removeFromParent();
          _owner.addChild(value, next);
        }
        if (next == null)
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

    View child = this[start];
    while (--length >= 0 && child != null) {
      final View next = child.nextSibling;
      child.removeFromParent();
      child = next;
    }
  }
  void insertRange(int start, int length, [View initialValue]) {
    if (length != 1)
      throw const IllegalArgumentException("Allow only one view");
    if (initialValue == null)
      throw const IllegalArgumentException("Require initialValue");
    if (start == this.length) {
      add(initialValue);
    } else {
      View w = this[start];
      _owner.addChild(initialValue, w);
    }
  }
}

class _WCIterator implements Iterator<View> {
  View _next;

  _WCIterator(View owner) {
    _next = owner.firstChild;
  }

  bool hasNext() {
    return _next != null;
  }
  View next() {
    if (_next == null)
      throw const NoMoreElementsException();
    View nxt = _next;
    _next = _next.nextSibling;
    return nxt;
  }
}
