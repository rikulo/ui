//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Apr 13, 2012  2:40:15 PM
// Author: tomyeh
library rikulo_example_viewport;

import "dart:html";

import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';

/**
 * A view port that demostrates how to implement a view that the origin of
 * child views is not at the left-top corner of this view.
 */
class Viewport extends View {
  View _toolbar;
  //Controlling the space between [node] and [contentNode]
  int _spacingLeft = 10, _spacingTop = 30, _spacingRight = 10, _spacingBottom = 10;

  Viewport([String title]) {
    if (title != null && !title.isEmpty)
      this.title = title;
  }

  String get title => getNode("title").innerHtml;
  void set title(String title) {
    getNode("title").innerHtml = title != null ? title: "";
  }

  View get toolbar => _toolbar;
  void set toolbar(View tbar) {
    if (_toolbar != null)
      _toolbar.remove();

    _toolbar = tbar;

    if (_toolbar != null) {
      addChild(_toolbar, firstChild);
      _toolbar.top = 0; //align to top
      _toolbar.left = 120;
    }
  }

  //@override to returns the element representing the inner element.
  Element get contentNode => getNode("inner");
  //@override to skip the toolbar
  bool shallLayout_(View child) => !identical(child, _toolbar) && super.shallLayout_(child);
  //@override
  Element render_()
  => new Element.html(
      '''
<div>
<div class="v-Viewport-title" id="$uuid-title"></div>
<div class="v-Viewport-toolbar" id="$uuid-toolbar">&nbsp;</div>
<div class="v-Viewport-inner" id="$uuid-inner"></div>
</div>
      ''');

  //@override to insert the toolbar to getNode("toolbar"), and others into contentNode
  void addChildNode_(View child, View beforeChild) {
    if (identical(child, _toolbar)) {
      getNode("toolbar").nodes.add(child.node);
    } else {
      if (beforeChild != null && !identical(beforeChild, _toolbar))
        super.addChildNode_(child, beforeChild);
      else
        contentNode.nodes.add(child.node);
    }
  }
  //@override to adjust toolbar and contentNode
  void mount_() {
    super.mount_();

    final style = contentNode.style;
    style.left = Css.px(_spacingLeft);
    style.top = Css.px(_spacingTop);
    _adjustWidth();
    _adjustHeight();
  }
  //@override
  int get innerWidth => new DomAgent(contentNode).innerWidth;
  //@override
  int get innerHeight => new DomAgent(contentNode).innerHeight;
  //@override to adjust [contentNode]'s width accordingly
  void set width(int width) {
    super.width = width;
    if (inDocument)
      _adjustWidth();
  }
  //@override to adjust [contentNode]'s height accordingly
  void set height(int height) {
    super.height = height;
    if (inDocument)
      _adjustHeight();
  }
  void _adjustWidth() {
    int v = new DomAgent(node).innerWidth - _spacingLeft - _spacingRight;
    contentNode.style.width = Css.px(v > 0 ? v: 0);
  }
  void _adjustHeight() {
    int v = new DomAgent(node).innerHeight - _spacingTop - _spacingBottom;
    contentNode.style.height = Css.px(v > 0 ? v: 0);
  }
}
