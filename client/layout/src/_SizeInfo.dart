//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 06, 2012  3:11:20 PM
// Author: tomyeh

/**
 * The size information.
 */
class _SizeInfo {
	static int NONE = 0;
	static int FLEX = 1;
	static int CONTENT = 2;
	static int FIXED = 3;
	static int RATIO = 4;

	num value;
	int type;

	_SizeInfo(String info) {
		if (info == null || (info = info.trim()).isEmpty()) {
			type = NONE;
		} else if (info == "content") {
			type = CONTENT;
		} else if (info.startsWith("flex")) {
			type = FLEX;
			value = info.length > 4 ? Math.parseInt(info.substring(4).trim()): 1;
			if (value < 1) value = 1;
		} else if (info.endsWith("%")) {
			type = RATIO;
			value= Math.parseDouble(info.substring(0, info.length - 1).trim()) / 100;
		} else {
			type = FIXED;
			value = Math.parseDouble(info);
		}
	}
}
