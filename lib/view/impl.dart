//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 11:11:55 AM
// Author: tomyeh
library rikulo_view_impl;

import "dart:html";
import "dart:collection" show HashMap;
import "dart:async" show Timer;

import '../html.dart';
import "../view.dart";
import "../layout.dart";

part "../src/view/impl/ViewImpl.dart";
part "../src/view/impl/RunOnceViewManager.dart";

/** Encodes an integer to a string consisting of alpanumeric characters
 * and underscore. With a prefix, it can be used as an identifier.
 */
String encodeId(int v, [String prefix]) {
  final StringBuffer sb = new StringBuffer();
  if (prefix != null)
    sb.write(prefix);

  do {
    int v2 = v % 37;
    if (v2 <= 9) sb.write(_addCharCodes('0', v2));
    else sb.write(v2 == 36 ? '_': _addCharCodes('a', v2 - 10));
  } while ((v ~/= 37) >= 1);
  return sb.toString();
}

/** Add the given offset to each character of the given string.
 */
String _addCharCodes(String src, int diff) {
  int j = src.length;
  final List<int> dst = new List(j);
  while (--j >= 0)
    dst[j] = src.codeUnitAt(j) + diff;
  return new String.fromCharCodes(dst);
}

/** Return a string representation of the integer argument in base 16.
 *
 * * [digits] specifies how many digits to generate at least.
 * If non-positive, it is ignored (i.e., any number is OK).
 */
String toHexString(num value, [int digits=0]) {
  final List<int> codes = new List();
  int val = value.toInt();
  if (val < 0) val = (0xffffffff + val) + 1;
  while (val > 0) {
    int cc = val & 0xf;
    val >>= 4;
    if (cc < 10) cc += _CC_0;
    else cc += _CC_a - 10;
    codes.insert(0, cc);
  }

  for (int i = digits - codes.length; --i >= 0;)
    codes.insert(0, _CC_0);
  return codes.isEmpty ? "0": new String.fromCharCodes(codes);
}
const int _CC_0 = 48, /*_CC_9 = _CC_0 + 9,*/
    _CC_A = 65, /*_CC_Z = _CC_A + 25,*/
    _CC_a = 97/*, _CC_z = _CC_a + 25*/;
