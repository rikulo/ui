//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 16, 2012  02:37:12 PM
// Author: henrichen

//Utilities to convert Date, List, Map between Dart and JavaScript
/** Converts a Dart Date to JavaScript Date
 * @param dartdate the dart Date
 * @return the converted JavaScript Date
 */
toJSDate(Date dartdate) {
	int msecs = dartdate !== null ? dartdate.value : null;
	return msecs != null ? jsCall("new Date", [msecs]) : null;
}

/** Convert a JavaScript Date to Dart Date 
 * @param jsdate the JavaScript Date
 * @return the converted Dart Date
 */
toDartDate(jsdate) {
	int msecs = jsdate !== null ? jsCall("date.getTime", [jsdate]) : null;
	return msecs !== null ? new Date.fromEpoch(msecs, new TimeZone.local()) : null;
}
	
/** Convert Dart List to JavaScript array 
 * @param dartlist the dart List
 * @return the converted JavaScript Array
 */
toJSArray(List dartlist, [Function converter = null]) {
  if (dartlist !== null) {
    if (dartlist.length == 0) {
      return jsCall("[]", []); //return empty JavaScript Array
    }
    if (converter === null) { //optimize case: if no need to convert each item, compiled Dart List is a JavaScript Array
      return dartlist;
    }
    var result = [];
    dartlist.forEach((v) => jsCall("_newItem", [result, converter !== null ? converter(v) : v]));
    return result[0];
  }
	return null;
}

/** Convert JavaScript array to Dart List
 * @param jsarray the JavaScript Array
 * @param converter the converter function that convert the JavaScript Object into Dart Object.
 * @return the converted Dart List
 */
toDartList(var jsarray, [Function converter = null]) {
	if (jsarray !== null) {
		List result = new List();
		jsCall("forEach", [jsarray, (v) => result.add(converter !== null ? converter(v) : v)]);
		return result;
	}
	return null;
}

/** Convert Dart Map to JavaScript map 
 * @param dartmap the Dart Map
 * @return the converted JavaScript map 
 */
toJSMap(Map dartmap, [Function converter = null]) {
	if (dartmap !==  null) {
		if (dartmap.length == 0) {
			return jsCall("{}", []); //return empty JavaScript map
		}
		var result = [];
		dartmap.forEach((k,v) => jsCall("_newEntry", [result,k, converter !== null ? converter(v) : v]));
		return result[0];
	}
	return null;
}

/** Convert JavaScript map to Dart Map 
 * @param jsmap the JavaScript map
 * @return the converted Dart Map
 */
toDartMap(var jsmap, [Function converter = null]) {
	if (jsmap !== null) {
		Map result = new Map();
		jsCall("forEachKey", [jsmap, (k,v) => result[k] = (converter !== null ? converter(v) : v)]);
		return result;
	}
	return null;
}

List<Function> jsCall0 = const []; //DO NOT change the jump table name. Would be used by jsutil.js
initJSCall() { //initialize jump table
  if (jsCall0.length == 0) {
    _injectJavaScript("if(window.initJSCall) window.initJSCall();"); //calling JavaScript function
    if (jsCall0.length == 0) {
      throw const SystemException("jsutil.js must be loaded first");
    }
  }
}

_injectJavaScript(String script) {
  var s = new Element.tag("script");
  s.attributes["type"] = "text/javascript";
  s.text = script;
  document.body.nodes.add(s);
  s.remove();
}

jsCall(String op, [List args = const []]) {
	return jsCall0[0](op, args); //function table
}
