import 'package:rikulo/view.dart';

main() {
  final View mainView = new View()..addToDocument();
  mainView.layout.type = "linear";
  mainView.layout.orient = "vertical";

  //hlayout
  View hlayout = new View();
  hlayout.layout.type = "linear";
  hlayout.layout.orient = "horizontal";
  hlayout.profile.width = "100%";

  mainView.addChild(hlayout);

  //left text
  TextView left = new TextView("LEFT TEXT");
  left.profile.width = "flex";
  left.style.lineHeight = "30px";
  hlayout.addChild(left);

  //right text
  TextView right = new TextView("RIGHT TEXT");
  right.profile.anchor = "parent";
  right.profile.location = "center right";
  hlayout.addChild(right);
}