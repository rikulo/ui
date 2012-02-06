//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A label.
 */
class Label extends Widget {
	String _value;
	int _maxlength = 0;
	bool _pre = false, _multiline = false;

	Label([String value=""]) {
		wclass = "w-label";
		this.value = value;
	}

	/** Returns the value of this label.
	 */
	String get value() => _value;
	/** Sets the value of this label.
	 */
	void set value(String value) {
		_value = value != null ? value: "";
		_updateInner();
	}
	/** Returns the value in the encoded format, such as converting &lt; to &amp;lt;
	 */
	String get encodedText() {
		return encodeXML(value, pre:pre, multiline:multiline, maxlength:maxlength);
	}

	/** Returns whether to preserve the new line and the white spaces at the
	 * begining of each line.
	 */
	bool get multiline() => _multiline;
	/** Sets whether to preserve the new line and the white spaces at the
	 * begining of each line.
	 */
	void set multiline(bool multiline) {
		_multiline = multiline;
		_updateInner();
	}
	/** Returns whether to preserve the white spaces, such as space,
	 * tab and new line.
	 *
	 * <p>It is the same as style="white-space:pre". However, IE has a bug when
	 * handling such style if the content is updated dynamically.
	 * Refer to Bug 1455584.
	 *
	 * <p>Note: the new line is preserved either {@link #isPre} or
	 * {@link #isMultiline} returns true.
	 * In other words, <code>pre</code> implies <code>multiline</code>
	 */
	bool get pre() => _pre;
	/** Sets whether to preserve the white spaces, such as space,
	 * tab and new line.
	 */
	void set pre(bool pre) {
		_pre = pre;
		_updateInner();
	}
	/** Returns the maximal length of the label.
	 * <p>Default: 0 (means no limitation)
	 */
	int get maxlength() => _maxlength;
	/** Sets the maximal length of the label.
	 */
	void set maxlength(int maxlength) {
		_maxlength = maxlength;
		_updateInner();
	}
	void _updateInner() {
		final Element n = node;
		if (n != null) n.innerHTML = encodedText;
	}

	void redraw_(StringBuffer out, Skipper skipper) {
		out.add('<span').add(domAttrs_()).add('>')
			.add(encodedText).add('</span>');
	}
}
