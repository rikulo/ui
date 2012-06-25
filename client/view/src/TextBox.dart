//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, May 22, 2012 10:46:08 AM
// Author: tomyeh

/**
 * A text box to get input from the user or to to display text.
 */
class TextBox extends View implements Input<String> {
  String _value;
  String _type;
  String _placeholder = "";
  int _maxLength = -1, _cols = 20, _rows = 2;
  bool _disabled = false, _autofocus = false, _autocomplete = true;

  TextBox([String value, String type]) {
    _value = value !== null ? value: "";
    _type = type !== null ? type: "text";
  }

  //@Override
  String get className() => "TextBox"; //TODO: replace with reflection if Dart supports it

  /** Returns the type of data being placed in this text box.
   */
  String get type() => _type;
  /** Sets the type of data being placed in this text box.
   *
   * Default: text.
   *
   * Allowed values:
   * 
   * + text - plain text
   * + multiline - multiline plain text
   * + password - 
   * + number - 
   * + color - 
   * + range - 
   * + date - 
   * + url - 
   * + tel - 
   * + email - 
   */
  void set type(String type) {
    if (_type != type) {
      if (type == null || type.isEmpty())
        throw const UIException("type required");

      final bool oldMultiline = _multiline;
      _type = type;

      if (inDocument)
        if (oldMultiline != _multiline) { //rerender required
          invalidate(true);
          //immeidate is true, since the user might modify other properties later
        } else {
          final InputElement inp = inputNode; //no need to check _multiline since we need to silent compiler only
          inp.type = type; //Unlike ButtonElement, it is OK to change directly
        }
    }
  }
  /** Returns whether it allows the user to enter multiple lines of text.
   */
  bool get _multiline() => _type == "multiline";

  /** Returns the value of this text box.
   */
  String get value() {
    if (inDocument) {
      final InputElement inp = inputNode;
      return inp.value;
    }
    return _value;
  }
  /** Sets the value of this text box.
   *
   * Default: an empty string.
   */
  void set value(String value) {
    _value = value;
    final InputElement inp = inputNode;
    if (inp != null)
      inp.value = value;
  }

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled() => _disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    _disabled = disabled;
    final InputElement inp = inputNode;
    if (inp != null)
      inp.disabled = _disabled;
  }

  /** Returns whether this input should automatically get focus.
   *
   * Default: false.
   */
  bool get autofocus() => _autofocus;
  /** Sets whether this input should automatically get focus.
   */
  void set autofocus(bool autofocus) {
    _autofocus = autofocus;
    if (autofocus) {
      final InputElement inp = inputNode;
      if (inp != null)
        inp.focus();
    }
  }

  /** Returns whether to predict the value based on ealier typed value.
   * When a user starts to type in,
   * a list of options will be  displayed to fill the box, based on
   * ealier typed values
   *
   * Default: true (enabled).
   */
  bool get autocomplete() => _autocomplete;
  /** Sets whether to predict the value based on ealier typed value.
   */
  void set autocomplete(bool autocomplete) {
    _autocomplete = autocomplete;
    final InputElement inp = inputNode;
    if (inp != null)
      inp.autocomplete = _autocomplete ? "on": "off";
  }

  /** Returns a short hint that describes this text box.
   * The hint is displayed in the text box when it is empty, and
   * disappears when it gets focus.
   *
   * Default: an empty string.
   */
  String get placeholder() => _placeholder;
  /** Returns a short hint that describes this text box.
   *
   * Default: an empty string.
   */
  void set placeholder(String placeholder) {
    _placeholder = placeholder;
    final InputElement inp = inputNode;
    if (inp != null)
      inp.placeholder = _placeholder;
  }

  /** Returns the width of this text box in average character width.
   *
   * Default: 20.
   */
  int get cols() => _cols;
  /** Sets the width of this text box in average character width.
   *
   * Default: 20.
   */
  void set cols(int cols) {
    _cols = cols;
    if (inDocument)
      if (_multiline) {
        final TextAreaElement inp = inputNode;
        inp.cols = _cols;
      } else {
        final InputElement inp = inputNode;
        inp.size = _cols;
      }
  }
  /** Returns the height of this text box in number of lines.
   *
   * Default: 2.
   *
   * Notice that it is meaningful only if [type] is "multiline".
   */
  int get rows() => _rows;
  /** Sets the height of this text box in number of lines.
   *
   * Default: 2.
   *
   * Notice that it is meaningful only if [type] is "multiline".
   */
  void set rows(int rows) {
    _rows = rows;
    if (_multiline) {
      final TextAreaElement inp = inputNode;
      if (inp != null)
        inp.rows = _rows;
    }
  }

  /** Returns the maximal allowed number of characters.
   *
   * Default: -1 (no limitation).
   */
  int get maxLength() => _maxLength;
  /** Sets the maximal allowed number of characters.
   *
   * Default: 0 (no limitation).
   */
  void set maxLength(int maxLength) {
    _maxLength = maxLength;
    final InputElement inp = inputNode;
    if (inp != null)
      inp.maxLength = _maxLength;
  }

  /** Returns the INPUT element in this view.
   * It could be an instance of InputElement or TextArea
   */
  Element get inputNode() => node;

  //@Override
  void exitDocument_() {
    final InputElement inp = inputNode;
    _value = inp.value; //store back

    super.exitDocument_();
  }
  //@Override
  DOMEventDispatcher getDOMEventDispatcher_(String type)
  => type == "change" ? _getChangeDispatcher(): getDOMEventDispatcher_(type);
  static DOMEventDispatcher _getChangeDispatcher() {
    if (_changeDispatcher === null)
      _changeDispatcher = (View target) => (event) {
        final TextBox t = target;
        t.sendEvent(new ChangeEvent<String>(t, t.value));
      };
    return _changeDispatcher;
  }
  static DOMEventDispatcher _changeDispatcher;

  //@Override
  /** Returns the HTML tag's name representing this view.
   *
   * Default: `input` or `textarea` if [mulitline].
   */
  String get domTag_() => _multiline ? "textarea": "input";
  //@Override
  void domInner_(StringBuffer out) {
    if (_multiline)
      out.add(StringUtil.encodeXML(value));
  }
  //@Override
  void domAttrs_(StringBuffer out,
  [bool noId=false, bool noStyle=false, bool noClass=false]) {
    if (!_multiline) {
      out.add(' type="').add(type).add('"');
      if (!value.isEmpty())
        out.add(' value="').add(StringUtil.encodeXML(value)).add('"');
      if (rows != 2)
        out.add(' rows="').add(rows).add('"');
    }
    if (cols != 2)
      out.add(' cols="').add(cols).add('"');
    if (disabled)
      out.add(' disabled="disabled"');
    if (autofocus)
      out.add(' autofocus="autofocus"');
    if (!autocomplete)
      out.add(' autocomplete="off"');
    if (maxLength > 0)
      out.add(' maxlength="').add(maxLength).add('"');
    if (!placeholder.isEmpty())
      out.add(' placeholder="').add(StringUtil.encodeXML(placeholder)).add('"');
    super.domAttrs_(out, noId, noStyle, noClass);
  }
  //@Override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isViewGroup() => false;
  //@Override
  String toString() => "$className('$value')";
}
