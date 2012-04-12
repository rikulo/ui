//Sample Code: Layout Demostration

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class LinearLayoutDemo extends Activity {

	void onCreate_() {
		title = "Linear Layout Demo";
		rootView.style.backgroundColor = "#cca";

		View vlayout = new View();
		vlayout.layout.type = "linear";
		vlayout.layout.orient = "vertical";
		rootView.appendChild(vlayout);

		View hlayout = new View();
		hlayout.layout.type = "linear";
		hlayout.layout.orient = "horizontal";
		hlayout.profile.height = "content";
		vlayout.appendChild(hlayout);

		View view = new View();
		view.style.backgroundColor = "blue";
		view.profile.width = "flex";
		view.profile.height = "50";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "orange";
		view.profile.width = "flex 2";
		view.profile.height = "40";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "yellow";
		view.profile.width = "flex 3";
		view.profile.height = "30";
		hlayout.appendChild(view);
	}
}

void main() {
	new LinearLayoutDemo().run();
}
