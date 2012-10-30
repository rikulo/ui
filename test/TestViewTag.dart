//Sample Code: Test Log

import 'package:rikulo/view.dart';

void main() {
  /* Notice that this is only for testing purpose. This sample is better to be
  done by use of the TextView.fromHTML constructor as follows (not exactly
  equalivalent but you got the point).

  new TextView.fromHTML('''
  <dl>
  <li type="i" value="$index">This is the <b>$index</b> item</li>
  </dl>
  ''');
   */
  View dl = new View.tag("dl");
  for (int i = 0; i < 10; ++i) {
    View li = new View.tag("li", {"type": "i", "value": i*2 + 1},
        "This is the <b>$i</b> item.", false);
    li.top = 22 * i;
    dl.addChild(li);
  }
  final View mainView = new View()..addToDocument();
  mainView.addChild(dl);
  mainView.addChild(
    new View.html('''
      <table cellapding="10" border="1">
        <tr><td>Cell 1.1</td><td>Cell 1.2</td></tr>
        <tr><td>Cell 2.1</td><td>Cell 2.2</td></tr>
      </table>
      ''')
      ..left = 200..width = 300);
}
