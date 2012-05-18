//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  09:18:11 AM
// Author: henrichen

/** Position */
class Position {
	final XCoordinates coords;
	final int timestamp;
	Position(this.coords, this.timestamp);
}

/** Coordinates */
class XCoordinates {
	/** Latitude in decimal degrees. */
	double latitude;
	/** Longitude in decimal degrees. */
	double longitude;
	/** Height of the position in meters above the ellipsoid. */
	double altitude;
	/** Accuracy level of the latitude and longitude in meters. */
	double accuracy;
	/** Accuracy level of altitude in meters. */
	double altitudeAccuracy;
	/** Direction of travel in degrees to true north (north is 0 degree, east is 90 degree, south is 180 degree, west is 270 degree) */
	double heading;
	/** Ground speed in meters per second */
	double speed;
	
	XCoordinates(this.latitude, this.longitude, this.altitude, 
		this.accuracy, this.altitudeAccuracy, this.heading, this.speed);
}
