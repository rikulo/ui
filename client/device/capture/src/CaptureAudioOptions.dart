//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

class CaptureAudioOptions {
  /** The maximum number of audio clips the device user can record in a single capture operation; default to 1; */
  int limit = 1;
  /** The maximum duration of an audio sound clip in seconds */
  int duration;
  /** The selected audio mode; must be one of supportedAudioModes in Capture */
  ConfigurationData mode;
  
  CaptureAudioOptions.from(Map opts) : limit = opts["limit"], duration = opts["duration"], mode = opts["mode"];
}
