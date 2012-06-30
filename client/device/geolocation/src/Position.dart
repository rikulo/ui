//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:18:11 AM
// Author: henrichen

/** Position */
interface Position default _Position {
  final Coordinates coordinates;
  final int timeStamp;

  Position(Coordinates coordinates, int timeStamp);
}
class _Position implements Position {
  final Coordinates coordinates;
  final int timeStamp;

  _Position(Coordinates this.coordinates, int this.timeStamp);
  String toString() => "($timeStamp: $coordinates)";
}
