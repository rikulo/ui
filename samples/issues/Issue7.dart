#import('../../client/app/app.dart');
#import('../../client/view/view.dart');

class Issue7 extends Activity {
  void onCreate_() {
    View div = new View();
    div.style.backgroundImage = "url('res/search.png')";
    div.profile.width = "flex";
    div.profile.height = "flex";
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
}

main() {
  new Issue7().run();
}