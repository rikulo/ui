//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 06, 2012  3:11:20 PM
// Author: tomyeh

/**
 * The amount information.
 * <p>Format: <code>#n | content | flex | flex #n | #n %</code>
 */
class _AmountInfo {
	static int NONE = 0;
	static int FIXED = 1;
	static int FLEX = 2;
	static int RATIO = 3;
	static int CONTENT = 4;

	num value;
	int type;

	_AmountInfo(String profile) {
		if (profile == null || (profile = profile.trim()).isEmpty()) {
			type = NONE;
		} else if (profile == "content") {
			type = CONTENT;
		} else if (profile.startsWith("flex")) {
			type = FLEX;
			value = profile.length > 4 ? Math.parseInt(profile.substring(4).trim()): 1;
			if (value < 1) value = 1;
		} else if (profile.endsWith("%")) {
			type = RATIO;
			value= Math.parseDouble(profile.substring(0, profile.length - 1).trim()) / 100;
		} else {
			type = FIXED;
			value = Math.parseInt(profile);
		}
	}
}
