//Sample Code: Hello World!

#import('dart:html');
//#import('dart:io');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/event/event.dart');
#import('../../client/device/device.dart');
#import('../../client/deviceimpl/deviceimpl.dart');

class HelloWorld extends Activity {

	void onCreate_() {
print("onCreate_()");	  
		title = "Hello World!";

		TextView text = new TextView("Hello World!");
		text.profile.text = "anchor:  parent; location: center center";
		text.on.click.add((event) {
			event.target.style.border =
				event.target.style.border.isEmpty() ? "1px solid blue": "";
		});
		rootView.appendChild(text);
		
print("addAccelerate");   
		device.accelerometer.on.accelerate.add((AccelerationEvent event)=>print('accelerate called: x:' + event.x+ ", y:" + event.y + ", z:" + event.z + ", timestamp:" + event.timestamp));
	}
}


void main() {
	new HelloWorld().run();
}
