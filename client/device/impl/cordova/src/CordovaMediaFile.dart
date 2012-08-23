//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  05:03:28 PM
// Author: henrichen

/**
 * A Cordova MediaFile implementation.
 */
class CordovaMediaFile implements MediaFile, JSAgent {
  static final String _GET_FORMAT_DATA = "mf.1";
  
  String get name => JSUtil.getJSValue(_jsFile, "name");
  String get fullPath => JSUtil.getJSValue(_jsFile, "fullPath");
  String get type => JSUtil.getJSValue(_jsFile, "type");
  Date get date => JSUtil.toDartDate(JSUtil.getJSValue(_jsFile, "lastModifiedDate"));
  int get size => JSUtil.getJSValue(_jsFile, "size");
  
  var _jsFile; //associated JavaScript object
  
  CordovaMediaFile.from(var jsFile) {
    _initJSFunctions();
    this._jsFile = jsFile;
  }
  
  toJSObject() {
    return _jsFile;
  }
  
  /** Returns format information of this Media file */
  void getFormatData(MediaFileDataSuccessCallback success, [MediaFileDataErrorCallback error]) {
    var jsSuccess = JSUtil.toJSFunction((jsData) => success(new MediaFileData.from(JSUtil.toDartMap(jsData))), 1);
    var jsError = JSUtil.toJSFunction(() {if (error != null) error();}, 0);
    JSUtil.jsCall(_GET_FORMAT_DATA, [_jsFile, jsSuccess, jsError]);
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;

    JSUtil.newJSFunction(_GET_FORMAT_DATA, ["mediaFile", "onSuccess", "onError"],
      "mediaFile.getFormatData(onSuccess, onError);");

    _doneInit = true;
  }
}
