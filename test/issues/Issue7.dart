import 'package:rikulo/view.dart';

main() {
  View div = new View();
  div.style.backgroundImage = "url('res/search.png')";
  div.profile.width = "flex";
  div.profile.height = "flex";
  
  final View mainView = new View()..addToDocument();
  mainView.addChild(div);

  TextView help = new TextView.fromHTML('''
      <ul>
      <li>Environment: dart2js and test it on Firefox and IE
      <li>You shall see the background is full of the search icons</li>
      </ul>
  ''');
  help.style.backgroundColor = "white";
  div.addChild(help);
}