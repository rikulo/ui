//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Oct 25, 2012  10:01:25 AM
//Author: simonpai

/** The effect for Panel dismiss. [end] needs to be called at the end
 * of the effect.
 */
typedef void DismissEffect(Element element, void end());

/** A Panel view, as a container with header.
 * 
 */
class Panel extends View {
  
  String _title;
  final bool _max, _min, _close;
  final int _btnNum;
  
  /** Construct a Panel.
   * 
   * + [title] is shown on the Panel header.
   * + if [max] is true, a maximize button is shown on the header
   * + if [min] is true, a minimize button is shown on the header
   * + if [close] is true, a close button is shown on the header
   */
  Panel({String title, bool max : false, bool min : false, bool close : false}) : 
  _title = title, _max = max, _min = min, _close = close,
  _btnNum = (max ? 1 : 0) + (min ? 1 : 0) + (close ? 1 : 0);
  
  /// The title of Panel
  String get title => _title;
  
  /// The title of Panel
  void set title(String title) {
    _title = title;
    if (inDocument)
      getNode("header").innerHTML = title;
  }
  
  /// Retrieve content node.
  Element get contentNode => getNode("inner");
  
  /// Retrieve header node.
  Element get headerNode => getNode("header");
  
  //@override
  String get className => "Panel"; //TODO: replace with reflection if Dart supports it
  
  //@override
  Element render_() {
    Element element = new Element.html('''
<div>
  <div class="v-header" id="$uuid-header"></div>
  <div class="v- v-inner" id="$uuid-inner"></div>
</div>
''');
    Element header = element.$dom_firstElementChild;
    if (_title != null)
      header.innerHTML = _title;
    if (_close)
      header.nodes.add(_btn("close"));
    if (_max)
      header.nodes.add(_btn("max"));
    if (_min)
      header.nodes.add(_btn("min"));
    return element;
  }
  
  Element _btn(String suffix) =>
      new Element.html('<div class="v-btn v-btn-$suffix" id="$uuid-btn-$suffix"></div>');
  
  //@override
  void addChildNode_(View child, View beforeChild) {
    if (beforeChild != null)
      super.addChildNode_(child, beforeChild);
    else
      contentNode.nodes.add(child.node);
  }
  
  //@override
  void onLayout_(MeasureContext mctx) {
    final int hh = new DOMAgent(headerNode).height;
    final int ph = new DOMAgent(node).innerHeight;
    contentNode.style.height = CSS.px(ph - hh);
    contentNode.style.top = CSS.px(hh);
    super.onLayout_(mctx);
  }
  
  //@override
  int get innerWidth => 
      inDocument ? new DOMAgent(contentNode).innerWidth : super.innerWidth;
  
  //@override
  int get innerHeight => 
      inDocument ? new DOMAgent(contentNode).innerHeight : super.innerHeight;
  
  //@override
  int measureHeight_(MeasureContext mctx) => 
      new DOMAgent(headerNode).height + super.measureHeight_(mctx);
  
  //@override
  int measureWidth_(MeasureContext mctx) {
    final int titleWidth = _title == null ? 0 : new DOMAgent(headerNode).measureText(_title).width;
    // 12 = border (1 * 2) + padding (5 * 2), ad-hoc
    // 17 = button size (14) + margin (3), ad-hoc
    return max(_btnNum * 17 + 12 + titleWidth, super.measureWidth_(mctx));
  }
  
  EventListener _onClose, _onMax, _onMin;
  
  //@override
  void mount_() {
    super.mount_();
    
    if (_close) {
      getNode("btn-close").on.click.add(_onClose = (Event event) {
        sendEvent(new ViewEvent("dismiss", this));
      });
    }
    if (_max) {
      getNode("btn-max").on.click.add(_onMax = (Event event) {
        sendEvent(new ViewEvent("maximize", this));
      });
    }
    if (_min) {
      getNode("btn-min").on.click.add(_onMin = (Event event) {
        sendEvent(new ViewEvent("minimize", this));
      });
    }
    
    on.dismiss.add((ViewEvent event) {
      onDismiss_();
    });
    
  }
  
  //override
  void unmount_() {
    if (_close)
      getNode("btn-close").on.click.remove(_onClose);
    if (_max)
      getNode("btn-max").on.click.remove(_onMax);
    if (_min)
      getNode("btn-min").on.click.remove(_onMin);
    
    super.unmount_();
  }
  
  void onDismiss_() {
    if (_dismissEffect != null)
      _dismissEffect(this.node, remove);
    else
      remove();
  }
  
  DismissEffect _dismissEffect; // TODO: a better way?
  
  /** Set the effect when the panel is dismissed.
   */
  void set dismissEffect(DismissEffect effect) {
    _dismissEffect = effect;
  }
  
}
