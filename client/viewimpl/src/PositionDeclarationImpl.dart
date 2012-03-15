//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 11:15:27 AM
// Author: tomyeh

/**
 * The default implementation of [PositionDeclaration].
 */
class PositionDeclarationImpl extends  DeclarationImpl
implements PositionDeclaration {
  final View _owner;

  PositionDeclarationImpl(View owner) : _owner = owner;

	String get anchor()
		=> getPropertyValue("anchor");
	void set anchor(String value) {
		setProperty("anchor", value);
	}

	String get width()
		=> getPropertyValue("width");
	void set width(String value) {
		setProperty("width", value);
	}

	String get height()
		=> getPropertyValue("height");
	void set height(String value) {
		setProperty("height", value);
	}

	String get minWidth()
		=> getPropertyValue("min-width");
	void set minWidth(String value) {
		setProperty("min-width", value);
	}

	String get minHeight()
		=> getPropertyValue("min-height");
	void set minHeight(String value) {
		setProperty("min-height", value);
	}

	String get maxWidth()
		=> getPropertyValue("max-width");
	void set maxWidth(String value) {
		setProperty("max-width", value);
	}

	String get maxHeight()
		=> getPropertyValue("max-height");
	void set maxHeight(String value) {
		setProperty("max-height", value);
	}
}
