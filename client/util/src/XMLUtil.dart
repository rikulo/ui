//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Sep 11, 2012 12:00:59 PM
// Author: tomyeh

/**
 * XML Utilities.
 */
class XMLUtil {
  static final Map<String, String>
    _decs = const {'lt': '<', 'gt': '>', 'amp': '&', 'quot': '"'},
    _encs = const {'<': 'lt', '>': 'gt', '&': 'amp', '"': 'quot'};

  /** Encodes the string to a valid XML string.
   *
   * + [txt] is the text to encode.
   * + [pre] - whether to replace whitespace with &nbsp;
   * + [multiline] - whether to replace linefeed with <br/>
   * + [maxlength] - the maximal allowed length of the text
   */
  static String encode(String txt,
  [bool multiline=false, int maxlength=0, bool pre=false]) {
    if (txt == null) return null; //as it is

    int tl = txt.length;
    multiline = pre || multiline;

    if (!multiline && maxlength > 0 && tl > maxlength) {
      int j = maxlength;
      while (j > 0 && StringUtil.isChar(txt[j - 1], whitespace: true))
        --j;
      return encode("${txt.substring(0, j)}...", pre:pre, multiline:multiline);
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
      for (int j = 0; j < tl; ++j) {
        if ((enc = _encs[txt[j]]) != null) {
          out.add(txt.substring(k, j))
            .add('&').add(enc).add(';');
          k = j + 1;
        }
      }
    }

    if (k == 0) return txt;
    if (k < tl)
      out.add(txt.substring(k));
    return out.toString();
  }

  /** Decodes the XML string into a normal string.
   * For example, `&lt;` is convert to `<`.
   *
   * + [txt] is the text to decode.
   */
  static String decode(String txt) {
    if (txt == null) return null; //as it is

    final StringBuffer out = new StringBuffer();
    int k = 0, tl = txt.length;
    for (int j = 0; j < tl; ++j) {
      if (txt[j] == '&') {
        int l = txt.indexOf(';', j + 1);
        if (l >= 0) {
          String dec = txt[j + 1] == '#' ?
            new String.fromCharCodes(
              [/*TODO: wait until Dart support Hexadecimal parsing
                txt[j + 2].toLowerCase() == 'x' ?
                parseInt(txt.substring(j + 3, l), 16):*/
                parseInt(txt.substring(j + 2, l))]):
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
  /** Returns the inner content of the given element.
   * It is the same as [Element.innerHTML] if the element is part of [document].
   * However, it also works if the given element is parsed from a XML document.
   */
  static String getInner(Element elem) {
    try {
      return elem.innerHTML;
    } catch (e) {
      final sb = new StringBuffer();
      _xmlToStr(sb, elem);
      return sb.toString();
    }
  }
  /** Returns the outer content of the given element.
   * It is the same as [Element.outerHTML] if the element is part of [document].
   * However, it also works if the given element is parsed from a XML document.
   */
  static String getOuter(Element elem) {
    try {
      return elem.outerHTML;
    } catch (e) {
      final sb = new StringBuffer();
      _xmlBeg(sb, elem);
      _xmlToStr(sb, elem);
      _xmlEnd(sb, elem);
      return sb.toString();
    }
  }
  static void _xmlToStr(StringBuffer sb, Element elem) {
    for (Node n in elem.nodes){
      if (n is Element) {
        final e = n as Element;
        _xmlBeg(sb, e);
        _xmlToStr(sb, e);
        _xmlEnd(sb, e);
      } else if (n is Text) {
        sb.add((n as Text).wholeText);
      } else if (n is ProcessingInstruction) {
        final pi = n as ProcessingInstruction;
        sb.add('<?').add(pi.target).add(' ').add(pi.data).add('?>');
      } else if (n is Comment) {
        sb.add('<!--').add((n as Comment).data).add('-->');
      }//ignore unrecogized nodes (such as Entity, Notation...)
    }
  }
  static void _xmlBeg(StringBuffer sb, Element elem) {
    sb.add('<').add(elem.tagName);

    final attrs = elem.attributes;
    for (String key in attrs.getKeys())
      sb.add(' ').add(key).add('="').add(attrs[key]).add('"');

    sb.add('>');
  }
  static void _xmlEnd(StringBuffer sb, Element elem) {
    sb.add('</').add(elem.tagName).add('>');
  }
}
