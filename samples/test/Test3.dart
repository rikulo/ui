//Sample Code: Layout Demostration

#import('dart:html');

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Test3 extends Activity {

	void onCreate_() {
		title = "Test 3: Horizontal Linear Layout";

		rootView.style.backgroundColor = "#cca";

		test1(rootView, 10, 10);
		test2(rootView, 10, 100);
	}
	void test1(View parent, int left, int top) {
	  //case 1: fixed size
		View hlayout = new View();
    hlayout.left = left;
    hlayout.top = top;
		hlayout.style.backgroundColor = "#ddb";
		hlayout.layout.type = "linear";
		//hlayout.layout.orient = "horizontal"; //default
		hlayout.profile.width = hlayout.profile.height = "content";
		parent.appendChild(hlayout);

		View view = new View();
		view.style.backgroundColor = "blue";
		view.profile.width = "30"; //test profile.width
		view.height = 50; //test height
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "orange";
		view.width = 50;
		view.profile.height = "40";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "yellow";
		view.width = 70;
		view.height = 30;
		view.profile.align = "end";
		hlayout.appendChild(view);
	}
	void test2(View parent, int left, int top) {
		//case 2: flex
		View hlayout = new View();
		hlayout.left = left;
		hlayout.top = top;
		hlayout.style.border = "1px solid #884";
		hlayout.layout.type = "linear";
		hlayout.layout.align = "center";
		hlayout.layout.orient = "horizontal";
		hlayout.layout.spacing = "5 5";
		hlayout.profile.width = "70%";
	   //we can't use flex (which implies parent.innerWidth)
	   //of course, we can use hlayout to partition but it is not tested here
		hlayout.height = 40; //..layout.height = "40" is also OK
		parent.appendChild(hlayout);

		View view = new View();
		view.style.backgroundColor = "blue";
		view.profile.width = "flex"; //test profile.width
		view.profile.height = "flex";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "orange";
		view.profile.width = "flex 2";
		view.profile.height = "50%";
		hlayout.appendChild(view);
		view = new View();
		view.style.backgroundColor = "yellow";
		view.profile.width = "flex 3";
		view.profile.height = "100%";
		hlayout.appendChild(view);
	}
}

void main() {
	new Test3().run();
}
