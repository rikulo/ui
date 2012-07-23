//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  09:12:33 AM
// Author: henrichen

interface CameraOptions default _CameraOptions {
  /** The picture quality(0 ~ 100) */
  int quality;
  /** The picture format(see [DestinationType]) */
  int destinationType;
  /** The picture source(see [PictureSourceType]). */
  int sourceType;
  /** Whether allows simple editing before selection */
  bool allowEdit;
  /** The encoding format(EncodingType) */
  int encodingType;
  /** Width in pixels (retain scale ratio) */
  int targetWidth;
  /** Height in pixels (retain scale ratio) */
  int targetHeight;
  /** Media type(see [MediaType]). This field is meaningful only when
   * sourceType == [PictureSourceType.PHOTOLIBRARY] or
   * sourceType == [PictureSourceType.SAVEDPHOTOALBUM].
   */
  int mediaType;
  /** Whether rotate the image to correct the orientation */
  bool correctOrientation;
  /** Whether save the image to photo album after capture */
  bool saveToPhotoAlbum;

  CameraOptions([int quality,
      int destinationType,
      int sourceType,
      bool allowEdit,
      int encodingType,
      int targetWidth,
      int targetHeight,
      int mediaType,
      bool correctOrientation,
      bool saveToPhotoAlbum]);
}

class _CameraOptions implements CameraOptions {
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

  _CameraOptions([
      int quality = 100,
      int destinationType = DestinationType.FILE_URI,
      int sourceType = PictureSourceType.CAMERA,
      bool allowEdit,
      int encodingType,
      int targetWidth,
      int targetHeight,
      int mediaType,
      bool correctOrientation,
      bool saveToPhotoAlbum]) :
        this.quality = quality, this.destinationType = destinationType, this.sourceType = sourceType,
        this.allowEdit = allowEdit, this.encodingType = encodingType, this.targetWidth = targetWidth,
        this.targetHeight = targetHeight, this.mediaType = mediaType,
        this.correctOrientation = correctOrientation, this.saveToPhotoAlbum = saveToPhotoAlbum;
}
