//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, May 21, 2012  03:51:44 PM
// Author: henrichen

typedef MediaFileDataSuccessCallback(MediaFileData data);
typedef MediaFileDataErrorCallback();

/** Midea capture file */
interface MediaFile {
  /** file name without path information */
  String name;
  /** file name with full path information */
  String fullPath;
  /** MIME type of this file */
  String type;
  /** The date/time this file was last modified */
  Date date;
  /** The file size in bytes */
  int size;
  
  /** Returns format information of this Media file */
  void getFormatData(MediaFileDataSuccessCallback success, [MediaFileDataErrorCallback error]);
}

