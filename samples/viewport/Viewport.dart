//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  2:40:15 PM
// Author: tomyeh
#library('rikulo:samples/viewport');

#import("dart:html");
#import('../../client/view/view.dart');
#import("../../client/html/html.dart");

/**
 * A view port that demostrates how to implement a view that the origin of
 * child views is not at the left-top corner of this view.
 */
class Viewport extends View {
  String _title;
  View _toolbar;
  //Controlling the space between [node] and [contentNode]
  int _spacingLeft = 10, _spacingTop = 30, _spacingRight = 10, _spacingBottom = 10;

  Viewport([String title=""]) {
    _title = title;
  }

  //@Override
  String get className => "Viewport"; //TODO: replace with reflection if Dart supports it

  String get title => _title;
  void set title(String title) {
    if (title == null) title = "";
    _title = title;

    if (inDocument)
      getNode("title").innerHTML = title;
  }

  View get toolbar => _toolbar;
  void set toolbar(View tbar) {
    if (_toolbar != null)
      _toolbar.removeFromParent();

    _toolbar = tbar;

    if (_toolbar != null) {
      addChild(_toolbar, firstChild);
      _syncToolbar();
    }
  }
  void _syncToolbar() {
    if (inDocument) {
      final DOMQuery qtbar = new DOMQuery(getNode("toolbar"));
      _toolbar.left = qtbar.offsetLeft;
      _toolbar.top = qtbar.offsetTop;
    }
  }

  //@Override to returns the element representing the inner element.
  Element get contentNode => getNode("inner");
  //@Override to skip the toolbar
  bool shallLayout_(View child) => child !== _toolbar && super.shallLayout_(child);
  //@Override
  void domInner_(StringBuffer out) {
    out.add('<div class="v-Viewport-title" id="')
      .add(uuid).add('-title">').add(_title)
      .add('</div>');

    out.add('<div class="v-Viewport-toolbar" id="').add(uuid)
      .add('-toolbar">&nbsp;'); //&nbsp; makes this DIV positioned correctly
    if (_toolbar != null)
      _toolbar.draw(out);
    out.add('</div>');

    out.add('<div class="v-Viewport-inner" id="')
      .add(uuid).add('-inner">');

    for (View child = firstChild; child != null; child = child.nextSibling) {
      if (child !== _toolbar)
        child.draw(out);
    }

    out.add('</div>');
  }
  //@Override to insert the toolbar to getNode("toolbar"), and others into contentNode
  void insertChildToDocument_(View child, var childInfo, View beforeChild) {
    if (child === _toolbar) {
      if (childInfo is Element)
        getNode("toolbar").insertBefore(childInfo, null); //note: Firefox not support insertAdjacentElement
      else
        getNode("toolbar").insertAdjacentHTML("beforeEnd", childInfo);
    } else {
      if (beforeChild === _toolbar)
        beforeChild = null;

      if (beforeChild != null)
        super.insertChildToDocument_(child, childInfo, beforeChild);
      else if (childInfo is Element)
        contentNode.$dom_appendChild(childInfo); //note: Firefox not support insertAdjacentElement
      else
        contentNode.insertAdjacentHTML("beforeEnd", childInfo);
    }
  }
  //@override to adjust toolbar and contentNode
  void mount_() {
    super.mount_();

    final style = contentNode.style;
    style.left = CSS.px(_spacingLeft);
    style.top = CSS.px(_spacingTop);
    _adjustWidth();
    _adjustHeight();
    if (_toolbar != null)
      _syncToolbar();
  }
  //@Override
  int get innerWidth => new DOMQuery(contentNode).innerWidth;
  //@Override
  int get innerHeight => new DOMQuery(contentNode).innerHeight;
  //@Override to adjust [contentNode]'s width accordingly
  void set width(int width) {
    super.width = width;
    if (inDocument)
      _adjustWidth();
  }
  //@Override to adjust [contentNode]'s height accordingly
  void set height(int height) {
    super.height = height;
    if (inDocument)
      _adjustHeight();
  }
  void _adjustWidth() {
    int v = new DOMQuery(node).innerWidth - _spacingLeft - _spacingRight;
    contentNode.style.width = CSS.px(v > 0 ? v: 0);
  }
  void _adjustHeight() {
    int v = new DOMQuery(node).innerHeight - _spacingTop - _spacingBottom;
    contentNode.style.height = CSS.px(v > 0 ? v: 0);
  }
}
