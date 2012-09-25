//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

interface CaptureImageOptions default _CaptureImageOptions {
  /** The maximum number of images the device user can capture in a single capture operation; default to 1; */
  int limit = 1;
  /** The selected image mode; must be one of supportedImageModes in Capture */
  ConfigurationData mode;
  
  CaptureImageOptions([int limit, ConfigurationData mode]);
}

class _CaptureImageOptions implements CaptureImageOptions {
  /** The maximum number of images the device user can capture in a single capture operation; default to 1; */
  int limit = 1;
  /** The selected image mode; must be one of supportedImageModes in Capture */
  ConfigurationData mode;
  
  _CaptureImageOptions([int limit = 1, ConfigurationData mode]) : 
    this.limit = limit, this.mode = mode;
}