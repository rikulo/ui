//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  02:44:12 PM
// Author: henrichen

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
  
  ConfigurationData.from(Map data) : this(data["type"], data["height"], data["width"]);
}