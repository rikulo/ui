//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, May 22, 2012 10:46:08 AM
// Author: tomyeh

/**
 * A text box to get input from the user or to to display text.
 */
class TextBox extends View {
	String _value;
	String _type;

	TextBox([String value="", String type="text"]) {
		vclass = "v-TextBox";
		_value = value;
		_type = type;
	}

	/** Returns the type of data being placed in this text box.
	 */
	String get type() => _type;
	/** Sets the type of data being placed in this text box.
	 * <p>Default: text.
	 * <p>Allowed values:
	 * <ul>
	 * <li>text - plain text</li>
	 * <li>multiline - multiline plain text</li>
	 * <li>password - </li>
	 * <li>number - </li>
	 * <li>range - </li>
	 * <li>date - </li>
	 * <li>url - </li>
	 * <li>tel - </li>
	 * <li>email - </li>
	 */
	void set type(String type) {
		if (_type != type) {
			if (type == null || type.isEmpty())
				throw const UiException("type required");
			final bool rerender = _type == "multiline" || type == "multiline";

			_type = type;

			if (rerender) {
				if (inDocument)
					addToDocument(node, outer: true);
					//we don't use invalidate since the user might modify other properties later
			} else {
				final InputElement n = inputNode;
				if (n !== null)
					n.type = type;
			}
		}
	}
	bool get _multiline() => _type == "multiline";

	/** Returns the value of this text box.
	 */
	String get value() => _value;
	/** Sets the value of this text box.
	 * <p>Default: an empty string.
	 */
	void set value(String value) {
		_value = value;
		final InputElement node = inputNode;
		if (node != null)
			node.value = value;
	}

	/** Returns the INPUT element in this view.
	 */
	InputElement get inputNode() => getNode("inp");

	//@Override
	/** Returns the HTML tag's name representing this view.
	 * <p>Default: <code>input</code> or <code>textarea</code> if [mulitline].
	 */
	String get domTag_() => _multiline ? "textarea": "input";
	//@Override
	/** Returns whether this view allows any child views.
	 * <p>Default: false.
	 */
	bool isChildable_() => false;
	//@Override
	int measureWidth(MeasureContext mctx)
	=> layoutManager.measureWidthByContent(mctx, this, true);
	//@Override
	int measureHeight(MeasureContext mctx)
	=> layoutManager.measureHeightByContent(mctx, this, true);
	//@Override
	String toString() => "TextBox('$value')";
}
