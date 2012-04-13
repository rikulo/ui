//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

#import('viewport.dart');

class ViewportDemo extends Activity {

	void onCreate_() {
		title = "Viewport Demo";

		Viewport viewport = new Viewport("Viewport Demo");
		viewport.layout.type = "linear";
		viewport.layout.orient = "vertical";
		viewport.profile.width = viewport.profile.height = "flex";
		rootView.appendChild(viewport);

		createToolbar(viewport);
		createChildViews(viewport);
	}
	void createToolbar(Viewport parent) {
		View toolbar = new View();
		toolbar.layout.type = "linear";
		toolbar.width = "content";
		toolbar.height = "content";
		for (final String src in ["search.png", "received.png", "sent.png"]) {
			final Image image = new Image("res/$src");
			image.width = image.height = 16; //TODO: doLayout after all images are loaded
			toolbar.appendChild(image);
		}
		parent.toolbar = toolbar;
	}
	void createChildViews(View parent) {
		//first hlayout
		View hlayout = new View();
		hlayout.layout.type = "linear";
		hlayout.profile.height = "content";
		hlayout.profile.width = "flex";
		parent.appendChild(hlayout);

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

		//second horizontal layout
		hlayout = new View();
		hlayout.layout.type = "linear";
		hlayout.layout.align = "end";
		hlayout.profile.height = "flex";
		hlayout.profile.width = "flex";
		parent.appendChild(hlayout);

		view = new View();
		view.style.backgroundColor = "yellow";
		view.profile.width = "flex 3";
		view.profile.height = "flex";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "orange";
		view.profile.width = "flex 2";
		view.profile.height = "50%";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "blue";
		view.profile.width = "flex 1";
		view.profile.height = "25%";
		hlayout.appendChild(view);
	}
}

void main() {
	new ViewportDemo().run();
}
