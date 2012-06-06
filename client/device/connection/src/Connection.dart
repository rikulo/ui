//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  04:56:12 PM
// Author: henrichen

/**
 * Network connection information of this device.
 */
interface Connection {
  static final String UNKNOWN = "unknown";
  static final String ETHERNET = "ethernet";
  static final String WIFI = "wifi";
  static final String CELL_2G = "2g";
  static final String CELL_3G = "3g";
  static final String CELL_4G = "4g";
  static final String NONE =  "none";

  /** connection type */
  String type;
}
