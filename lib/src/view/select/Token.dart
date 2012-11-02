//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai
part of rikulo_view_select;

class Token {
  
  final int type;
  final int start;
  int end;
  
  Token(this.type, this.start, this.end);
  
  Token.fromChar(String c, int index) : 
      start = index, end = index + 1, type = getTypeFromChar(c);
  
  static int getTypeFromChar(String c) { // TODO: later, concern attribute
    int code = c.charCodeAt(0);
    if (isLiteral(code))
      return TYPE_IDENTIFIER;
    if (isWhitespace(code))
      return TYPE_WHITESPACE;
    switch(c) {
      case "*":
        return TYPE_UNIVERSAL;
      case ",":
        return TYPE_SELECTOR_SEPARATOR;
      case ">":
        return TYPE_CBN_CHILD;
      case "+":
        return TYPE_CBN_ADJACENT_SIBLING;
      case "~":
        return TYPE_CBN_GENERAL_SIBLING;
      case "#":
        return TYPE_NTN_ID;
      case ".":
        return TYPE_NTN_CLASS;
      case ":":
        return TYPE_NTN_PSDOCLS;
      case "=":
        return TYPE_OP_EQUAL;
      case "'":
        return TYPE_SINGLE_QUOTE;
      case "\"":
        return TYPE_DOUBLE_QUOTE;
      case "[":
        return TYPE_OPEN_BRACKET;
      case "]":
        return TYPE_CLOSE_BRACKET;
      case "(":
        return TYPE_OPEN_PAREN;
      case ")":
        return TYPE_CLOSE_PAREN;
      default:
        return TYPE_UNKNOWN_CHAR;
    }
  }
  
  /**
   * Retrieve the String content of the token.
   */
  String source(String src) => src.substring(start, end);
  
  /**
   * Extend the range of this token by 1.
   */
  int extend() => this.end++;
  
  String toString() => "${this.type}";
  
  // TODO: maybe shall align with char code
  // selector body //
  static const int TYPE_IDENTIFIER = 1;
  static const int TYPE_UNIVERSAL  = 2; // *
  // white space //
  static const int TYPE_WHITESPACE       = 3;
  static const int TYPE_MINOR_WHITESPACE = 4;
  // comma //
  static const int TYPE_SELECTOR_SEPARATOR = 5; // ,
  static const int TYPE_PARAM_SEPARATOR    = 6; // ,
  // combinator //
  static const int TYPE_CBN_CHILD            = 7; // >
  static const int TYPE_CBN_ADJACENT_SIBLING = 8; // +
  static const int TYPE_CBN_GENERAL_SIBLING  = 9; // ~
  // selector notation //
  static const int TYPE_NTN_ID      = 10; // #
  static const int TYPE_NTN_CLASS   = 11; // .
  static const int TYPE_NTN_PSDOCLS = 12; // :
  // attribute boolean operator //
  static const int TYPE_OP_EQUAL      = 13; // =
  static const int TYPE_OP_BEGIN_WITH = 14; // ^=
  static const int TYPE_OP_END_WITH   = 15; // $=
  static const int TYPE_OP_CONTAIN    = 16; // *=
  // pairwise //
  static const int TYPE_SINGLE_QUOTE  = 17; // '
  static const int TYPE_DOUBLE_QUOTE  = 18; // "
  static const int TYPE_OPEN_BRACKET  = 19; // [
  static const int TYPE_CLOSE_BRACKET = 20;  // ]
  static const int TYPE_OPEN_PAREN    = 21; // (
  static const int TYPE_CLOSE_PAREN   = 22; // )
  // unknown //
  static const int TYPE_UNKNOWN_CHAR = -1;
  
  
  
  /**
   * Return true if c is the char code of an alphabet, a digit, hyphen or underscore.
   */
  static bool isLiteral(int c) {
    return (c > 96 && c < 123) /* a-z */ 
        || (c > 64 && c < 91) /* A-Z */
        || (c > 47 && c < 58) /* 0-9 */
        || c == 95 /* _ */ || c == 45; /* - */
  }

  /**
   * Return true if c is the char code of a white space, including space, \t, \n, \n.
   */
  static bool isWhitespace(int c) {
    return (c == 32/*' '*/ || c == 9/*'\t'*/ || c == 10/*'\n'*/ ||
        c == 13/*'\r'*/);
  }
  
}
