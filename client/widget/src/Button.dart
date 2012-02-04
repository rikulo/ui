//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends Widget {
	String _label;
	String _type = "button";
	bool _disabled = false;

	Button([String label=""]) {
		wclass = "w-button";
		this.label = label;
		
	}

	/** Returns the label.
	 */
	String get label() => this._label;
	/** Sets the label.
	 */
	void set label(String label) {
		this._label = label != null ? label: "";
		_updateInner();
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
		Element n = node;
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
		Element n = node;
		if (n != null)
			n.disabled = _disabled;
	}

	void _updateInner() {
		final Element n = node;
		if (n != null) n.innerHTML = encodeXML(label);
	}
	void redraw_(StringBuffer out, Skipper skipper) {
		out.add('<button type="').add(type).add('"');
		if (disabled)
			out.add(' disabled="disabled"');
		out.add(domAttrs_()).add('>')
			.add(encodeXML(label)).add('</button>');
	}
}
