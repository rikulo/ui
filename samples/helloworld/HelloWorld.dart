//Sample Code: Hello World!

#import('dart:html');
#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class HelloWorld extends Activity {

	void onCreate() {
		var div, w0, w1, w2;
		div = new View();
		div.appendChild(w0 = new Label("Hello World!"));
		div.addToDocument(document.query('#test1'), outer:true);

		w0.on.click.add((event) {
			event.target.style.border = "1px solid blue";
		});

		w0 = new Button("Hi");
		w0.on.click.add((event) {
			event.target.parent.appendChild(new Label("Hi, how are you?"));
		});
		div = new View();
		div.appendChild(w0);
		div.addToDocument(document.query('#test2'), outer:true);

		View container = new View();
		w0 = new Button("Test setRange");
		w0.on.click.add((event) {
			List<View> children = container.children;
			var n1, n2, n3;
			children.add(new Label("N0"));
			children.add(n1 = new Label("N1"));
			children.setRange(2, 2, [n2 = new Label("N2"), n3 = new Label("N3")]);
			children.setRange(1, 3, [n3, n2, n1]);

//			for (View p in children)
//				print("child: $p");
//			print("[0-3/${container.childCount}]: ${children[0]} ${children[1]} ${children[2]} ${children[3]}");
		});
		w1 = new Button("sort");
		w1.on.click.add((event) {
			container.children.sort((Label a, Label b) {
				return a.value.compareTo(b.value);
			});
		});
		w2 = new Button("clear");
		w2.on.click.add((event) {
			container.children.clear();
		});
		div = new View();
		div.appendChild(w0);
		div.appendChild(w1);
		div.appendChild(w2);
		div.appendChild(container);
		div.addToDocument(document.query('#test3'), outer:true);
	}
}

void main() {
	new HelloWorld().run();
}
