//Sample Code: Test IdSpace

import 'dart:html';
import 'package:rikulo/view.dart';

void main() {
  final webView = new TextView.fromHTML('''
    <style>
    span.box {
      display:inline-block;width:64px;height:20px;
    }
    </style>
    <div>
      Here is in DIV: <span class="box">&nbsp;</span>
    </div>
    <ul style="line-height: 23px">
      <li>Structured Web Apps <span class="box"></span></li>
      <li>Structured UI Model <span class="box"></span></li>
    </ul>
    ''')
    ..width = 500
    ..top = 30;
  new Section()
    ..addChild(new Button("Click Me")..on.click.add((event) {
        webView.top += 50;
      }))
    ..addChild(webView)
    ..addToDocument();

  for (Element n in webView.node.queryAll("span"))
    new Switch(true).addToDocument(node: n);

  var tv = new TextView.fromHTML("<b>Right Top</b>")
    ..profile.location = "right top"
    ..addToDocument();
  new TextView.fromHTML("<b>South End</b>")
    ..profile.location = "south end"
    ..profile.anchorView = tv
    ..addToDocument();
}
