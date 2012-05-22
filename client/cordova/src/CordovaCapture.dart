//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 21, 2012  04:28:09 PM
// Author: henrichen

/**
 * A Cordova capture implementation.
 */
class CordovaCapture implements Capture {
	void captureAudio(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureAudioOptions options]) {
		_captureAudio(_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), _audioOptionsToJsonString(options));
	}
	void captureImage(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureImageOptions options]) {
		_captureImage(_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), _imageOptionsToJsonString(options));
	}
	void captureVideo(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureVideoOptions options]) {
		_captureVideo(_wrapCaptureSuccess(onSuccess), _wrapCaptureError(onError), _videoOptionsToJsonString(options));
	}
	_wrapCaptureError(CaptureErrorCallback onError) {
		return (CaptureError err) => //Use CaptureError to trick frogc
			onError(new CaptureError(err.code));
	}
	_wrapCaptureSuccess(CaptureSuccessCallback onSuccess) {
		return (jsMediaFiles) => onSuccess(_newMediaFiles(jsMediaFiles));
	}
	List<MediaFile> _newMediaFiles(jsMediaFiles) { //trick frogc
		List<MediaFile> results = new List<MediaFile>();
		jsForEach(jsMediaFiles, (MediaFile jsFile) => 
			results.add(new CordovaMediaFile.from(jsFile)));
		return results;
	}
	String _audioOptionsToJsonString(CaptureAudioOptions options) {
		if (options !== null) {
			StringBuffer sb = new StringBuffer();
			sb.add("{limit:").add(options.limit);
			if (options.duration !== null) {
				sb.add(",duration:").add(options.duration);
			}
			if (options.mode !== null) {
				sb.add(",mode:").add(_configurationDateToJsonString(options.mode));
			}
			sb.add("}");
			return sb.toString();
		} else {
			return null;
		}
	}
	String _imageOptionsToJsonString(CaptureImageOptions options) {
		if (options !== null) {
			StringBuffer sb = new StringBuffer();
			sb.add("{limit:").add(options.limit);
			if (options.mode !== null) {
				sb.add(",mode:").add(_configurationDateToJsonString(options.mode));
			}
			sb.add("}");
			return sb.toString();
		} else {
			return null;
		}
	}
	String _videoOptionsToJsonString(CaptureVideoOptions options) {
		if (options !== null) {
			StringBuffer sb = new StringBuffer();
			sb.add("{limit:").add(options.limit);
			if (options.duration !== null) {
				sb.add(",duration:").add(options.duration);
			}
			if (options.mode !== null) {
				sb.add(",mode:").add(_configurationDateToJsonString(options.mode));
			}
			sb.add("}");
			return sb.toString();
		} else {
			return null;
		}
	}
	String _configurationDateToJsonString(ConfigurationData data) {
		if (data !== null) {
			StringBuffer sb = new StringBuffer();
			sb.add("{type:'").add(data.type).add("'")
				.add(",height:").add(data.height)
				.add(",width:").add(data.width)
				.add("}");
			return sb.toString();
		} else {
			return null;
		}
	}
	_captureAudio(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, String opts) native
		"navigator.device.capture.captureAudio(onSuccess, onError, opts ? JSON.parse(opts) : null);";		
	_captureImage(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, String opts) native
		"navigator.device.capture.captureImage(onSuccess, onError, opts ? JSON.parse(opts) : null);";		
	_captureVideo(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, String opts) native
		"navigator.device.capture.captureVideo(onSuccess, onError, opts ? JSON.parse(opts) : null);";		
}
