//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  05:03:28 PM
// Author: henrichen

/**
 * A Cordova MediaFile implementation.
 */
class CordovaMediaFile implements MediaFile {
  String get name() => jsCall("get", [_jsFile, "name"]);
  String get fullPath() => jsCall("get", [_jsFile, "fullPath"]);
  String get type() => jsCall("get", [_jsFile, "type"]);
  Date get date() => toDartDate(jsCall("get", [_jsFile, "lastModifiedDate"]));
  int get size() => jsCall("get", [_jsFile, "size"]);
  
  var _jsFile; //associated JavaScript object
  
  CordovaMediaFile.from(var jsFile) {
    this._jsFile = jsFile;
  }
  
  /** Returns format information of this Media file */
  void getFormatData(MediaFileDataSuccessCallback onSuccess, [MediaFileDataErrorCallback onError]) {
    jsCall("MediaFile.getFormatData", [_jsFile, _wrapDataSuccess(onSuccess), onError]);
  }
  
  _wrapDataSuccess(MediaFileDataSuccessCallback dartFn) {
    reutrn (jsData) => dartFn(new MediaFileData.from(toDartMap(jsData)));
  }
}
