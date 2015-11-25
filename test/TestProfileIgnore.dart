import 'package:rikulo_ui/view.dart';

void main() {
  new Style(content: ".block { width: 40px; height: 40px; border: 1px solid blue; }").addToDocument();
  
  final View mainView = new View()..addToDocument();
  
  final View container = new View();
  container.layout.text = "type: linear; orient: vertical; spacing: 0";
  container.style.background = "#CCC";
  container.style.border = "1px solid black";

  mainView.addChild(container);
  
  container.addChild(block());
  container.addChild(block());
  container.addChild(block());
  
}

View block() =>
    new View()..classes.add("block")
    ..profile.text = "width: ignore; height: ignore";