//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 11:16:36 AM
// Author: tomyeh

/**
 * The default implementaion of [Declaration]
 */
class DeclarationImpl implements Declaration {
	final Map<String, String> _props;

	DeclarationImpl(): _props = new Map();

	String get text() {
		throw const UiException("TODO");
	}
	void set text(String text) {
		throw const UiException("TODO");
	}

	/** Returns a collection of properties that are assigned with
	 * a non-empty value.
	 */
	Collection<String> getPropertyNames() {
		return _props.getKeys();
	}
	/** Retrieves the property's value.
	 */
	String getPropertyValue(String propertyName) {
		final String value = _props[propertyName];
		return value !== null ? value: "";
	}
	/** Removes the property of the given name.
	 */
	String removeProperty(String propertyName) {
		_props.remove(propertyName);
	}
	/** Sets the value of the given property.
	 * If the given value is null or empty, the property will be removed.
	 */
	void setProperty(String propertyName, String value) {
		if (value === null || value.isEmpty())
			removeProperty(propertyName);
		else
			_props[propertyName] = value;
	}
}
