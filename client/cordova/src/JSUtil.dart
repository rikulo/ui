//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 16, 2012  02:37:12 PM
// Author: henrichen

/** Iterate a JavaScript array and execute the specified function for each item.
 * @param jsArray the JavaScript array
 * @param fn the function to be execute for each item in the array; fn(item).
 */
jsForEach(jsArray, fn) native """
	if (jsArray) {
		for(var j = 0; j < jsArray.length; ++j) {
			fn(jsArray[j]);
		}
	}
""";

/** Iterate a JavaScript map and execute the specified function for each entry.
 * @param jsMap the JavaScript map
 * @param fn the function to be execute for each entry in the map; fn(key, value).
 */
jsForEachKey(jsMap, fn) native """
	if (jsMap) {
		for(var key in jsMap) {
			fn(key, jsMap[key]);
		}
	}
""";

/** Convert a JavaScript Date to Dart Date 
 * @param jsDate the JavaScript Date
 * @param timezone a Dart TimeZone
 * @return the converted Dart Date
 */
jsDateToDartDate(jsDate, [TimeZone timezone]) {
	int msecs = jsDate !== null ? _jsGetTime(jsDate) : null;
	return msecs !== null ? new Date.fromEpoch(msecs, timezone === null ? new TimeZone.local() : timezone) : null;
}
//return time in milliseconds of a Javascript date
_jsGetTime(jsDate) native "return jsDate.getTime();"; 
	
