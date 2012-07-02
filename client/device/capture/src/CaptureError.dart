class CaptureError {
    static final int CAPTURE_INTERNAL_ERR = 0;
    static final int CAPTURE_APPLICATION_BUSY = 1;
    static final int CAPTURE_INVALID_ARGUMENT = 2;
    static final int CAPTURE_NO_MEDIA_FILES = 3;
    static final int CAPTURE_NOT_SUPPORTED = 20;
  
  final int code; //error code
  
  CaptureError(this.code);
  
  CaptureError.from(Map err) : this(err["code"]);
}

