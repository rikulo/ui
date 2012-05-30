//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

class CaptureVideoOptions {
  /** The maximum number of video clips the device user can record in a single capture operation; default to 1; */
  int limit = 1;
  /** The maximum duration of a video clip in seconds */
  int duration;
  /** The selected video mode; must be one of supportedVideoModes in Capture */
  ConfigurationData mode;

  CaptureVideoOptions.from(Map opts) : limit = opts["limit"], duration = opts["duration"], mode = opts["mode"];
}