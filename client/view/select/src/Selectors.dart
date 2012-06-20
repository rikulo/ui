//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class Selectors {
  
  /**
   * Parse the query string to obtain the selector objects.
   */
  static List<Selector> parse(String source) {
    final List<Token> tokens = tokenize(source);
    final List<Selector> selectors = new List<Selector>();
    final int len = tokens.length;
    int state = STATE_PRE_SLCT;
    Selector curr = null;
    SimpleSelectorSequence currSeq = null;
    
    for (Token t in tokens) {
      
      if (t.type == Token.TYPE_SELECTOR_SEPARATOR) {
        switch (state) {
          case STATE_IN_SLCT:
          case STATE_POST_SLCT:
          case STATE_PRE_PSDOCLS_PARAM:
          case STATE_PRE_COMB:
          case STATE_IN_SLCT:
            break; // do nothing
          default:
            throw new SelectorParseException.unexpectedToken(source, t);
        }
        curr = null;
        currSeq = null;
        state = STATE_POST_SEPR;
        continue;
      }
      
      // request a sequence instance
      if (currSeq == null && _requireSequence(state, t.type)) {
        if (curr == null)
          selectors.add(curr = new Selector(selectors.length));
        currSeq = curr.addSequence();
      }
      
      // handle misc case here, as Dart does not support unbreaked case.
      switch (state) {
        case STATE_POST_SEPR:
          if (t.type == Token.TYPE_WHITESPACE) { // ignore white space after separator
            state = STATE_PRE_SLCT;
            continue;
          }
          break;
        case STATE_PRE_COMB:
          switch (t.type) {
            case Token.TYPE_CBN_CHILD:
            case Token.TYPE_CBN_GENERAL_SIBLING:
            case Token.TYPE_CBN_ADJACENT_SIBLING:
              if (curr == null)
                throw new SelectorParseException.unexpectedToken(source, t);
              curr.addCombinator(t);
              state = STATE_POST_COMB;
              continue;
          }
          break;
        case STATE_PRE_PSDOCLS_PARAM:
          if (t.type == Token.TYPE_OPEN_PAREN) {
            state = STATE_IN_PSDOCLS_PARAM;
            continue;
          }
          break;
        case STATE_IN_PSDOCLS_PARAM:
          if (t.type != Token.TYPE_IDENTIFIER)
            throw new SelectorParseException.unexpectedToken(source, t);
          currSeq.pseudoClasses.last().parameter = t.source(source);
          state = STATE_POST_PSDOCLS_PARAM;
          continue;
        case STATE_POST_PSDOCLS_PARAM:
          if (t.type != Token.TYPE_CLOSE_PAREN)
            throw new SelectorParseException.unexpectedToken(source, t);
          state = STATE_IN_SLCT;
          continue;
      }
      
      // handle misc case here, as Dart does not support unbreaked case.
      switch (state) {
        case STATE_POST_SEPR:
        case STATE_PRE_COMB:
        case STATE_PRE_SLCT:
          switch (t.type) {
            case Token.TYPE_IDENTIFIER:
              currSeq.type = t.source(source);
              state = STATE_IN_SLCT;
              continue;
            case Token.TYPE_UNIVERSAL:
              currSeq = null;
              state = STATE_POST_SLCT;
              continue;
          }
          break;
        case STATE_PRE_PSDOCLS_PARAM:
        case STATE_IN_SLCT:
          if (t.type == Token.TYPE_WHITESPACE) {
            currSeq = null;
            state = STATE_PRE_COMB;
            continue;
          }
          break;
        case STATE_IN_ID:
        case STATE_IN_CLASS:
        case STATE_IN_PSDOCLS:
          if (t.type != Token.TYPE_IDENTIFIER)
            throw new SelectorParseException.unexpectedToken(source, t);
          break;
      }
      
      // main switch
      switch (state) {
        case STATE_POST_COMB:
          if (t.type != Token.TYPE_WHITESPACE)
            throw new SelectorParseException.unexpectedToken(source, t);
          state = STATE_PRE_SLCT;
          break;
        case STATE_POST_SEPR:
        case STATE_PRE_COMB:
        case STATE_PRE_PSDOCLS_PARAM:
        case STATE_PRE_SLCT:
        case STATE_IN_SLCT:
          // accepts all NTN
          switch (t.type) {
            case Token.TYPE_NTN_ID:
              state = STATE_IN_ID;
              break;
            case Token.TYPE_NTN_CLASS:
              state = STATE_IN_CLASS;
              break;
            case Token.TYPE_NTN_PSDOCLS:
              state = STATE_IN_PSDOCLS;
              break;
            default:
              throw new SelectorParseException.unexpectedToken(source, t);
          }
          break;
        case STATE_POST_SLCT:
          if (t.type != Token.TYPE_WHITESPACE)
            throw new SelectorParseException.unexpectedToken(source, t);
          state = STATE_PRE_COMB;
          break;
        case STATE_IN_ID:
          if (currSeq.id != null)
            throw new SelectorParseException.unexpectedToken(source, t);
          currSeq.id = t.source(source);
          state = STATE_IN_SLCT;
          break;
        case STATE_IN_CLASS:
          currSeq.classes.add(t.source(source));
          state = STATE_IN_SLCT;
          break;
        case STATE_IN_PSDOCLS:
          currSeq.pseudoClasses.add(new PseudoClass(t.source(source)));
          state = STATE_PRE_PSDOCLS_PARAM;
          break;
        default:
          throw new SelectorParseException.unexpectedToken(source, t);
      }
      
    } // end of token list for-loop
    
    // check ending state
    switch (state) {
      case STATE_IN_ID:
      case STATE_IN_CLASS:
      case STATE_IN_PSDOCLS:
      case STATE_POST_SEPR:
      case STATE_POST_COMB:
      case STATE_PRE_SLCT:
      case STATE_IN_PSDOCLS_PARAM:
      case STATE_POST_PSDOCLS_PARAM:
        throw new SelectorParseException.unexpectedEnding(source);
    }
    
    return selectors;
  }
  
  static bool _requireSequence(int state, int type) {
    if (type != Token.TYPE_IDENTIFIER && type != Token.TYPE_UNIVERSAL)
      return false;
    switch (state) {
      case STATE_POST_SEPR:
      case STATE_PRE_COMB:
      case STATE_PRE_SLCT:
      case STATE_IN_ID:
      case STATE_IN_CLASS:
      case STATE_IN_PSDOCLS:
      case STATE_PRE_ATTR_NAME:
        return true;
      default:
        return false;
    }
  }
  
  
  
  static final int STATE_PRE_SLCT = 1;
  static final int STATE_IN_SLCT = 9;
  static final int STATE_POST_SLCT = 14;
  static final int STATE_POST_COMB = 2;
  static final int STATE_PRE_COMB = 3;
  static final int STATE_POST_SEPR = 17;
  
  static final int STATE_IN_TYPE = 4;
  static final int STATE_IN_ID = 5;
  static final int STATE_IN_CLASS = 6;
  static final int STATE_IN_PSDOCLS = 7;
  static final int STATE_PRE_PSDOCLS_PARAM = 8;
  static final int STATE_IN_PSDOCLS_PARAM = 15;
  static final int STATE_POST_PSDOCLS_PARAM = 16;
  
  static final int STATE_PRE_ATTR_NAME = 10;
  static final int STATE_PRE_ATTR_OP = 11;
  static final int STATE_PRE_ATTR_VALUE = 12;
  static final int STATE_POST_ATTR_VALUE = 13;
  
  /**
   * Tokenize the query string.
   */
  static List<Token> tokenize(String source) {
    
    List<Token> tokens = new List<Token>();
    final int len = source.length;
    
    int pclz = TOKEN_CLASS_OTHER;
    Token curr = null;
    
    for (int i = 0; i < len; i++) {
      String c = source.substring(i, i+1);
      int ci = source.charCodeAt(i);
      int clz = _getTokenClass(ci);
      
      // TODO: concern attribute
      if (curr != null && clz == pclz && clz != TOKEN_CLASS_OTHER)
        curr.extend();
      else
        tokens.add(curr = new Token.fromChar(c, i));
      
      pclz = clz;
    }
    
    return tokens;
  }
  
  static final int TOKEN_CLASS_LITERAL = 0;
  static final int TOKEN_CLASS_WHITESPACE = 1;
  static final int TOKEN_CLASS_OTHER = 2;
  
  static int _getTokenClass(int c) {
    return _isWhitespace(c) ? TOKEN_CLASS_WHITESPACE : 
      _isLiteral(c) ? TOKEN_CLASS_LITERAL : TOKEN_CLASS_OTHER;
  }
  
  static bool _isLiteral(int c) {
    return (c > 96 && c < 123) /* a-z */ 
        || (c > 64 && c < 91) /* A-Z */
        || (c > 47 && c < 58) /* 0-9 */
        || c == 95 /* _ */ || c == 45; /* - */
  }
  
  static bool _isWhitespace(int c) {
    return (c == 32/*' '*/ || c == 9/*'\t'*/ || c == 10/*'\n'*/ ||
        c == 13/*'\r'*/);
  }
  
}
