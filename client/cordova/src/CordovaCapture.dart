//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  04:28:09 PM
// Author: henrichen

/**
 * A Cordova capture implementation.
 */
class CordovaCapture implements Capture {
  static final String _SUPPORTED_AUDIO_MODES = "capture.supportedAudioModes";
  static final String _SUPPORTED_IMAGE_MODES = "capture.supportedImageModes";
  static final String _SUPPORTED_VIDEO_MODES = "capture.supportedVideoModes";
  static final String _CAPTURE_AUDIO = "capture.captureAudio";
  static final String _CAPTURE_IMAGE = "capture.captureImage";
  static final String _CAPTURE_VIDEO = "capture.captureVideo";
  CordovaCapture() {
    _initJSFunctions();
  }
  /** Returns the audio formats supported by this device */
  List<ConfigurationData> get supportedAudioModes() {
    return toDartList(jsCall(_SUPPORTED_AUDIO_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the image formats/size supported by this device */
  List<ConfigurationData> get supportedImageModes() {
    return toDartList(jsCall(_SUPPORTED_IMAGE_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  /** Returns the video formats/resolutions suupported by this device */
  List<ConfigurationData> get supportedVideoModes() {
    return toDartList(jsCall(_SUPPORTED_VIDEO_MODES), (jsData) => _wrapConfigurationData(jsData));
  }
  void captureAudio(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureAudioOptions options]) {
    jsCall(_CAPTURE_AUDIO, [_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), toJSMap(_audioOptionsToMap(options))]);
  }
  void captureImage(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureImageOptions options]) {
    jsCall(_CAPTURE_IMAGE, [_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), toJSMap(_imageOptionsToMap(options))]);
  }
  void captureVideo(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureVideoOptions options]) {
    jsCall(_CAPTURE_VIDEO, [_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), toJSMap(_videoOptionsToMap(options))]);
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
    newJSFunction(_SUPPORTED_AUDIO_MODES, null, "return navigator.device.capture.supportedAudioModes;");
    newJSFunction(_SUPPORTED_IMAGE_MODES, null, "return navigator.device.capture.supportedImageModes;");
    newJSFunction(_SUPPORTED_VIDEO_MODES, null, "return navigator.device.capture.supportedVideoModes;");
    newJSFunction(_CAPTURE_AUDIO, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureAudio(fnSuccess, fnError, opts);
    ''');
    newJSFunction(_CAPTURE_IMAGE, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureImage(fnSuccess, fnError, opts);
    ''');
    newJSFunction(_CAPTURE_VIDEO, ["onSuccess", "onError", "opts"], '''
      var fnSuccess = function(files) {onSuccess.\$call\$1(files);},
          fnError = function(err) {onError.\$call\$1(err);};
      navigator.device.capture.captureVideo(fnSuccess, fnError, opts);
    ''');
  }
}
