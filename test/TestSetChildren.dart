import 'package:rikulo_ui/view.dart';

void main() {
  new View()
    ..layout.type = "linear"
    ..layout.orient = "vertical"
    ..children = [
      new TextView("Hello World!")
        ..on.click.listen((event) {
          (event.target as TextView).text = "Welcome to Rikulo.";
          event.target.requestLayout();
        }),
      new View()
        ..layout.type = "linear" //arrange the layout of child views linearly
        ..children = [
            new TextView("Name"), //a label
            new TextBox()
          ]
        ]
    ..addToDocument(); 
}