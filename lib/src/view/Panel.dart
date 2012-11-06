//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Oct 25, 2012  10:01:25 AM
//Author: simonpai
part of rikulo_view;

/** A Panel view.
 * 
 */
class Panel extends View {
  
  /** Construct a Panel.
   * 
   */
  Panel();
  
  /// Retrieve content node.
  Element get contentNode => getNode("inner");
  
  /// Retrieve button node of the given [name].
  Element getButtonNode(String name) => getNode("btn-$name");
  
  /** Add a button floating at the upper right corner of the Panel with the given
   * [name] and the given [listener] to handle on its click event.
   */
  void addButton(String name, EventListener listener) {
    _addBtn(getNode("btns"), name, listener);
  }
  
  /** Remove the button of the given [name];
   */
  void removeButton(String name) => getButtonNode(name).remove();
  
  Element _createBtn(String name) =>
      new Element.html('<div class="v-btn v-btn-$name" id="$uuid-btn-$name"></div>');
  
  void _addBtn(Element btns, String name, EventListener listener) {
    btns.nodes.add(_createBtn(name)..on.click.add(listener));
  }
  
  
  
  //@override
  String get className => "Panel"; //TODO: replace with reflection if Dart supports it
  
  //@override
  Element render_() {
    Element element = new Element.html('''
<div class="v-shadow">
  <div class="v-btns" id="$uuid-btns"></div>
  <div class="v-body" id="$uuid-body">
    <div class="v-inner" id="$uuid-inner"></div>
  </div>
</div>
''');
    return element;
  }
  
  //@override
  void addChildNode_(View child, View beforeChild) {
    if (beforeChild != null)
      super.addChildNode_(child, beforeChild);
    else
      contentNode.nodes.add(child.node);
  }
  
  
  
  //@override
  void onPreLayout_(MeasureContext mctx) {
    super.onPreLayout_(mctx);
    final Element bd = getNode("body");
    final _CSSAgent bdcss = new _CSSAgent(bd);
    bd.style.height = CSS.px(new DOMAgent(node).innerHeight - bdcss.sumVer(mar: true));
    contentNode.style.height = CSS.px(new DOMAgent(bd).innerHeight - bdcss.sumVer(pad: true));
    contentNode.style.width = CSS.px(new DOMAgent(bd).innerWidth - bdcss.sumHor(pad: true));
  }
  
  //@override
  int get innerWidth => inDocument ? new DOMAgent(contentNode).innerWidth : 0;
  
  //@override
  int get innerHeight => inDocument ? new DOMAgent(contentNode).innerHeight : 0;
  
  //@override
  int measureHeight_(MeasureContext mctx) {
    final int bdh = new _CSSAgent(getNode("body")).sumVer(mar: true, bor: true, pad: true) + super.measureHeight_(mctx);
    final int btnh = new DOMAgent(getNode("btns")).height + new _CSSAgent(node).sumVer(bor: true);
    return max(bdh, btnh);
  }
  
  //@override
  int measureWidth_(MeasureContext mctx) {
    final int bdw = new _CSSAgent(getNode("body")).sumHor(mar: true, bor: true, pad: true) + super.measureWidth_(mctx);
    final int btnw = new DOMAgent(getNode("btns")).width + new _CSSAgent(node).sumHor(bor: true);
    return max(bdw, btnw);
  }
  
}
