//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

/**
 * Access to the audio/image/video capture facility of this device.
 */
typedef CaptureSuccessCallback(List<MediaFile> mediaFiles);
typedef CaptureErrorCallback(CaptureError error);

interface Capture {
	/** Returns the audio formats supported by this device */
	List<ConfigurationData> supportedAudioModes;
	/** Returns the image formats/size supported by this device */
	List<ConfigurationData> supportedImageModes;
	/** Returns the video formats/resolutions suupported by this device */
	List<ConfigurationData> supportedVideoModes;
	/**
	* Launch device audio recording application to record audio clips.
	*/
	void captureAudio(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureAudioOptions options]);
	/**
	 * Launch camera application to capture image files.
	 */
	void captureImage(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureImageOptions options]);
	/**
	* Launch device video recording application to record video clips.
	*/	
	void captureVideo(CaptureSuccessCallback onSuccess, CaptureErrorCallback onError, [CaptureVideoOptions options]);
}

class CaptureError {
    static final int CAPTURE_INTERNAL_ERR = 0;
    static final int CAPTURE_APPLICATION_BUSY = 1;
    static final int CAPTURE_INVALID_ARGUMENT = 2;
    static final int CAPTURE_NO_MEDIA_FILES = 3;
    static final int CAPTURE_NOT_SUPPORTED = 20;
	
	final int code; //error code
	
	CaptureError(this.code);
	
	CaptureError.from(Map err) : code = err["code"];
}

class CaptureAudioOptions {
	/** The maximum number of audio clips the device user can record in a single capture operation; default to 1; */
	int limit = 1;
	/** The maximum duration of an audio sound clip in seconds */
	int duration;
	/** The selected audio mode; must be one of supportedAudioModes in Capture */
	ConfigurationData mode;
	
	CaptureAudioOptions.from(Map opts) : limit = opts["limit"], duration = opts["duration"], mode = opts["mode"];
}

class CaptureImageOptions {
	/** The maximum number of images the device user can capture in a single capture operation; default to 1; */
	int limit = 1;
	/** The selected image mode; must be one of supportedImageModes in Capture */
	ConfigurationData mode;
	
	CaptureImageOptions.from(Map opts) : limit = opts["limit"], mode = opts["mode"];
}

class CaptureVideoOptions {
	/** The maximum number of video clips the device user can record in a single capture operation; default to 1; */
	int limit = 1;
	/** The maximum duration of a video clip in seconds */
	int duration;
	/** The selected video mode; must be one of supportedVideoModes in Capture */
	ConfigurationData mode;

  CaptureVideoOptions.from(Map opts) : limit = opts["limit"], duration = opts["duration"], mode = opts["mode"];
}

class ConfigurationData {
	/** MIME types supported by this device.
	 * video/3gpp
	 * video/quicktime
	 * image/jpeg
	 * audio/amr
	 * audio/wav
	 */
	String type;
	/** The height of the image/video in pixels; for sound clip always 0 */
	int height;
	/** the width of the image/video in pixels; for sound clip always 0 */
	int width;
	
	ConfigurationData(this.type, this.height, this.width);
	
	ConfigurationData.from(Map data) : this.type = data["type"], this.height = data["height"], this.width = data["width"];
}
