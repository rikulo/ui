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
  void captureAudio(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureAudioOptions options]);
  /**
   * Launch camera application to capture image files.
   */
  void captureImage(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureImageOptions options]);
  /**
  * Launch device video recording application to record video clips.
  */
  void captureVideo(CaptureSuccessCallback success, CaptureErrorCallback error, [CaptureVideoOptions options]);
}