//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Test4 extends Activity {

	void onCreate_() {
		title = "Test 4: Vertical Linear Layout";

		rootView.style.backgroundColor = "#cca";

		test1(rootView, 10, 10);
		test2(rootView, 100, 10);
	}
	void test1(View parent, int left, int top) {
	  //case 1: fixed size
		View vlayout = new View();
    vlayout.left = left;
    vlayout.top = top;
		vlayout.style.backgroundColor = "#ddb";
		vlayout.layout.type = "linear";
		vlayout.layout.orient = "vertical";
		vlayout.profile.width = vlayout.profile.height = "content";
		parent.appendChild(vlayout);

		View view = new View();
		view.style.backgroundColor = "blue";
		view.profile.height = "30"; //test profile.height
		view.width = 50; //test width
		vlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "orange";
		view.height = 50;
		view.profile.width = "40";
		vlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "yellow";
		view.height = 70;
		view.width = 30;
		view.profile.align = "end";
		vlayout.appendChild(view);
	}
	void test2(View parent, int left, int top) {
		//case 2: flex
		View vlayout = new View();
		vlayout.left = left;
		vlayout.top = top;
		vlayout.style.border = "1px solid #884";
		vlayout.layout.type = "linear";
		vlayout.layout.align = "center";
		vlayout.layout.orient = "vertical";
		vlayout.layout.spacing = "5 5";
		vlayout.profile.height = "70%";
	   //we can't use flex (which implies parent.innerHeight)
	   //of course, we can use vlayout to partition but it is not tested here
		vlayout.width = 50; //..layout.width = "50" is also OK
		parent.appendChild(vlayout);

		View view = new View();
		view.style.backgroundColor = "blue";
		view.profile.height = "flex"; //test profile.width
		view.profile.width = "flex";
		vlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "orange";
		view.profile.height = "flex 2";
		view.profile.width = "50%";
		vlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "yellow";
		view.profile.height = "flex 3";
		view.profile.width = "100%";
		vlayout.appendChild(view);
	}
}

void main() {
	new Test4().run();
}
