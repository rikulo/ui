//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class ViewMatchContext {
  
  final ViewMatchContext parent;
  View view;
  int viewChildIndex = 0;
  final List<List<bool>> _qualified;
  
  // TODO: cache view sibling size?
  
  ViewMatchContext(this.view) : 
      parent = null, _qualified = new List<List<bool>>() {
    viewChildIndex = computeViewChildIndex(this.view);
  }
  
  ViewMatchContext.root(this.view, List<Selector> selectors) : parent = null, 
      _qualified = _initBoolList(selectors) {
    viewChildIndex = computeViewChildIndex(this.view);
  }
  
  ViewMatchContext.child(this.view, ViewMatchContext parent) : this.parent = parent,
    _qualified = _initBoolListFromParent(parent);
  
  
  
  // operation //
  void moveToNextSibling() {
    view = view.nextSibling;
    viewChildIndex++;
  }
  
  
  
  // match position //
  /**
   * Return true if the component matched the given position of the given 
   * selector.
   */
  bool isQualified(int selectorIndex, int position) {
    if (selectorIndex < 0 || selectorIndex >= _qualified.length)
      return false;
    List<bool> posq = _qualified[selectorIndex];
    return position > -1 && position < posq.length && posq[position];
  }
  
  void qualify(int selectorIndex, int position, [bool qualified = true]) {
    _qualified[selectorIndex][position] = qualified;
  }
  
  /**
   * Return true if the component matched the last position of any selectors
   * in the list. (i.e. the one we are looking for)
   */
  /**
   * Return true if the component matched the last position of the given
   * selector.
   * @param selectorIndex
   */
  bool isMatched([int selectorIndex = -1]) {
    if (selectorIndex < 0) {
      for (int i = 0; i < _qualified.length; i++) 
        if (isMatched(i)) 
          return true;
      return false;
      
    } else
      return selectorIndex < _qualified.length && _qualified[selectorIndex].last();
  }
  
  
  
  // match local property //
  /**
   * Return true if the component qualifies the local properties of a given
   * SimpleSelectorSequence.
   * @param seq 
   * @param defs 
   */
  bool match(SimpleSelectorSequence seq) {
    return matchType(this.view, seq.type) 
        && matchID(this.view, seq.id) 
        && matchClasses(this.view, seq.classes) 
        //&& matchAttributes(this.view, seq.getAttributes()) 
        && matchPseudoClasses(seq.pseudoClasses);
  }
  
  static bool matchID(View view, String id) {
    return id == null || id == view.id;
  }
  
  static bool matchType(View view, String type){
    return type == null || type == view.className;
  }
  
  static bool matchClasses(View view, Collection<String> classes) {
    if (classes == null || classes.isEmpty())
      return true;
    for (String c in classes)
      if (!view.classes.contains(c))
        return false;
    return true;
  }
  
  bool matchPseudoClasses(Collection<PseudoClass> pseudoClasses) {
    if (pseudoClasses == null || pseudoClasses.isEmpty())
      return true;
    for (PseudoClass pc in pseudoClasses) {
      Function accept = PseudoClass.getDefinition(pc.name);
      if (accept == null)
        throw new Exception("Pseudo class definition not found: ${pc.name}");
      if (!accept(this, pc.parameter)) 
        return false;
    }
    return true;
  }
  
  
  
  String toString() {
    StringBuffer sb = new StringBuffer();
    for (List<bool> qs in _qualified)
      sb.add(qs);
    return sb.add(" @${view}").toString();
  }
  
  // helper //
  static int computeViewChildIndex(View view) {
    int index = -1;
    while (view != null) {
      view = view.previousSibling;
      index++;
    }
    return index;
  }
  
  static List<List<bool>> _initBoolList(List<Selector> selectors) {
    List<List<bool>> list = new List<List<bool>>();
    List<bool> sublist;
    for (Selector s in selectors) {
      list.add(sublist = new List<bool>());
      for (int i = 0; i < s.seqs.length; i++)
        sublist.add(false);
    }
    return list;
  }
  
  static List<List<bool>> _initBoolListFromParent(ViewMatchContext parent) {
    List<List<bool>> plist = parent._qualified;
    List<List<bool>> list = new List<List<bool>>();
    List<bool> sublist;
    for (List<bool> psublist in plist) {
      list.add(sublist = new List<bool>());
      for (int i = 0; i < psublist.length; i++)
        sublist.add(false);
    }
    return list;
  }
  
}
