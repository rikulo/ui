//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 4, 2012  04:45:33 PM
// Author: henrichen

/*abstract*/ class AbstractAccelerometer implements Accelerometer {
	AccelerationEvents _on;
	List<_WatchIDInfo> _listeners;
	
	AbstractAccelerometer() {
		_listeners = new List<_WatchIDInfo>();
	}

	AccelerationEvents get on() {
		if (_on === null)
		  _on = new AccelerationEvents(this);
		return _on;
	}

	void addEventListener(String type, AccelerationEventListener listener, [Map options]) {
print("AbstractAccelerometer.addEventListener(): type:"+type);	
		removeEventListener(type, listener);
print("AbstractAccelerometer.after removeEventListener: type:"+type);	
		var watchID = watchAcceleration(listener, () => print("onAccelerationError"), options);
		_listeners.add(new _WatchIDInfo(listener, watchID));
	}
	
	void removeEventListener(String type, AccelerationEventListener listener) {
print("AbstractAccelerometer.removeEventListener: type:"+type);
		for(int j = 0; j < _listeners.length; ++j) {
		  print("AbstractAccelerometer.removeEventListener: j:"+j);        
			if (_listeners[j]._listener == listener) {
				var watchID = _listeners[j]._watchID;
				if (watchID !== null) {
print("AbstractAccelerometer.removeEventListener: watchID:"+watchID);				
				  clearWatch(watchID);
				}
				break;
			}
		}

print("AbstractAccelerometer.removeEventListener: LEAVE! type:"+type);       
		
	}
	
	bool dispatchEvent(AccelerationEvent event, [String type]) {
		//ignore
	}
	
	bool isEventListened(String type) {
		return _listeners.isEmpty();
	}
	
	/**
	* Returns the motion Acceleration along x, y, and z axis at a specified(optional) regular interval.
	* The Acceleration is returned via the onSuccess callback function at a regular interval.
	* options = {"frequency" : 3000}; //update every 3 seconds
	* @return a watchID that can be used to stop this watching later by #clearWatch() method.
	*/  
	abstract watchAcceleration(AccelerationEventListener listener, ErrorListener onError, [Map options]);
	
	/**
	* Stop watching the motion Acceleration.
	*/
	abstract void clearWatch(var watchID);
}

class _WatchIDInfo {
	final AccelerationEventListener _listener;
	final _watchID;
	_WatchIDInfo(this._listener, this._watchID);
}
