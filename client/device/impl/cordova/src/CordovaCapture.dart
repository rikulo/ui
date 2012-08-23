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
  List<ConfigurationData> get supportedAudioModes {
    return JSUtil.toDartList(JSUtil.jsCall(_SUPPORTED_AUDIO_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the image formats/size supported by this device */
  List<ConfigurationData> get supportedImageModes {
    return JSUtil.toDartList(JSUtil.jsCall(_SUPPORTED_IMAGE_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the video formats/resolutions suupported by this device */
  List<ConfigurationData> get supportedVideoModes {
    return JSUtil.toDartList(JSUtil.jsCall(_SUPPORTED_VIDEO_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  void captureAudio(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureAudioOptions options]) {
    var jsSuccess = _wrapCaptureSuccess(success);
    var jsError = _wrapCaptureError(error);
    JSUtil.jsCall(_CAPTURE_AUDIO, [jsSuccess, jsError, JSUtil.toJSMap(_audioOptionsToMap(options))]);
  }
  void captureImage(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureImageOptions options]) {
    var jsSuccess = _wrapCaptureSuccess(success);
    var jsError = _wrapCaptureError(error);
    JSUtil.jsCall(_CAPTURE_IMAGE, [jsSuccess, jsError, JSUtil.toJSMap(_imageOptionsToMap(options))]);
  }
  void captureVideo(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureVideoOptions options]) {
    var jsSuccess = _wrapCaptureSuccess(success);
    var jsError = _wrapCaptureError(error);
    JSUtil.jsCall(_CAPTURE_VIDEO, [jsSuccess, jsError, JSUtil.toJSMap(_videoOptionsToMap(options))]);
  }
  _wrapCaptureError(CaptureErrorCallback dartFn) {
    return JSUtil.toJSFunction((jsErr) => dartFn(new CaptureError.from(jsErr)), 1);
  }
  _wrapCaptureSuccess(CaptureSuccessCallback dartFn) {
    return JSUtil.toJSFunction((jsMediaFiles) => dartFn(JSUtil.toDartList(jsMediaFiles, (jsfile) => new CordovaMediaFile.from(jsfile))), 1);
  }
  ConfigurationData _wrapConfigurationData(var jsData) {
    return new ConfigurationData.from(JSUtil.toDartMap(jsData)); 
  }
  Map _audioOptionsToMap(CaptureAudioOptions options) {
    if (options != null) {
      return {
        "limit" : options.limit,
        "duration" : options.duration,
        "mode" : JSUtil.toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _imageOptionsToMap(CaptureImageOptions options) {
    if (options != null) {
      return {
        "limit" : options.limit,
        "mode" : JSUtil.toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _videoOptionsToMap(CaptureVideoOptions options) {
    if (options != null) {
      return {
        "limit" : options.limit,
        "duration" : options.duration,
        "mode" : JSUtil.toJSMap(_configurationDataToMap(options.mode))
      };
    } else { //TODO: default setting?
      return {};
    }
  }
  Map _configurationDataToMap(ConfigurationData data) {
    if (data != null) {
      return {
        "type" : data.type,
        "height": data.height,
        "width" : data.width
      };
    } else {
      return {};
    }
  }
  
  static bool _doneInit = false;
  void _initJSFunctions() {
    if (_doneInit) return;
    
    JSUtil.newJSFunction(_SUPPORTED_AUDIO_MODES, null, "return navigator.device.capture.supportedAudioModes;");
    JSUtil.newJSFunction(_SUPPORTED_IMAGE_MODES, null, "return navigator.device.capture.supportedImageModes;");
    JSUtil.newJSFunction(_SUPPORTED_VIDEO_MODES, null, "return navigator.device.capture.supportedVideoModes;");
    JSUtil.newJSFunction(_CAPTURE_AUDIO, ["onSuccess", "onError", "opts"],
      "navigator.device.capture.captureAudio(onSuccess, onError, opts);");
    JSUtil.newJSFunction(_CAPTURE_IMAGE, ["onSuccess", "onError", "opts"],
      "navigator.device.capture.captureImage(onSuccess, onError, opts);");
    JSUtil.newJSFunction(_CAPTURE_VIDEO, ["onSuccess", "onError", "opts"],
      "navigator.device.capture.captureVideo(onSuccess, onError, opts);");

    _doneInit = true;
  }
}
