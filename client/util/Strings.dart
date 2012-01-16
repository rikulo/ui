/* Strings.dart

  String utilities.

  History:
    Sun Jan 15 11:04:13 TST 2012, Created by tomyeh

Copyright (C) 2012 Potix Corporation. All Rights Reserved.
*/
#library("dargate:util:Strings");

/** Add the given offset to each character of the given string.
 */
String addCharCodes(String src, int diff) {
	int j = src.length;
	final List<int> dst = new List(j);
	while (--j >= 0)
		dst[j] = src.charCodeAt(j) + diff;
	return new String.fromCharCodes(dst);
}