//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  09:12:33 AM
// Author: henrichen

/**
 * Access to the camera of this device.
 */
typedef CameraSuccessCallback(String imageData);
typedef CameraErrorCallback(String message);

interface Camera {
	/**
	* Takes a photo using the camera or retrieves a photo from the device's album based on the cameraOptoins paremeter. 
	* Returns the image as a base64 encoded String or as the URI of an image file.
	*/
	void getPicture(CameraSuccessCallback onSuccess, CameraErrorCallback onError, [CameraOptions cameraOptions]);
}

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

//destinationType
interface DestinationType {
	/** Returns image as base64 encoded string */
	static final int DATA_URL = 0;
	/** Returns image as file URI */
	static final int FILE_URI = 1;
}

//sourceType
interface PictureSourceType {
	static final int PHOTOLIBRARY = 0;
	static final int CAMERA = 1;
	static final int SAVEDPHOTOALBUM = 2;
}

//encodingType
interface EncodingType {
	static final int JPEG = 0;
	static final int PNG = 1;
}

//mediaType
interface MediaType {
	static final int PICTURE = 0;
	static final int VIDEO = 1;
	static final int ALLMEDIA = 2;
}
