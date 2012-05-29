//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  10:09:12 AM
// Author: henrichen

/**
 * A Cordova camera implementation.
 */
class CordovaCamera implements Camera {
	void getPicture(CameraSuccessCallback onSuccess, CameraErrorCallback onError, [CameraOptions options]) {
		jsCall("camera.getPicture", [onSuccess, onError, toJSMap(_toMap(options))]);
	}
	
	Map _toMap(CameraOptions opts) {
	  if (opts !== null) {
  		return {
  			/** The picture quality(0 ~ 100) */
  			"quality" : opts.quality,
  			/** The picture format(DestinationType) */
  			"destinationType" : opts.destinationType,
  			/** The picture source(PictureSourceType). */
  			"sourceType" : opts.sourceType,
  			/** Whether allows simple editing before selection */
  			"allowEdit" : opts.allowEdit,
  			/** The encoding format(EncodingType) */
  			"encodingType" : opts.encodingType,
  			/** Width in pixels (retain scale ratio) */
  			"targetWidth" : opts.targetWidth,
  			/** Height in pixels (retain scale ratio) */
  			"targetHeight" : opts.targetHeight,
  			/** Media type(MediaType). Only when sourceType == PictureSourceType.PHOTOLIBRARY or sourceType == PictureSourceType.SAVEDPHOTOALBUM */
  			"mediaType" : opts.mediaType,
  			/** Whether rotate the image to correct the orientation */
  			"correctOrientation" : opts.correctOrientation,
  			/** Whether save the image to photo album after capture */
  			"saveToPhotoAlbum" : opts.saveToPhotoAlbum
  		};
  	} else { //TODO: default setting?
  	  return {};
  	}
	}
}
