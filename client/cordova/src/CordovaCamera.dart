//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  09:12:33 AM
// Author: henrichen

/**
 * A Cordova camera implementation.
 */
class CordovaCamera implements Camera {
	void getPicture(CameraSuccessCallback onSuccess, CameraErrorCallback onError, [CameraOptions cameraOptions]) {
		String opts = cameraOptions == null ? null : JSON.stringify(_toMap(cameraOptions));
		_getPicture(onSuccess, onError, opts);
	}
	
	Map _toMap(CameraOptions opts) {
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
			"saveToPhotoAlbum" : opts.saveToPhotoAlbum};
	}
	void _getPicture(CameraSuccessCallback onSuccess, CameraErrorCallback onError, String opts) native
		"navigator.camera.getPicture(onSuccess, onError, opts ? JSON.parse(opts) : null);";
}
