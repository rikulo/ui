//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  04:56:12 PM
// Author: henrichen

/**
 * Network connection information of this device.
 */
interface Connection {
  static const String UNKNOWN = "unknown";
  static const String ETHERNET = "ethernet";
  static const String WIFI = "wifi";
  static const String CELL_2G = "2g";
  static const String CELL_3G = "3g";
  static const String CELL_4G = "4g";
  static const String NONE =  "none";

  /** connection type */
  String type;
}
