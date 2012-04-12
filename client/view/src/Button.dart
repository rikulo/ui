//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends TextView {
	String _type = "button";
	bool _disabled = false, _autofocus = false;

	Button([String text="", String html="", bool disabled=false]):
	super(text, html), _disabled=disabled {
		vclass = "v-Button";
	}

	/** Returns the button type.
	 * <p>Default: "button".
	 */
	String get type() => _type;
	/** Sets the button type.
	 * @param String type either "button", "submit" or "reset".
	 */
	void set type(String type) {
		_type = type == null || type.isEmpty() ? "button": type;
		ButtonElement n = node;
		if (n != null)
			n.type = _type;
	}
	/** Returns whether it is disabled.
	 * <p>Default: false.
	 */
	bool get disabled() => _disabled;
	/** Sets whether it is disabled.
	 */
	void set disabled(bool disabled) {
		_disabled = disabled;
		ButtonElement n = node;
		if (n != null)
			n.disabled = _disabled;
	}

	/** Returns whether this button should automatically get focus.
	 * <p>Default: false.
	 */
	bool get autofocus() => _autofocus;
	/** Sets whether this button should automatically get focus.
	 */
	void set autofocus(bool autofocus) {
		_autofocus = autofocus;
		if (autofocus) {
			ButtonElement n = node;
			if (n != null)
				n.focus();
		}
	}

	void domAttrs_(StringBuffer out,
	[bool noId=false, bool noStyle=false, bool noClass=false]) {
		out.add(' type="').add(type).add('"');
		if (disabled)
			out.add(' disabled="disabled"');
		if (autofocus)
			out.add(' autofocus="autofocus"');
		super.domAttrs_(out, noId, noStyle, noClass);
	}
	/** Returns the HTML tag's name representing this widget.
	 * <p>Default: <code>button</code>.
	 */
	String get domTag_() => "button";

	void insertBefore(View child, View beforeChild) {
		throw const UiException("No child allowed in Button");
	}

	int measureWidth(MeasureContext mctx)
	=> layoutManager.measureWidthByContent(mctx, this);
	int measureHeight(MeasureContext mctx)
	=> layoutManager.measureHeightByContent(mctx, this);

	String toString() => "Button('$text$html')";
}
