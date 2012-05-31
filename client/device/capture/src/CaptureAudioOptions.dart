//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

interface CaptureAudioOptions default _CaptureAudioOptions {
  /** The maximum number of audio clips the device user can record in a single capture operation; default to 1; */
  int limit = 1;
  /** The maximum duration of an audio sound clip in seconds */
  int duration;
  /** The selected audio mode; must be one of supportedAudioModes in Capture */
  ConfigurationData mode;
  
  CaptureAudioOptions([int limit, int duration, ConfigurationData mode]);
}

class _CaptureAudioOptions implements CaptureAudioOptions {
  /** The maximum number of audio clips the device user can record in a single capture operation; default to 1; */
  int limit = 1;
  /** The maximum duration of an audio sound clip in seconds */
  int duration;
  /** The selected audio mode; must be one of supportedAudioModes in Capture */
  ConfigurationData mode;
  
  _CaptureAudioOptions([int limit = 1, int duration, ConfigurationData mode]) :
    this.limit = limit, this.duration = duration, this.mode = mode;
}
