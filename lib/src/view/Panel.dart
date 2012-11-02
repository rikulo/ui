//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Oct 25, 2012  10:01:25 AM
//Author: simonpai

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
  void onLayout_(MeasureContext mctx) {
    final CSSStyleDeclaration bs = new DOMAgent(getNode("body")).computedStyle;
    getNode("body").style.height = 
        CSS.px(new DOMAgent(node).innerHeight - CSS.sumOf([bs.marginTop, bs.marginBottom]));
    super.onLayout_(mctx);
  }
  
  //@override
  int get innerWidth => 
      inDocument ? new DOMAgent(contentNode).innerWidth : super.innerWidth;
  
  //@override
  int get innerHeight => 
      inDocument ? new DOMAgent(contentNode).innerHeight : super.innerHeight;
  
  //@override
  int measureHeight_(MeasureContext mctx) {
    final CSSStyleDeclaration bs = new DOMAgent(getNode("body")).computedStyle;
    return CSS.sumOf([bs.paddingTop, bs.paddingBottom]) + super.measureHeight_(mctx);
  }
  
  //@override
  int measureWidth_(MeasureContext mctx) {
    //final int titleWidth = _title == null ? 0 : new DOMAgent(headerNode).measureText(_title).width;
    //final CSSStyleDeclaration bs = new DOMAgent(getNode("body")).computedStyle;
    //final CSSStyleDeclaration hs = new DOMAgent(headerNode).computedStyle;
    // 12 = border (1 * 2) + padding (5 * 2), ad-hoc
    // 17 = button size (19) + margin (5), ad-hoc
    return super.measureWidth_(mctx) + 12;
  }
  
}
