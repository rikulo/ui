//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 16, 2012  02:37:12 PM
// Author: henrichen

//Utilities to convert Date, List, Map between Dart and JavaScript
/** Converts a Dart Date to JavaScript Date
 * @param dartdate the dart Date
 * @return the converted JavaScript Date
 */
toJSDate(Date dartdate) {
  _initJSCall();
  int msecs = dartdate !== null ? dartdate.value : null;
  return msecs != null ? jsCall("newDate", [msecs]) : null;
}

/** Convert a JavaScript Date to Dart Date 
 * @param jsdate the JavaScript Date
 * @return the converted Dart Date
 */
toDartDate(jsdate) {
  _initJSCall();
  int msecs = jsdate !== null ? jsCall("getTime", [jsdate]) : null;
  return msecs !== null ? new Date.fromEpoch(msecs, false) : null; //use local timezone
}
  
/** Convert Dart List to JavaScript array 
 * @param dartlist the dart List
 * @return the converted JavaScript Array
 */
toJSArray(List dartlist, [Function converter = null]) {
  _initJSCall();
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
  _initJSCall();
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
  _initJSCall();
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
  _initJSCall();
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

_JSCallX jsCallX; //bridge class
/** Dart bridge method to call into JavaScript function registered with #newJSFunction.
 * @param name JavaScript function name
 * @param args arguments to be passed into JavaScript function
 * @see #newJSFunction
 */ 
jsCall(String name, [List args = const []]) {
  return jsCallX.exec(name, args);
}

/** Create and register a new JavaScript function; can be called from Dart later via #jsCall function.
 * @param name function name
 * @param args argument names
 * @param body the function definition body
 * @see #jsCall
 */
newJSFunction(String name, List<String> args, String body) {
  _initJSCall();
  jsCall("newFn", [name, args, body]);
}

/** Initialization of the JavaScript utilities; can be called 
 * multiple times but only the first call works.
 */
_initJSCall() {
  if (jsCallX === null) {
    final String newFn = '''  
      var _natives = {
        "newFn" : function(nm, args, body) {
          var fnbody = "return new Function(" + (args && args.length > 0 ? "'"+args.join("','")+"',body);" : "body);"),
              fn = new Function("body", fnbody)(body);
          return (_natives[nm] = fn);  
        },
        "get" : function(obj, attr) {
          return obj[attr];
        },
        "set" : function(obj, attr, val) {
          obj[attr] = val;
        },
        "forEach" : function(jslist, fn) {
          if (jslist) {
            for(var j = 0; j < jslist.length; ++j) {
              fn.\$call\$1(jslist[j]);
            }
          }
        },
        "forEachKey" : function(jsmap, fn) {
          if (jsmap) {
            for(var key in jsmap) {
              fn.\$call\$2(key, jsmap[key]);
            }
          }
        },
        "_newItem" : function(result, item) {
          if (result.length == 0) result[0] = [];
          result[0].push(item);
        },
        "_newEntry" : function(result, k, v) {
          if (result.length == 0) result[0] = {};
          result[0][k] = v;
        },
        "getTime" : function(jsdate) {
          return jsdate ? jsdate.getTime() : null;
        },
        "newDate" : function(msecs) {
          return msecs != null ? new Date(msecs) : null;
        },
        "{}" : function() { //empty map
          return {};
        },
        "[]" : function() { //empty array
          return [];
        }
      };
      if (window.Isolate && window.Isolate.\$isolateProperties) {
        console.log("init _JSCallX");
        window.Isolate.\$isolateProperties._JSCallX.prototype.exec\$2 =  
          function(name, args) {
            if (!_natives[name])
              console.log("Cannot find jsCall:"+name);
            else
              return _natives[name].apply(this, args);
          };
      };
    ''';
    
    injectJavaScript(newFn); //initialize JavaScript function table
    jsCallX = new _JSCallX(); //connect jsCall to JavaScript function table
  }
}

/**
 * Inject JavaScript src file.
 * @param uri the JavaScript file uri
 */
injectJavaScriptSrc(String uri) {
  var s = new ScriptElement();
  s.attributes["type"] = "text/javascript";
  s.attributes["src"] = uri;
  document.head.nodes.add(s);  
}

/**
 * Inject JavaScript code and run directly.
 * @param script the JavaScript codes
 * @param remove whether remove the script after running; default true.
 */  
injectJavaScript(String script, [bool remove = true]) {
  var s = new ScriptElement();
  s.attributes["type"] = "text/javascript";
  s.text = script;
  document.head.nodes.add(s);
  if (remove) s.remove();
}

/**
 * Execute the specified function when the specified ready function returns true. 
 * @param fn the function to be executed
 * @param ready the function to check if it meets some preset condition
 * @param progress the {@link Progress} callback function to report how many time left in milliseconds before timeout (-1 means forever)
 * @param freq the retry frequency in milliseconds
 * @param timeout the timeout time in milliseconds to give up; -1 means forever.  
 */
bool doWhenReady(Function fn, Function ready, Function progress, int freq, int timeout) {
  final int end = timeout < 0 ? timeout : new Date.now().value + timeout;
  _doWhen0(fn, ready, progress, freq, end);
}
/** Progress callback function to show the time left in milliseconds before timeout */
typedef Progress(int msec);

void _doWhen0(Function fn, Function ready, Progress progress, int freq, final int end) {
  window.setTimeout(() {
    if (ready()) {
      fn();
    } else {
      int diff = end - new Date.now().value;
      if (end < 0 || diff > 0) { //still have time to try it
        progress(end < 0 ? -1 : diff); //try again
        _doWhen0(fn, ready, progress, freq, end);
      } else {
        progress(0); //timout. fail!
      }
    }
  }, freq);
}

typedef JSCallFunction(String op, List args);
class _JSCallX {JSCallFunction exec;} //change NEITHER class name NOR field name; couple to JavaScript code