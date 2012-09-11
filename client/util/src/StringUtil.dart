//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun Jan 15 11:04:13 TST 2012
// Author: tomyeh

/** String utilities.
 */
class StringUtil {
  /** Add the given offset to each character of the given string.
   */
  static String addCharCodes(String src, int diff) {
    int j = src.length;
    final List<int> dst = new List(j);
    while (--j >= 0)
      dst[j] = src.charCodeAt(j) + diff;
    return new String.fromCharCodes(dst);
  }

  /** Return a string representation of the integer argument in base 16.
   *
   * [digits] specifies how many digits to generate at least.
   * If non-positive, it is ignored (i.e., any number is OK).
   */
  static String toHexString(num value, [int digits=0]) {
    _init();
    final List<int> codes = new List();
    int val = value.toInt();
    if (val < 0) val = (0xffffffff + val) + 1;
    while (val > 0) {
      int cc = val & 0xf;
      val >>= 4;
      if (cc < 10) cc += _CC_0;
      else cc += _CC_a - 10;
      codes.insertRange(0, 1, cc);
    }
    
    if ((val = digits - codes.length) > 0)
      codes.insertRange(0, val, _CC_0);
    return codes.isEmpty() ? "0": new String.fromCharCodes(codes);
  }

  /**
   * Returns whether the character matches the specified conditions.
   *
   * + [cc] is the character to test.
   * + [digit] specifies if it matches digit.
   * + [upper] specifies if it matches upper case.
   * + [lower] specifies if it matches lower case.
   * + [whitespace] specifies if it matches whitespace.
   * + [match] specifies a string of characters that are matched.
   */
  static bool isChar(String cc, [bool digit=false, bool upper=false, bool lower=false,
  bool whitespace=false, String match=null]) {
    _init();

    int v = cc.isEmpty() ? 0: cc.charCodeAt(0);
    return (digit && v >= _CC_0 && v <= _CC_9)
    || (upper && v >= _CC_A && v <= _CC_Z)
    || (lower && v >= _CC_a && v <= _CC_z)
    || (whitespace && (cc == ' ' || cc == '\t' || cc == '\n' || cc == '\r'))
    || (match != null && match.indexOf(cc) >= 0);
  }
  static void _init() {
    //TODO: remove them if Dart supports non-constant final
    if (_CC_0 == null) {
      _CC_0 = '0'.charCodeAt(0); _CC_9 = _CC_0 + 9;
      _CC_A = 'A'.charCodeAt(0); _CC_Z = _CC_A + 25;
      _CC_a = 'a'.charCodeAt(0); _CC_z = _CC_a + 25;
    }
  }
  /** TODO: use intializer below when Dart supports non-constant final
  static final int _CC_0 = '0'.charCodeAt(0), _CC_9 = _CC_0 + 9,
    _CC_A = 'A'.charCodeAt(0), _CC_Z = _CC_A + 25,
    _CC_a = 'a'.charCodeAt(0), _CC_z = _CC_a + 25;*/
  static int _CC_0, _CC_9, _CC_A, _CC_Z, _CC_a, _CC_z;

  /** Encodes an integer to a string consisting of alpanumeric characters
   * and underscore. With a prefix, it can be used as an identifier.
   */
  static String encodeId(int v, [String prefix]) {
    final StringBuffer sb = new StringBuffer();
    if (prefix != null)
      sb.add(prefix);

    do {
      int v2 = v % 37;
      if (v2 <= 9) sb.add(addCharCodes('0', v2));
      else sb.add(v2 == 36 ? '_': addCharCodes('a', v2 - 10));
    } while ((v ~/= 37) >= 1);
    return sb.toString();
  }

  /** Returns a String that filter out from a "source" String any characters specified in "exclude" String. 
   * e.g.
   * filterOut("aabbccdd", "bd") will return "aacc"; "b" and "c" character are filter out.
   * + [source] - the source String.
   * + [exclude] - the characters to be excluded.
   */ 
  static String filterOut(String source, String exclude) {
    StringBuffer sb = new StringBuffer();
    for (int j = 0, len = source.length; j < len; ++j) {
      final String ch = source[j];
      if (!exclude.contains(ch))
        sb.add(ch);
    }
    return sb.toString();
  }
  
  /** Returns a String that filter out from a "source" String any characters not specified in "include" String. 
   * e.g.
   * filterIn("aabbccdd", "bd") will return "bbdd"; "b" and "c" character are filter in.
   * + [source] - the source String.
   * + [include] - the characters to be included.
   */ 
  static String filterIn(String source, String include) {
    StringBuffer sb = new StringBuffer();
    for (int j = 0, len = source.length; j < len; ++j) {
      final String ch = source[j];
      if (include.contains(ch))
        sb.add(ch);
    }
    return sb.toString();
  }
}
