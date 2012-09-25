//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 16, 2012  02:37:12 PM
// Author: henrichen

/**
 * A Dart Object that represent a JavaScript Object.
 */
interface JSAgent {
  /** Returns the peer JavaScriptObject.
   */
  toJSObject();
}

/**
 * Utilities to convert Date, List, Map between Dart and JavaScript.
 */
class JSUtil {
  /** Converts a Dart Date to JavaScript Date
   * + [dartdate] the dart Date
   */
  static toJSDate(Date dartdate) {
    int msecs = dartdate != null ? dartdate.millisecondsSinceEpoch : null;
    return msecs != null ? jsCall("newDate", [msecs]) : null;
  }
  
  /** Convert a JavaScript Date to Dart Date 
   * + [jsdate] the JavaScript Date
   */
  static Date toDartDate(jsdate) {
    int msecs = jsdate != null ? jsCall("getTime", [jsdate]) : null;
    return msecs != null ? new Date.fromMillisecondsSinceEpoch(msecs, false) : null; //use local timezone
  }
    
  /** Convert Dart List to JavaScript array 
   * + [dartlist] the dart List
   */
  static toJSArray(List dartlist, [Function converter = null]) {
    if (dartlist != null) {
      if (dartlist.length == 0) {
        return jsCall("[]"); //return empty JavaScript Array
      }
      if (converter == null) { //tricky! optimize case: if no need to convert each item, compiled Dart List is a JavaScript Array
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
   * + [jsarray] the JavaScript Array
   * + [converter] the converter function that convert the JavaScript Object into Dart Object.
   */
  static List toDartList(var jsarray, [Function converter = null]) {
    if (jsarray != null) {
      List result = new List();
      if (converter != null)
        jsCall("forEach", [jsarray, toJSFunction((v) => result.add(converter(v)), 1)]);
      else
        jsCall("forEach", [jsarray, toJSFunction((v) => result.add(v), 1)]);
      return result;
    }
    return null;
  }
  
  /** Convert Dart Map to JavaScript map(prototype) 
   * + [dartmap] the Dart Map
   */
  static toJSMap(Map dartmap, [Function converter = null]) {
    if (dartmap !==  null) {
      if (dartmap.length == 0) {
        return jsCall("{}"); //return empty JavaScript map
      }
      var result = [];
      if (converter != null)
        dartmap.forEach((k,v) => jsCall("_newEntry", [result, k, converter(k,v)]));
      else
        dartmap.forEach((k,v) => jsCall("_newEntry", [result, k, v]));
      return result[0];
    }
    return null;
  }
  
  /** Convert JavaScript map(prototype) to Dart Map 
   * + [jsmap] the JavaScript map
   */
  static Map toDartMap(var jsmap, [Function converter = null]) {
    if (jsmap != null) {
      Map result = new Map();
      if (converter != null)
        jsCall("forEachKey", [jsmap, toJSFunction((k,v) => result[k] = converter(k,v), 2)]);
      else
        jsCall("forEachKey", [jsmap, toJSFunction((k,v) => result[k] = v, 2)]);
      return result;
    }
    return null;
  }
  
  /** Convert Dart object to its peer JS object.
   */
  static toJSAgent(var v) => v is JSAgent ? v.toJSObject(): v;

  /** Convert an JavaScript XMLDocument to Dart Map/List tree structure.
   * + [xmldoc] the JavaScript XMLDocument
   */
  static xmlDocToDartMap(var xmldoc)
  => jsCall("_elmToDart", [getJSValue(xmldoc, "documentElement"), toJSFunction(toDartMap, 2), 
      (k,v) => jsCall("toType", [v]) == 'array' ? toDartList(v) : v]);
  
  /** Returns the value of the JavaScript object's attribute.
   * + [jsObj] JavaScript object
   * + [attr] attribute name
   */
  static getJSValue(jsObj, String attr) => jsCall("get", [jsObj, attr]);
  
  /** Sets the value of the JavaScript object's attribute.
   * + [jsObj] JavaScript object
   * + [attr] attribute name
   * + [param] value the value
   */
  static void setJSValue(jsObj, String attr, val) {
    jsCall("set", [jsObj, attr, val]);
  }
  
  /** Dart bridge method to call into JavaScript function registered with [newJSFunction].
   * + [name] JavaScript function name
   * + [args] arguments to be passed into JavaScript function
   * See [newJSFunction].
   */ 
  static jsCall(String name, [List args = const []])
  => _jsCallX.exec(name, args);

  /** Create and register a new JavaScript function; can be called from Dart later via [jsCall] function.
   * + [name] function name
   * + [args] argument names
   * + [body] the function definition body
   * See [jsCall]
   */
  static newJSFunction(String name, List<String> args, String body) 
  => jsCall("newFn", [name, args, body]);
  
  /** Register a JavaScript function so it can be called from Dart later via [jsCall] function.
   * + [name] function name
   * + [jsfn] the JavaScript function
   */
  static addJSFunction(String name, var jsfn) 
  => jsCall("addFn", [name, jsfn]);
  
  /** Remove the registered JavaScript function.
   * + [name] function name
   */ 
  static void rmJSFunction(String name) {
    jsCall("rmFn", [name]);
  }
  
  /** Return a bridge JavaScript function of the specified Dart function.
   * + [dartFn] - the Dart function
   * + [argnum] - number of arguments passed to the Dart function
   */
  static toJSFunction(Function dartFn, int argnum) {
    String nm = "toJSFn${argnum}";
    bool exists = jsCall("_existFn", [nm]);
    if (!exists) {
      // if argnum == 0, e.g. "toJSFn0" : function(dartFn) {return function(){return dartFn.\$call\$0();};}
      // if argnum == 1, e.g. "toJSFn1" : function(dartFn) {return function(arg0){return dartFn.\$call\$1(arg0);};}
      // if argnum == 2, e.g. "toJSFn2" : function(dartFn) {return function(arg0,arg1){return dartFn.\$call\$2(arg0,arg1);};}
      List<String> args = new List<String>(argnum);
      for(int j = 0; j < argnum; ++j)
        args[j] = "arg${j}";
      String argseq = Strings.join(args, ",");
      String body = "return function(${argseq}){return dartFn.\$call\$${argnum}(${argseq});};";
      //log("nm:${nm}, body:${body}");
      newJSFunction(nm, ["dartFn"], body);
    }
    return jsCall(nm, [dartFn]);
  }
    
  /** Initialization of the [jsCall] function; must be called at least once before using [jsCall] method. 
   */
  static _JSCallX get _jsCallX {
    if (_$jsCallX == null) {
      final String newFn = '''  
        var _natives = {
          "newFn" : function(nm, args, body) {
            var fnbody = "return new Function(" + (args && args.length > 0 ? "'"+args.join("','")+"',body);" : "body);"),
                fn = new Function("body", fnbody)(body);
            return (_natives[nm] = fn);  
          },
          "addFn" : function(nm, fn) {
            _natives[nm] = fn;
          },
          "rmFn" : function(nm) {
            delete _natives[nm];
          },
          "_existFn" : function(nm) {
            return !!_natives[nm];
          },
          "_fetchFn" : function(nm) {
            return _natives[nm];
          },
          "get" : function(obj, attr) {
            return obj[attr];
          },
          "set" : function(obj, attr, val) {
            obj[attr] = val;
          },
          "forEach" : function(jslist, jsfn) {
            if (jslist) {
              for(var j = 0; j < jslist.length; ++j) {
                jsfn(jslist[j]);
              }
            }
          },
          "forEachKey" : function(jsmap, jsfn) {
            if (jsmap) {
              for(var key in jsmap) {
                jsfn(key, jsmap[key]);
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
          },
          "toType" : function(jsobj) { //check JavaScript object type
            return ({}).toString.call(jsobj).match(/\\s([a-zA-Z]+)/)[1].toLowerCase();
          },
          "_elmToDart" : function(elm, jstoDartMap, mapConverter) { //convert an JS Element to Dart Map/String 
            var jsmap = {},
              attrs = elm.attributes,
              count = 0;
            for(var kid = elm.firstElementChild; kid; kid = kid.nextElementSibling, ++count) {
              _natives._putmap(jsmap, kid.tagName, _natives._elmToDart(kid, jstoDartMap, mapConverter)); //recursive 
            }
            for(var j= attrs.length; j-- > 0; ++count) {
              var attr = attrs[j];
              _natives._putmap(jsmap, attr.nodeName, attr.nodeValue);  
            }
            return count > 0 ? jstoDartMap(jsmap, mapConverter) : elm.textContent;
          },
          "_putmap" :  function(jsmap, nm, val) {
            var old = jsmap[nm];
            if (old) {
              if (_natives.toType(old) == "array") { //same name, use the array
                old.push(val);
              } else { //not array
                var ary = [old, val];
                jsmap[nm] = ary;
              }
            } else {
              jsmap[nm] = val;
            }
          }
        };
        if (window.Isolate && window.Isolate.\$isolateProperties) {
          window.Isolate.\$isolateProperties._JSCallX.prototype.exec\$2 =  
            function(name, args) {
              if (!_natives[name])
                console.log("Cannot find jsCall:"+name);
              else
                return _natives[name].apply(this, args);
            };
        };
      ''';
      
      injectJavaScript(newFn, false); //initialize JavaScript function table
      _$jsCallX = new _JSCallX(); //connect jsCall to JavaScript function table
    }
    return _$jsCallX;
  }
  static _JSCallX _$jsCallX; //bridge class from Dart to JavaScript

  /**
   * Inject JavaScript src file.
   * + [uri] the JavaScript file uri
   */
  static void injectJavaScriptSrc(String uri) {
    var s = new ScriptElement();
    s.type = "text/javascript";
    s.charset = "utf-8";
    s.src = uri;
    document.head.nodes.add(s);  
  }

  /**
   * Remove <Script> element with the specified [uri].
   * + [uri] the JavaScript file uri
   */
  static void removeJavaScriptSrc(String uri) {
    ScriptElement elm = query("script[src='${uri}']");
    if (elm != null)
      elm.remove();
  }
  
  /**
   * Inject JavaScript code and run directly.
   * + [script] the JavaScript codes
   * + [remove] whether remove the script after running; default true.
   */  
  static void injectJavaScript(String script, [bool remove = true]) {
    var s = new ScriptElement();
    s.type = "text/javascript";
    s.charset = "utf-8";
    s.text = script;
    document.head.nodes.add(s);
    if (remove) s.remove();
  }

  /**
   * Execute the specified function when the specified ready function returns true. 
   *
   * + [fn] the function to be executed when ready
   * + [ready] the function to check if it meets some preset condition
   * + [progress] the {@link Progress} callback function to report how many time left in milliseconds before timeout (-1 means forever)
   * + [freq] the retry frequency in milliseconds
   * + [timeout] the timeout time in milliseconds to give up; -1 means forever.  
   */
  static void doWhenReady(Function fn, Function ready, Function progress, int freq, int timeout) {
    final int end = timeout < 0 ? timeout : new Date.now().millisecondsSinceEpoch + timeout;
    _doWhen0(fn, ready, progress, freq, end);
  }
  static void _doWhen0(Function fn, Function ready, Function progress, int freq, final int end) {
    window.setTimeout(() {
      if (ready()) {
        if (fn != null) fn();
      } else {
        int diff = end - new Date.now().millisecondsSinceEpoch;
        if (end < 0 || diff > 0) { //still have time to try it
          if (progress != null) progress(end < 0 ? -1 : diff); 
          _doWhen0(fn, ready, progress, freq, end); //try again
        } else {
          if (progress != null) progress(0); //timout. fail!
        }
      }
    }, freq);
  }
}

typedef _JSCallFunction(String op, List args);
class _JSCallX {_JSCallFunction exec;} //change NEITHER class name NOR field name; couple to JavaScript code
