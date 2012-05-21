//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  05:03:28 PM
// Author: henrichen

/**
 * A Cordova MediaFile implementation.
 */
class CordovaMediaFile implements MediaFile {
	String get name() native "return this._jsFile.name;";
	String get fullPath() native "return this._jsFile.fullPath;";
	String get type() native "return this._jsFile.type;";
	Date get date() => jsDateToDartDate(_getJsDate(_jsFile));
	int get size() native "return this._jsFile.size;";

//	set name(String x) native "this._jsFile.name = x;";
//	set fullPath(String x) native "this._jsFile.fullPath = x;";
//	set type(String x) native "this._jsFile.type = x;";
//	set date(Date date) => _updateJsDate(_jsFile, dartDateToJSDate(date));
//	set size(int x) native "this._jsFile.size = x;";

	_getJsDate(jsFile) native "return jsFile.date;";
//	_updateJsDate(jsFile, var x) native "jsFile.date = x;";
	
	var _jsFile; //associated JavaScript object
	
	CordovaMediaFile.from(var jsFile) {
		this._jsFile = jsFile;
	}
	
	/** Returns format information of this Media file */
	void getFormatData(MediaFileDataSuccessCallback onSuccess, [MediaFileDataErrorCallback onError]) {
		_getFormatData(_jsFile, _wrapDataSuccess(onSuccess), onError);
	}
	
	_wrapDataSuccess(MediaFileDataSuccessCallback onSuccess) {
		reutrn (MediaFileData jsData) => 
			onSuccess(new MediaFileData(jsData.codecs, jsData.bitrate, jsData.height, jsData.width, jsData.duration));
	}
	_getFormatData(jsFile, MediaFileDataSuccessCallback onSuccess, MediaFileDataErrorCallback onError) native
		"jsFile.getFormatData(onSuccess, onError);";
}
