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

final Map<String, String>
  _decs = const {'lt': '<', 'gt': '>', 'amp': '&', 'quot': '"'},
  _encs = const {'<': 'lt', '>': 'gt', '&': 'amp', '"': 'quot'};

/** Encodes the string to a valid XML string.
 * @param String txt the text to encode
 * @param Map opts [optional] the options. Allowd value:
 * <ul>
 * <li>pre - whether to replace whitespace with &amp;nbsp;</li>
 * <li>multiline - whether to replace linefeed with &lt;br/&gt;</li>
 * <li>maxlength - the maximal allowed length of the text</li>
 * </ul>
 * @return String the encoded text.
 */
String encodeXML(String txt,
[bool pre=false, bool multiline=false, int maxlength=0]) {
  if (txt == null) return null; //as it is

  int tl = txt.length;
  multiline = pre || multiline;

  if (!multiline && maxlength > 0 && tl > maxlength) {
    int j = maxlength;
    while (j > 0 && txt[j - 1] == ' ')
      --j;
    return encodeXML(txt.substring(0, j) + '...', pre:pre, multiline:multiline);
  }

  final StringBuffer out = new StringBuffer();
  int k = 0;
  String enc;
  if (multiline || pre) {
    for (int j = 0; j < tl; ++j) {
      String cc = txt[j];
      if ((enc = _encs[cc]) != null){
        out.add(txt.substring(k, j))
          .add('&').add(enc).add(';');
        k = j + 1;
      } else if (multiline && cc == '\n') {
        out.add(txt.substring(k, j)).add("<br/>\n");
        k = j + 1;
      } else if (pre && (cc == ' ' || cc == '\t')) {
        out.add(txt.substring(k, j)).add("&nbsp;");
        if (cc == '\t')
          out.add("&nbsp;&nbsp;&nbsp;");
        k = j + 1;
      }
    }
  } else {
    for (int j = 0; j < tl; ++j)
      if ((enc = _encs[txt[j]]) != null) {
        out.add(txt.substring(k, j))
          .add('&').add(enc).add(';');
        k = j + 1;
      }
  }

  if (k == 0) return txt;
  if (k < tl)
    out.add(txt.substring(k));
  return out.toString();
}
/** Decodes the XML string into a normal string.
 * For example, &amp;lt; is convert to &lt;
 * @param String txt the text to decode
 * @return String the decoded string
 */
String decodeXML(String txt) {
  if (txt == null) return null; //as it is

  final StringBuffer out = new StringBuffer();
  int k = 0, tl = txt.length;
  for (int j = 0; j < tl; ++j) {
    String cc = txt[j];
    if (cc == '&') {
      int l = txt.indexOf(';', j + 1);
      if (l >= 0) {
        String dec = txt[j + 1] == '#' ?
          new String.fromCharCodes(
            txt[j + 2].toLowerCase() == 'x' ?
              Math.parseInt(txt.substring(j + 3, l), 16):
              Math.parseInt(txt.substring(j + 2, l), 10)):
          _decs[txt.substring(j + 1, l)];
        if (dec != null) {
          out.add(txt.substring(k, j)).add(dec);
          k = (j = l) + 1;
        }
      }
    }
  }
  return k == 0 ? txt:
    k < tl ? out.add(txt.substring(k)).toString(): out.toString();
}
