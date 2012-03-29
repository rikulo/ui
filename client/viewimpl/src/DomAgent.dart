//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 28, 2012 12:20:15 PM
// Author: tomyeh

/**
 * A DOM agent for providing more information than Element's API.
 */
class DomAgent {
	final Element node;

	DomAgent(this.node) {
	}
	int get offsetWidth() {
		return 150; //TODO: when Dart supports it
	}
	int get offsetHeight() {
		return 30; //TODO: when Dart supports it
	}
}
