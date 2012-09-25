//Sample Code: Test IdSpace

#import('dart:html');

#import('../lib/app.dart');
#import('../lib/view.dart');

class TestEmbed extends Activity {

  void onCreate_() {
    final TextView webView = new TextView.fromHTML('''
      <ul style="line-height: 23px">
        <li>Structured Web Apps <span style="float:right"></span></li>
        <li>Structured UI Model <span style="float:right"></span></li>
      </ul>
      ''');
    webView.width = 250;
    mainView.addChild(webView);

    for (Element n in webView.node.queryAll("span"))
      new Switch(true).addToDocument(n, location: "right top");
  }
}

void main() {
  new TestEmbed().run();
}
