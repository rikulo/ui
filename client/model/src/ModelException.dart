//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 10, 2012

/** A model exception.
 */
class ModelException implements Exception {
  final String message;

  const ModelException(String this.message);
  String toString() => "ModelException($message)";
}
