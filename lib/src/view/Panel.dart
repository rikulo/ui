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
  final bool _closeBtn;
  final int _btnNum;
  final ViewEventListener _maxLis, _minLis, _dismissLis;
  
  /** Construct a Panel.
   * 
   * + [title] is shown on the Panel header.
   * + if [max] is given, a maximize button is shown on the header, and
   * the callback will be invoked when the maximize button is clicked.
   * + if [min] is given, a minimize button is shown on the header, and
   * the callback will be invoked when the minimize button is clicked.
   * + if [closeBtn] is true, a close button is shown on the header
   * + provide [dismiss] to override the default behavior when close button is 
   * clicked. The default behavior is to remove the Panel, without visual effect.
   */
  Panel({String title, ViewEventListener max, ViewEventListener min,
  ViewEventListener dismiss, bool closeBtn : false}) : 
  _title = title, _maxLis = max, _minLis = min, _closeBtn = closeBtn, 
  _dismissLis = dismiss != null ? dismiss : _defaultCloseListener,  
  _btnNum = (max != null ? 1 : 0) + (min != null ? 1 : 0) + (closeBtn ? 1 : 0);
  
  static ViewEventListener _defaultCloseListener = (ViewEvent event) => event.target.remove(); 
  
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
  <div class="v-body" id="$uuid-body">
    <div class="v-inner" id="$uuid-inner"></div>
  </div>
</div>
''');
    Element header = element.$dom_firstElementChild;
    
    if (_title != null)
      header.innerHTML = _title;
    
    if (_closeBtn) {
      header.nodes.add(_btn("close")..on.click.add((Event event) {
        sendEvent(new ViewEvent("dismiss", this));
      }));
      on.dismiss.add(_dismissLis);
    }
    
    if (_maxLis != null) {
      header.nodes.add(_btn("max")..on.click.add((Event event) {
        sendEvent(new ViewEvent("maximize", this));
      }));
      on['maximize'].add(_maxLis);
    }
    
    if (_minLis != null) {
      header.nodes.add(_btn("min")..on.click.add((Event event) {
        sendEvent(new ViewEvent("minimize", this));
      }));
      on['minimize'].add(_minLis);
    }
    
    return element;
  }
  
  Element _btn(String suffix) =>
      new Element.html('<div class="v-btn v-btn-$suffix"></div>');
  
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
    getNode("body").style.height = CSS.px(ph - hh);
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
    final int padding = CSS.sumOf([bs.paddingTop, bs.paddingBottom]);
    return new DOMAgent(headerNode).height + padding + super.measureHeight_(mctx);
  }
  
  //@override
  int measureWidth_(MeasureContext mctx) {
    final int titleWidth = _title == null ? 0 : new DOMAgent(headerNode).measureText(_title).width;
    //final CSSStyleDeclaration bs = new DOMAgent(getNode("body")).computedStyle;
    //final CSSStyleDeclaration hs = new DOMAgent(headerNode).computedStyle;
    // 12 = border (1 * 2) + padding (5 * 2), ad-hoc
    // 17 = button size (19) + margin (5), ad-hoc
    return max(_btnNum * 24 + titleWidth, super.measureWidth_(mctx)) + 12;
  }
  
}
