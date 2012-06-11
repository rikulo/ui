//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  04:28:09 PM
// Author: henrichen

/**
 * A Cordova capture implementation.
 */
class CordovaCapture implements Capture {
  CordovaCapture() {
    _initJSFunctions();
  }
  /** Returns the audio formats supported by this device */
  List<ConfigurationData> get supportedAudioModes() {
    return toDartList(jsCall("capture.supportedAudioModes"), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the image formats/size supported by this device */
  List<ConfigurationData> get supportedImageModes() {
    return toDartList(jsCall("capture.supportedImageModes"), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the video formats/resolutions suupported by this device */
  List<ConfigurationData> get supportedVideoModes() {
    return toDartList(jsCall("capture.supportedVideoModes"), (jsData) => _wrapConfigurationData(jsData));
  }
  void captureAudio(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureAudioOptions options]) {
    jsCall("capture.captureAudio", [_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), toJSMap(_audioOptionsToMap(options))]);
  }
  void captureImage(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureImageOptions options]) {
    jsCall("capture.captureImage", [_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), toJSMap(_imageOptionsToMap(options))]);
  }
  void captureVideo(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureVideoOptions options]) {
    jsCall("capture.captureVideo", [_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), toJSMap(_videoOptionsToMap(options))]);
  }
  _wrapCaptureError(CaptureErrorCallback dartFn) {
    return (jsErr) => dartFn(new CaptureError.from(jsErr));
  }
  _wrapCaptureSuccess(CaptureSuccessCallback dartFn) {
    return (jsMediaFiles) => dartFn(toDartList(jsMediaFiles, (jsfile) => new CordovaMediaFile.from(jsfile)));
  }
  ConfigurationData _wrapConfigurationData(var jsData) {
    return new ConfigurationData.from(toDartMap(jsData)); 
  }
  Map _audioOptionsToMap(CaptureAudioOptions options) {
    if (options !== null) {
      return {
        "limit" : options.limit,
        "duration" : options.duration,
        "mode" : toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _imageOptionsToMap(CaptureImageOptions options) {
    if (options !== null) {
      return {
        "limit" : options.limit,
        "mode" : toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _videoOptionsToMap(CaptureVideoOptions options) {
    if (options !== null) {
      return {
        "limit" : options.limit,
        "duration" : options.duration,
        "mode" : toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _configurationDataToMap(ConfigurationData data) {
    if (data !== null) {
      return {
        "type" : data.type,
        "height": data.height,
        "width" : data.width
      };
    } else {
      return {};
    }
  }
  
  void _initJSFunctions() {
    newJSFunction("capture.supportedAudioModes", null, "return navigator.device.capture.supportedAudioModes;");
    newJSFunction("capture.supportedImageModes", null, "return navigator.device.capture.supportedImageModes;");
    newJSFunction("capture.supportedVideoModes", null, "return navigator.device.capture.supportedVideoModes;");
    newJSFunction("capture.captureAudio", ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureAudio(fnSuccess, fnError, opts);
    ''');
    newJSFunction("capture.captureImage", ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureImage(fnSuccess, fnError, opts);
    ''');
    newJSFunction("capture.captureVideo", ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureVideo(fnSuccess, fnError, opts);
    ''');
    newJSFunction("MediaFile.getFormatData", ["mediaFile", "onSuccess", "onError"], '''
      var fnSuccess = function(data) {onSuccess.\$call\$1(data);},
          fnError = function() {onError.\$call\$0();};
      mediaFile.getFormatData(fnSuccess, fnError);
    ''');
  }
}
