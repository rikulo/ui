//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class ViewIterator implements Iterator<View> {
  
  final View _root;
  final List<Selector> _selectors;
  int _posOffset;
  bool _allIds;
  
  View _offsetRoot;
  ViewMatchContext _currCtx;
  
  bool _ready = false;
  View _next;
  int _index = -1;
  
  ViewIterator(this._root, String selector) : _selectors = Selectors.parse(selector) {
    this._posOffset = _getCommonSeqLength(this._selectors);
    this._allIds = _isAllIds(this._selectors, this._posOffset);
  }
  
  View next() {
    if (!hasNext()) 
      throw new NoMoreElementsException();
    _ready = false;
    return _next;
  }
  
  bool hasNext() {
    _loadNext();
    return _next != null;
  }
  
  void _loadNext() {
    if (_ready) 
      return;
    _next = _seekNext();
    _ready = true;
  }
  
  View _seekNext() {
    _currCtx = _index < 0 ? _buildRootCtx() : _buildNextCtx();

    while (_currCtx != null && !_currCtx.isMatched()) {
      _currCtx = _buildNextCtx();
    }
    if (_currCtx != null) {
      _index++;
      return _currCtx.view;
    }
    return null;
  }
  
  ViewMatchContext _buildRootCtx() {
    View rt = _root;
    
    if (_posOffset > 0) {
      Selector selector = _selectors[0];
      for (int i = 0; i < _posOffset; i++) {
        SimpleSelectorSequence seq = selector.seqs[i];
        View rt2 = rt.getFellow(seq.id);
        
        if (rt2 == null)
          return null;
        
        // match local properties
        if (!ViewMatchContext.matchType(rt2, seq.type) || 
            !ViewMatchContext.matchClasses(rt2, seq.classes) ||
            //!ComponentLocalProperties.matchAttributes(rt2, seq.attributes) ||
            !new ViewMatchContext(rt2).matchPseudoClasses(seq.pseudoClasses))
          return null;
        
        // check combinator for second and later jumps
        if (i > 0) {
          switch (selector.getCombinator(i - 1)) {
          case SimpleSelectorSequence.COMB_DESCENDANT:
            if (!isDescendant(rt2, rt))
              return null;
            break;
          case SimpleSelectorSequence.COMB_CHILD:
            if (rt2.parent != rt)
              return null;
            break;
          case SimpleSelectorSequence.COMB_GENERAL_SIBLING:
            if (!isGeneralSibling(rt2, rt))
              return null;
            break;
          case SimpleSelectorSequence.COMB_ADJACENT_SIBLING:
            if (rt2.previousSibling != rt)
              return null;
            break;
          }
        }
        rt = rt2;
      }
      _offsetRoot = rt.parent;
    }
    
    ViewMatchContext ctx = new ViewMatchContext.root(rt, _selectors);
    
    if (_posOffset > 0)
      for (Selector selector in _selectors)
        ctx.qualify(selector.selectorIndex, _posOffset - 1);
    else
      matchLevel0(ctx);
    
    return ctx;
  }
  
  ViewMatchContext _buildNextCtx() {
    
    if (_allIds)
      return null;
    
    // TODO: how to skip tree branches
    
    if (_currCtx.view.firstChild != null) 
      return _buildFirstChildCtx(_currCtx);
    
    while (_currCtx.view.nextSibling == null) {
      _currCtx = _currCtx.parent;
      if (_currCtx == null || _currCtx.view == 
          (_posOffset > 0 ? _offsetRoot : _root)) // TODO: check
        return null; // reached root
    }
    
    return _buildNextSiblingCtx(_currCtx);
  }
  
  ViewMatchContext _buildFirstChildCtx(ViewMatchContext parent) {
    
    ViewMatchContext ctx = new ViewMatchContext.child(parent.view.firstChild, parent);
    
    if (_posOffset == 0)
      matchLevel0(ctx);
    
    for (Selector selector in _selectors) {
      int i = selector.selectorIndex;
      int posStart = _posOffset > 0 ? _posOffset - 1 : 0;
      
      for (int j = posStart; j < selector.seqs.length - 1; j++) {
        switch (selector.getCombinator(j)) {
        case SimpleSelectorSequence.COMB_DESCENDANT:
          if (parent.isQualified(i, j) && checkIdSpace(selector, j+1, ctx))
            ctx.qualify(i, j);
          if (parent.isQualified(i, j) && match(selector, ctx, j+1)) 
            ctx.qualify(i, j+1);
          break;
          
        case SimpleSelectorSequence.COMB_CHILD:
          if (parent.isQualified(i, j) && match(selector, ctx, j+1)) 
            ctx.qualify(i, j+1);
          break;
        }
      }
    }
    return ctx;
  }
  
  ViewMatchContext _buildNextSiblingCtx(ViewMatchContext ctx) {
    
    ctx.moveToNextSibling();
    
    for (Selector selector in _selectors) {
      int i = selector.selectorIndex;
      int posEnd = _posOffset > 0 ? _posOffset - 1 : 0;
      int len = selector.seqs.length;
      
      // clear last position, may be overridden later
      ctx.qualify(i, len - 1, false);
      
      for (int j = len - 2; j >= posEnd; j--) {
        int cb = selector.getCombinator(j);
        ViewMatchContext parent = ctx.parent;
        
        switch (cb) {
        case SimpleSelectorSequence.COMB_DESCENDANT:
          bool parentPass = parent != null && parent.isQualified(i, j);
          ctx.qualify(i, j, 
              parentPass && checkIdSpace(selector, j+1, ctx));
          if (parentPass && match(selector, ctx, j+1))
            ctx.qualify(i, j+1);
          break;
        case SimpleSelectorSequence.COMB_CHILD:
          ctx.qualify(i, j+1, parent != null && 
              parent.isQualified(i, j) && match(selector, ctx, j+1));
          break;
        case SimpleSelectorSequence.COMB_GENERAL_SIBLING:
          if (ctx.isQualified(i, j)) 
            ctx.qualify(i, j+1, match(selector, ctx, j+1));
          break;
        case SimpleSelectorSequence.COMB_ADJACENT_SIBLING:
          ctx.qualify(i, j+1, ctx.isQualified(i, j) && 
              match(selector, ctx, j+1));
          ctx.qualify(i, j, false);
        }
      }
    }
    
    if (_posOffset == 0)
      matchLevel0(ctx);
    
    return ctx;
  }
  
  static bool checkIdSpace(Selector selector, int index, ViewMatchContext ctx) {
    return !selector.requiresIdSpace(index) || !(ctx.view is IdSpace);
  }
  
  static bool isDescendant(View c1, View c2) {
    if (c1 == c2)
      return true; // first c1 can be IdSpace
    while ((c1 = c1.parent) != null) {
      if (c1 == c2)
        return true;
      if (c1 is IdSpace)
        return c1 == c2;
    }
    return false;
  }
  
  static bool isGeneralSibling(View c1, View c2) {
    while (c1 != null) {
      if (c1 == c2)
        return true;
      c1 = c1.previousSibling;
    }
    return false;
  }
  
  void matchLevel0(ViewMatchContext ctx) {
    for (Selector selector in _selectors)
      if (match(selector, ctx, 0))
        ctx.qualify(selector.selectorIndex, 0);
  }
  
  bool match(Selector selector, ViewMatchContext ctx, int index) {
    return ctx.match(selector.seqs[index]);
  }
  
  // helper //
  static int _getCommonSeqLength(List<Selector> list) {
    List<String> strs = null;
    int max = 0;
    for (Selector selector in list) {
      if (strs == null) {
        strs = new List<String>();
        for (SimpleSelectorSequence seq in selector.seqs) {
          String id = seq.id;
          if (id != null && !id.isEmpty()) {
            strs.add(seq.toString());
            strs.add(seq.printCombinator());
          } else
            break;
        }
        max = strs.length;
      } else {
        int i = 0;
        for (SimpleSelectorSequence seq in selector.seqs) {
          String id = seq.id;
          if (i >= max || id == null || id.isEmpty() || 
              strs[i++] != seq.toString() || 
              strs[i++] != seq.printCombinator())
            break;
        }
        if (i-- < max)
          max = i;
      }
    }
    return ((max + 1) / 2).toInt();
  }
  
  static bool _isAllIds(List<Selector> list, int offset) {
    for (Selector s in list)
      if (s.seqs.length > offset)
        return false;
    return true;
  }
  
}

class ViewIterable implements Iterable<View> {
  
  final View _root;
  final String _selector;
  
  ViewIterable(this._root, this._selector);
  
  Iterator<View> iterator() => new ViewIterator(_root, _selector);
  
}
