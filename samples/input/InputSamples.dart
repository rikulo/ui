//Sample Code: Input Samples

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class InputSamples extends Activity {

  void onCreate_() {
    title = "Input Samples";

    mainView.layout.text = "type: linear; orient: vertical";

    for (final String type in
    ["text", "password", "multiline", "number", "tel", "date", "color"]) {
      View view = new View();
      view.layout.text = "type: linear; align: center; spacing: 0 3";
      view.profile.width = "flex";
      mainView.addChild(view);

      TextView label = new TextView(type);
      label.style.textAlign = "right";
      label.profile.width = "70";
      view.addChild(label);

      TextBox input = new TextBox(type: type);
      input.on.change.add((event) {
        TextView inf = input.nextSibling;
        inf.text = input.value;
      });
      view.addChild(input);

      label = new TextView();
      label.profile.text = "width: flex; height: flex";
      view.addChild(label);
    }
  }
}

void main() {
  new InputSamples().run();
}
