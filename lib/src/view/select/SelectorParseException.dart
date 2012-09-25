//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 06, 2012  12:30:14 AM
// Author: simonpai

class SelectorParseException implements Exception {
  
  final String source;
  final Token token;
  final int index;
  
  SelectorParseException.unexpectedChar(this.source, this.index) : token = null;
  
  SelectorParseException.unexpectedToken(this.source, Token token) : 
    this.token = token, index = token.start;
  
  SelectorParseException.unexpectedEnding(this.source) :
    this.token = null, index = -1;
  
  String toString() => token == null ? (index < 0 ?
      "Unexpected end of selector: ${this.source}" :
      "Unexpected character at ${this.index} in selector ${this.source}") :
      "Unexpected token ${this.token.type} at ${this.index} in selector ${this.source}";
  
}
