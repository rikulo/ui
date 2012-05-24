//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends TextView {
	String _type = "button";
	bool _disabled = false, _autoFocus = false;

	Button([String text="", String html=""]):
	super(text, html) {
		vclass = "v-Button";
	}

	/** Returns the button type.
	 * <p>Default: "button".
	 */
	String get type() => _type;
	/** Sets the button type.
	 * <p>[type] can be either "button", "submit" or "reset".
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
	bool get autoFocus() => _autoFocus;
	/** Sets whether this button should automatically get focus.
	 */
	void set autoFocus(bool autoFocus) {
		_autoFocus = autoFocus;
		if (autoFocus) {
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
		if (autoFocus)
			out.add(' autofocus="autofocus"');
		super.domAttrs_(out, noId, noStyle, noClass);
	}
	/** Returns the HTML tag's name representing this widget.
	 * <p>Default: <code>button</code>.
	 */
	String get domTag_() => "button";

	/** Returns whether this view allows any child views.
	 * <p>Default: false.
	 */
	bool isChildable_() => false;

	String toString() => "Button('$text$html')";
}
