//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends TextView {
	String _type = "button";
	bool _disabled = false;

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

	void domAttrs_(StringBuffer out,
	[bool noId=false, bool noStyle=false, bool noClass=false]) {
		out.add(' type="').add(type).add('"');
		if (disabled)
			out.add(' disabled="disabled"');
		super.domAttrs_(out, noId, noStyle, noClass);
	}
	/** Returns the HTML tag's name representing this widget.
	 * <p>Default: <code>button</code>.
	 */
	String get domTag_() => "button";

	void insertBefore(View child, View beforeChild) {
		throw const UiException("No child allowed in Button");
	}

	String toString() => "Button('$text'+'$html')";
}
