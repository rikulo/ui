//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  05:22:12 PM
// Author: henrichen

class SimulatorAccelerometer extends  AbstractAccelerometer {
	double x = 0, y = 0, z = 0; //TODO: x,y,z are supposed to be changed by simulator
	
	void getCurrentAcceleration(AccelerationEventListener onSuccess, ErrorListener onError) {
		var $onSuccess = onSuccess;
		window.setTimeout(() => $onSuccess(new AccelerationEvent(this, x, y, z, new Date.now().value)), 0);
	}
	
	watchAcceleration(AccelerationEventListener onSuccess, ErrorListener onError, [Map options]) {
		int frequency = options == null ? 3000 : options["frequency"];
		var $onSuccess = onSuccess;
		return window.setInterval(() => $onSuccess(new AccelerationEvent(this, x, y, z, new Date.now().value)), frequency);
	}
	
	void clearWatch(var watchID) {
		window.clearInterval(watchID);
	}
}
