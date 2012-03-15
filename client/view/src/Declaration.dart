//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012 10:56:16 AM
// Author: tomyeh

/**
 * A declaration of properties.
 */
interface Declaration default DeclarationImpl {
	Declaration();

	/** The text representation of the declaration block.
	 * Setting this attribute will reset all properties.
	 */
	String text;
	/** Returns a collection of properties that are assigned with
	 * a non-empty value.
	 */
	Collection<String> getPropertyNames();
	/** Retrieves the property's value.
	 */
	String getPropertyValue(String propertyName);
	/** Removes the property of the given name.
	 */
	String removeProperty(String propertyName);
	/** Sets the value of the given property.
	 * If the given value is null or empty, the property will be removed.
	 */
	void setProperty(String propertyName, String value);
}
