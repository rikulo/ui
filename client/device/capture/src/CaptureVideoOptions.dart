//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

interface CaptureVideoOptions default _CaptureVideoOptions {
  /** The maximum number of video clips the device user can record in a single capture operation; default to 1; */
  int limit = 1;
  /** The maximum duration of a video clip in seconds */
  int duration;
  /** The selected video mode; must be one of supportedVideoModes in Capture */
  ConfigurationData mode;

  CaptureVideoOptions([int limit, int duration, ConfigurationData mode]);
}

class _CaptureVideoOptions implements CaptureVideoOptions {
  /** The maximum number of video clips the device user can record in a single capture operation; default to 1; */
  int limit = 1;
  /** The maximum duration of a video clip in seconds */
  int duration;
  /** The selected video mode; must be one of supportedVideoModes in Capture */
  ConfigurationData mode;

  _CaptureVideoOptions([int limit = 1, int duration, ConfigurationData mode]) : 
    this.limit = limit, this.duration = duration, this.mode = mode;
}