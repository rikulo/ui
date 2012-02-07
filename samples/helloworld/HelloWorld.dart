//Sample Code: Hello World!

#import('dart:html');
#import('../../client/widget/widget.dart');

class HelloWorld {

	helloworld() {
	}

	void run() {
		var w0, w1;
		new Div()
			.appendChild(w0 = new Label("Hello World!"))
			.addToDocument(document.query('#test1'), outer:true);

		w0.on.click.add((event) {
			event.target.style.border = "1px solid blue";
		});

		w0 = new Button("Hi");
		w0.on.click.add((event) {
			event.target.parent.appendChild(new Label("Hi, how are you?"));
		});
		new Div()
			.appendChild(w0)
			.addToDocument(document.query('#test2'), outer:true);

		Widget container = new Div();
		w0 = new Button("Test setRange");
		w0.on.click.add((event) {
			List<Widget> children = container.children;
			var n1, n2, n3;
			children.add(new Label("N0"));
			children.add(n1 = new Label("N1"));
			children.setRange(2, 2, [n2 = new Label("N2"), n3 = new Label("N3")]);
			children.setRange(1, 3, [n3, n2, n1]);

//			for (Widget p in children)
//				print("child: $p");
//			print("[1/${container.childCount}]: ${children[1]}");
		});
		w1 = new Button("sort");
		w1.on.click.add((event) {
			container.children.sort((Label a, Label b) {
				return a.value.compareTo(b.value);
			});
		});
		new Div()
			.appendChild(w0)
			.appendChild(w1)
			.appendChild(container)
			.addToDocument(document.query('#test3'), outer:true);
	}
}

void main() {
	new HelloWorld().run();
}
