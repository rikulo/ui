#import('dart:html');
#import('../../client/widget/Div.dart');
#import('../../client/widget/Label.dart');
#import('../../client/widget/Button.dart');

class HelloWorld {

	helloworld() {
	}

	void run() {
		var lb;
		new Div()
			.appendChild(lb = new Label("Hello World!"))
			.addToDocument(document.query('#test1'), outer:true);

		lb.on.click.add((event) {
			event.target.style.border = "1px solid blue";
		});

		final btn = new Button("Hi");
		btn.on.click.add((event) {
			event.target.parent.appendChild(new Label("Hi, how are you?"));
		});
		new Div()
			.appendChild(btn)
			.addToDocument(document.query('#test2'), outer:true);
	}
}

void main() {
	new HelloWorld().run();
}
