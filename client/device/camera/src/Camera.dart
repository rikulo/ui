//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 9, 2012  09:12:33 AM
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
  void getPicture(CameraSuccessCallback success, CameraErrorCallback error, [CameraOptions options]);
}
