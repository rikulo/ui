//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class Selector {
  
  final int selectorIndex;
  final List<SimpleSelectorSequence> seqs;
  
  Selector(this.selectorIndex) : seqs = new List<SimpleSelectorSequence>();
  
  void addCombinator(Token token) {
    seqs.last().setCombinatorByToken(token);
  }
  
  int getCombinator(int index) => seqs[index].combinator;
  
  bool requiresIdSpace(int index) => seqs[index].id != null;
  
  SimpleSelectorSequence addSequence() {
    SimpleSelectorSequence seq = new SimpleSelectorSequence();
    seqs.add(seq);
    return seq;
  }
  
  String toString() {
    String s = "";
    for (SimpleSelectorSequence seq in seqs)
      s += seq.toString() + seq.printCombinator() + " ";
    return s.trim();
  }
  
}
