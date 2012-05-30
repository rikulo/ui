//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  09:12:33 AM
// Author: henrichen

class CameraOptions {
  /** The picture quality(0 ~ 100) */
  int quality;
  /** The picture format(DestinationType) */
  int destinationType;
  /** The picture source(PictureSourceType). */
  int sourceType;
  /** Whether allows simple editing before selection */
  bool allowEdit;
  /** The encoding format(EncodingType) */
  int encodingType;
  /** Width in pixels (retain scale ratio) */
  int targetWidth;
  /** Height in pixels (retain scale ratio) */
  int targetHeight;
  /** Media type(MediaType). Only when sourceType == PictureSourceType.PHOTOLIBRARY or sourceType == PictureSourceType.SAVEDPHOTOALBUM */
  int mediaType;
  /** Whether rotate the image to correct the orientation */
  bool correctOrientation;
  /** Whether save the image to photo album after capture */
  bool saveToPhotoAlbum;
}
