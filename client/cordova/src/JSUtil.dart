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
	return msecs !== null ? new Date.fromEpoch(msecs, false) : null; //use local timezone
}
	
/** Convert Dart List to JavaScript array 
 * @param dartlist the dart List
 * @return the converted JavaScript Array
 */
toJSArray(List dartlist, [Function converter = null]) {
  if (dartlist !== null) {
    if (dartlist.length == 0) {
      return jsCall("[]"); //return empty JavaScript Array
    }
    if (converter === null) { //tricky! optimize case: if no need to convert each item, compiled Dart List is a JavaScript Array
      return dartlist;
    } else {
      var result = [];
      dartlist.forEach((v) => jsCall("_newItem", [result, converter(v)]));
      return result[0];
    }
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
		if (converter !== null)
		  jsCall("forEach", [jsarray, (v) => result.add(converter(v))]);
		else
		  jsCall("forEach", [jsarray, (v) => result.add(v)]);
		return result;
	}
	return null;
}

/** Convert Dart Map to JavaScript map(prototype) 
 * @param dartmap the Dart Map
 * @return the converted JavaScript map 
 */
toJSMap(Map dartmap, [Function converter = null]) {
	if (dartmap !==  null) {
		if (dartmap.length == 0) {
			return jsCall("{}"); //return empty JavaScript map
		}
		var result = [];
		if (converter !== null)
		  dartmap.forEach((k,v) => jsCall("_newEntry", [result, k, converter(v)]));
		else
		  dartmap.forEach((k,v) => jsCall("_newEntry", [result, k, v]));
		return result[0];
	}
	return null;
}

/** Convert JavaScript map(prototype) to Dart Map 
 * @param jsmap the JavaScript map
 * @return the converted Dart Map
 */
toDartMap(var jsmap, [Function converter = null]) {
	if (jsmap !== null) {
		Map result = new Map();
		if (converter !== null)
		  jsCall("forEachKey", [jsmap, (k,v) => result[k] = converter(v)]);
		else
		  jsCall("forEachKey", [jsmap, (k,v) => result[k] = v]);
		return result;
	}
	return null;
}

_JSCallX jsCallX;  
jsCall(String op, [List args = const []]) {
  return jsCallX.exec(op, args);
}

typedef JSCallFunction(String op, List args);
class _JSCallX {JSCallFunction exec;} //DO NOT change class and field name; couple to JavaScript code
initJSCall() { //bridge jsCallX to javaScript jump table
  if (jsCallX === null) {
    _injectJavaScript("if(window.overrideJSCallX) window.overrideJSCallX();"); //calling JavaScript function
    jsCallX = new _JSCallX();
    if (jsCall("[]") === null) {
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

