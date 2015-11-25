//Sample Code: Test IDSpace

import 'dart:html';
import 'package:rikulo_ui/view.dart';

void main() {
  final webView = new TextView.fromHtml('''
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
    ..addChild(new Button("Click Me")..on.click.listen((event) {
        webView.top += 50;
      }))
    ..addChild(webView)
    ..addToDocument();

  for (Element n in webView.node.querySelectorAll("span"))
    new Switch(true).addToDocument(ref: n);

  var tv = new TextView.fromHtml("<b>Right Top</b>")
    ..profile.location = "right top"
    ..addToDocument();
  new TextView.fromHtml("<b>South End</b>")
    ..profile.location = "south end"
    ..profile.anchorView = tv
    ..addToDocument();
}
