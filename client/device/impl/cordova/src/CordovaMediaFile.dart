//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  05:03:28 PM
// Author: henrichen

/**
 * A Cordova MediaFile implementation.
 */
class CordovaMediaFile implements MediaFile {
  static final String _GET_FORMAT_DATA = "mf.1";
  
  String get name() => jsutil.getJSValue(_jsFile, "name");
  String get fullPath() => jsutil.getJSValue(_jsFile, "fullPath");
  String get type() => jsutil.getJSValue(_jsFile, "type");
  Date get date() => jsutil.toDartDate(jsutil.getJSValue(_jsFile, "lastModifiedDate"));
  int get size() => jsutil.getJSValue(_jsFile, "size");
  
  var _jsFile; //associated JavaScript object
  
  CordovaMediaFile.from(var jsFile) {
    _initJSFunctions();
    this._jsFile = jsFile;
  }
  
  /** Returns format information of this Media file */
  void getFormatData(MediaFileDataSuccessCallback success, [MediaFileDataErrorCallback error]) {
    jsutil.jsCall(_GET_FORMAT_DATA, [_jsFile, _wrapDataSuccess(success), error]);
  }
  
  _wrapDataSuccess(MediaFileDataSuccessCallback dartFn) {
    reutrn (jsData) => dartFn(new MediaFileData.from(jsutil.toDartMap(jsData)));
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (!_doneInit) {
      jsutil.newJSFunction(_GET_FORMAT_DATA, ["mediaFile", "onSuccess", "onError"], '''
        var fnSuccess = function(data) {onSuccess.\$call\$1(data);},
            fnError = function() {onError.\$call\$0();};
        mediaFile.getFormatData(fnSuccess, fnError);
      ''');
      _doneInit = true;
    }
  }
}
