//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Oct 25, 2012  10:01:25 AM
//Author: simonpai
part of rikulo_view;

/**
 * A panel view for grouping a collection of views that are usually closed and shown together.
 */
class Panel extends View {
  
  /** Construct a Panel.
   * 
   */
  Panel();
  
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
  Element render_() =>
      new Element.html('<div class="v-shadow"><div class="v-btns" id="$uuid-btns"></div></div>');
  
  //@override
  int measureHeight_(MeasureContext mctx) {
    final int btnh = new DomAgent(getNode("btns")).height + new _DomAgentX(node).sumVer(bor: true);
    return max(super.measureHeight_(mctx), btnh);
  }
  
  //@override
  int measureWidth_(MeasureContext mctx) {
    final int btnw = new DomAgent(getNode("btns")).width + new _DomAgentX(node).sumHor(bor: true);
    return max(super.measureWidth_(mctx), btnw);
  }
  
}
