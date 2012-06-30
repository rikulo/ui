//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  04:28:09 PM
// Author: henrichen

/**
 * A Cordova capture implementation.
 */
class CordovaCapture implements Capture {
  static final String _SUPPORTED_AUDIO_MODES = "capt.1";
  static final String _SUPPORTED_IMAGE_MODES = "capt.2";
  static final String _SUPPORTED_VIDEO_MODES = "capt.3";
  static final String _CAPTURE_AUDIO = "capt.4";
  static final String _CAPTURE_IMAGE = "capt.5";
  static final String _CAPTURE_VIDEO = "capt.6";
  CordovaCapture() {
    _initJSFunctions();
  }
  /** Returns the audio formats supported by this device */
  List<ConfigurationData> get supportedAudioModes() {
    return jsutil.toDartList(jsutil.jsCall(_SUPPORTED_AUDIO_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the image formats/size supported by this device */
  List<ConfigurationData> get supportedImageModes() {
    return jsutil.toDartList(jsutil.jsCall(_SUPPORTED_IMAGE_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the video formats/resolutions suupported by this device */
  List<ConfigurationData> get supportedVideoModes() {
    return jsutil.toDartList(jsutil.jsCall(_SUPPORTED_VIDEO_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  void captureAudio(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureAudioOptions options]) {
    jsutil.jsCall(_CAPTURE_AUDIO, [_wrapCaptureSuccess(success), _wrapCaptureError(error), jsutil.toJSMap(_audioOptionsToMap(options))]);
  }
  void captureImage(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureImageOptions options]) {
    jsutil.jsCall(_CAPTURE_IMAGE, [_wrapCaptureSuccess(success), _wrapCaptureError(error), jsutil.toJSMap(_imageOptionsToMap(options))]);
  }
  void captureVideo(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureVideoOptions options]) {
    jsutil.jsCall(_CAPTURE_VIDEO, [_wrapCaptureSuccess(success), _wrapCaptureError(error), jsutil.toJSMap(_videoOptionsToMap(options))]);
  }
  _wrapCaptureError(CaptureErrorCallback dartFn) {
    return (jsErr) => dartFn(new CaptureError.from(jsErr));
  }
  _wrapCaptureSuccess(CaptureSuccessCallback dartFn) {
    return (jsMediaFiles) => dartFn(jsutil.toDartList(jsMediaFiles, (jsfile) => new CordovaMediaFile.from(jsfile)));
  }
  ConfigurationData _wrapConfigurationData(var jsData) {
    return new ConfigurationData.from(jsutil.toDartMap(jsData)); 
  }
  Map _audioOptionsToMap(CaptureAudioOptions options) {
    if (options !== null) {
      return {
        "limit" : options.limit,
        "duration" : options.duration,
        "mode" : jsutil.toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _imageOptionsToMap(CaptureImageOptions options) {
    if (options !== null) {
      return {
        "limit" : options.limit,
        "mode" : jsutil.toJSMap(_configurationDataToMap(options.mode))
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
        "mode" : jsutil.toJSMap(_configurationDataToMap(options.mode))
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
    jsutil.newJSFunction(_SUPPORTED_AUDIO_MODES, null, "return navigator.device.capture.supportedAudioModes;");
    jsutil.newJSFunction(_SUPPORTED_IMAGE_MODES, null, "return navigator.device.capture.supportedImageModes;");
    jsutil.newJSFunction(_SUPPORTED_VIDEO_MODES, null, "return navigator.device.capture.supportedVideoModes;");
    jsutil.newJSFunction(_CAPTURE_AUDIO, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureAudio(fnSuccess, fnError, opts);
    ''');
    jsutil.newJSFunction(_CAPTURE_IMAGE, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureImage(fnSuccess, fnError, opts);
    ''');
    jsutil.newJSFunction(_CAPTURE_VIDEO, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureVideo(fnSuccess, fnError, opts);
    ''');
  }
}
