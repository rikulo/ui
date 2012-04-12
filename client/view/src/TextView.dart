//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 19, 2012 12:10:33 PM
// Author: tomyeh

/**
 * A skeletal implementation for views that support the text and image.
 * <p>Notice that there are two kinds of text: normal text and HTML fragment.
 * You can specify the normal text with [text], and the HTML fragment with [html].
 * If both are specified, [text] will be shown in front of [html].
 */
class TextView extends View {
	String _text, _html;

	TextView([String text="", String html=""]) {
		vclass = "v-TextView";
		_text = text != null ? text: "";
		_html = html != null ? html: "";
		//TODO: support image
	}

	/** Returns the text.
	 */
	String get text() => this._text;
	/** Sets the text.
	 */
	void set text(String text) {
		_text = text != null ? text: "";
		updateInner_();
	}
	/** Returns the HTML text.
	 */
	String get html() => this._html;
	/** Sets the HTML text.
	 */
	void set html(String html) {
		_html = html != null ? html: "";
		updateInner_();
	}

	/** Called to update the DOM element, when the content of this view
	 * is changed.
	 * <p>Default: invoke [innerHTML_] to retrieve the content
	 * and then update [node]'s innerHTML.
	 */
	void updateInner_() {
		final Element n = node;
		if (n != null)
			n.innerHTML = innerHTML_;
	}
	/** Returns the HTML content.
	 * <p>Default: it is the concatenation of [encodedText] and [html].
	 */
	String get innerHTML_() {
		return "$encodedText$html";
	}
	/** Returns the encodes the text ([text]).
	 * <p>Default: it encodes [text] by replacing linefeed with &lt;br/&gt;, if any.
	 */
	String get encodedText() => encodeXML(text, multiline:true);

	/** Outputs the inner content of this widget. It is everything
	 * <p>Default: output [innerHTML_].
	 */
	void domInner_(StringBuffer out) {
		out.add(innerHTML_);
	}

	void insertBefore(View child, View beforeChild) {
		throw const UiException("No child allowed in TextView");
	}

	int measureWidth(MeasureContext mctx)
	=> layoutManager.measureWidthByContent(mctx, this);
	int measureHeight(MeasureContext mctx)
	=> layoutManager.measureHeightByContent(mctx, this);

	String toString() => "TextView('$text$html')";
}
