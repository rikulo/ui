// DO NOT EDIT
// Auto-generated
// Copyright (C) 2012 Potix Corporation. All Rights Reserved.
part of rikulo_view;

class _StyleImpl implements CSSStyleDeclaration {
  final View _view;
  _StyleImpl(View this._view);

  CSSStyleDeclaration get _st => _view.node.style;
  String _n(String n) => CSS.name(StringUtil.uncamelize(n));
  String _g(String n) => getPropertyValue(_n(n));
  void _s(String n, var v) => setProperty(_n(n), v, '');

  //@override
  String getPropertyValue(String propertyName)
  => _st.getPropertyValue(propertyName);
  //@override
  String removeProperty(String propertyName)
  => _st.removeProperty(propertyName);
  //@override
  CSSValue getPropertyCSSValue(String propertyName)
  => _st.getPropertyCSSValue(propertyName);
  //@override
  String getPropertyPriority(String propertyName)
  => _st.getPropertyPriority(propertyName);
  //@override
  String getPropertyShorthand(String propertyName)
  => _st.getPropertyShorthand(propertyName); 
  //@override
  bool isPropertyImplicit(String propertyName)
  => _st.isPropertyImplicit(propertyName);

  //@override
  void setProperty(String propertyName, String value, [String priority]) {
    if (?priority)
      _st.setProperty(propertyName, value, priority);
    else
      _st.setProperty(propertyName, value);
  }

  //@override
  String get cssText => _st.cssText;
  //@override
  void set cssText(String value) {
    final style = _st;
    style.cssText = value;
    style.left = CSS.px(_view.left);
    style.top = CSS.px(_view.top);
    if (_view.width != null)
      style.width = CSS.px(_view.width);
    if (_view.height != null)
      style.height = CSS.px(_view.height);
  }

  //@override
  int get length => _st.length;
  //@override
  String item(int index) => _st.item(index);
  //@override
  CSSRule get parentRule => _st.parentRule;

  //@override
  String get alignContent => _g('alignContent');
  void set alignContent(v) {_s('alignContent', v);}
  //@override
  String get alignItems => _g('alignItems');
  void set alignItems(v) {_s('alignItems', v);}
  //@override
  String get alignSelf => _g('alignSelf');
  void set alignSelf(v) {_s('alignSelf', v);}
  //@override
  String get animation => _g('animation');
  void set animation(v) {_s('animation', v);}
  //@override
  String get animationDelay => _g('animationDelay');
  void set animationDelay(v) {_s('animationDelay', v);}
  //@override
  String get animationDirection => _g('animationDirection');
  void set animationDirection(v) {_s('animationDirection', v);}
  //@override
  String get animationDuration => _g('animationDuration');
  void set animationDuration(v) {_s('animationDuration', v);}
  //@override
  String get animationFillMode => _g('animationFillMode');
  void set animationFillMode(v) {_s('animationFillMode', v);}
  //@override
  String get animationIterationCount => _g('animationIterationCount');
  void set animationIterationCount(v) {_s('animationIterationCount', v);}
  //@override
  String get animationName => _g('animationName');
  void set animationName(v) {_s('animationName', v);}
  //@override
  String get animationPlayState => _g('animationPlayState');
  void set animationPlayState(v) {_s('animationPlayState', v);}
  //@override
  String get animationTimingFunction => _g('animationTimingFunction');
  void set animationTimingFunction(v) {_s('animationTimingFunction', v);}
  //@override
  String get appearance => _g('appearance');
  void set appearance(v) {_s('appearance', v);}
  //@override
  String get appRegion => _g('appRegion');
  void set appRegion(v) {_s('appRegion', v);}
  //@override
  String get aspectRatio => _g('aspectRatio');
  void set aspectRatio(v) {_s('aspectRatio', v);}
  //@override
  String get backfaceVisibility => _g('backfaceVisibility');
  void set backfaceVisibility(v) {_s('backfaceVisibility', v);}
  //@override
  String get background => _g('background');
  void set background(v) {_s('background', v);}
  //@override
  String get backgroundAttachment => _g('backgroundAttachment');
  void set backgroundAttachment(v) {_s('backgroundAttachment', v);}
  //@override
  String get backgroundClip => _g('backgroundClip');
  void set backgroundClip(v) {_s('backgroundClip', v);}
  //@override
  String get backgroundColor => _g('backgroundColor');
  void set backgroundColor(v) {_s('backgroundColor', v);}
  //@override
  String get backgroundComposite => _g('backgroundComposite');
  void set backgroundComposite(v) {_s('backgroundComposite', v);}
  //@override
  String get backgroundImage => _g('backgroundImage');
  void set backgroundImage(v) {_s('backgroundImage', v);}
  //@override
  String get backgroundOrigin => _g('backgroundOrigin');
  void set backgroundOrigin(v) {_s('backgroundOrigin', v);}
  //@override
  String get backgroundPosition => _g('backgroundPosition');
  void set backgroundPosition(v) {_s('backgroundPosition', v);}
  //@override
  String get backgroundPositionX => _g('backgroundPositionX');
  void set backgroundPositionX(v) {_s('backgroundPositionX', v);}
  //@override
  String get backgroundPositionY => _g('backgroundPositionY');
  void set backgroundPositionY(v) {_s('backgroundPositionY', v);}
  //@override
  String get backgroundRepeat => _g('backgroundRepeat');
  void set backgroundRepeat(v) {_s('backgroundRepeat', v);}
  //@override
  String get backgroundRepeatX => _g('backgroundRepeatX');
  void set backgroundRepeatX(v) {_s('backgroundRepeatX', v);}
  //@override
  String get backgroundRepeatY => _g('backgroundRepeatY');
  void set backgroundRepeatY(v) {_s('backgroundRepeatY', v);}
  //@override
  String get backgroundSize => _g('backgroundSize');
  void set backgroundSize(v) {_s('backgroundSize', v);}
  //@override
  String get blendMode => _g('blendMode');
  void set blendMode(v) {_s('blendMode', v);}
  //@override
  String get border => _g('border');
  void set border(v) {_s('border', v);}
  //@override
  String get borderAfter => _g('borderAfter');
  void set borderAfter(v) {_s('borderAfter', v);}
  //@override
  String get borderAfterColor => _g('borderAfterColor');
  void set borderAfterColor(v) {_s('borderAfterColor', v);}
  //@override
  String get borderAfterStyle => _g('borderAfterStyle');
  void set borderAfterStyle(v) {_s('borderAfterStyle', v);}
  //@override
  String get borderAfterWidth => _g('borderAfterWidth');
  void set borderAfterWidth(v) {_s('borderAfterWidth', v);}
  //@override
  String get borderBefore => _g('borderBefore');
  void set borderBefore(v) {_s('borderBefore', v);}
  //@override
  String get borderBeforeColor => _g('borderBeforeColor');
  void set borderBeforeColor(v) {_s('borderBeforeColor', v);}
  //@override
  String get borderBeforeStyle => _g('borderBeforeStyle');
  void set borderBeforeStyle(v) {_s('borderBeforeStyle', v);}
  //@override
  String get borderBeforeWidth => _g('borderBeforeWidth');
  void set borderBeforeWidth(v) {_s('borderBeforeWidth', v);}
  //@override
  String get borderBottom => _g('borderBottom');
  void set borderBottom(v) {_s('borderBottom', v);}
  //@override
  String get borderBottomColor => _g('borderBottomColor');
  void set borderBottomColor(v) {_s('borderBottomColor', v);}
  //@override
  String get borderBottomLeftRadius => _g('borderBottomLeftRadius');
  void set borderBottomLeftRadius(v) {_s('borderBottomLeftRadius', v);}
  //@override
  String get borderBottomRightRadius => _g('borderBottomRightRadius');
  void set borderBottomRightRadius(v) {_s('borderBottomRightRadius', v);}
  //@override
  String get borderBottomStyle => _g('borderBottomStyle');
  void set borderBottomStyle(v) {_s('borderBottomStyle', v);}
  //@override
  String get borderBottomWidth => _g('borderBottomWidth');
  void set borderBottomWidth(v) {_s('borderBottomWidth', v);}
  //@override
  String get borderCollapse => _g('borderCollapse');
  void set borderCollapse(v) {_s('borderCollapse', v);}
  //@override
  String get borderColor => _g('borderColor');
  void set borderColor(v) {_s('borderColor', v);}
  //@override
  String get borderEnd => _g('borderEnd');
  void set borderEnd(v) {_s('borderEnd', v);}
  //@override
  String get borderEndColor => _g('borderEndColor');
  void set borderEndColor(v) {_s('borderEndColor', v);}
  //@override
  String get borderEndStyle => _g('borderEndStyle');
  void set borderEndStyle(v) {_s('borderEndStyle', v);}
  //@override
  String get borderEndWidth => _g('borderEndWidth');
  void set borderEndWidth(v) {_s('borderEndWidth', v);}
  //@override
  String get borderFit => _g('borderFit');
  void set borderFit(v) {_s('borderFit', v);}
  //@override
  String get borderHorizontalSpacing => _g('borderHorizontalSpacing');
  void set borderHorizontalSpacing(v) {_s('borderHorizontalSpacing', v);}
  //@override
  String get borderImage => _g('borderImage');
  void set borderImage(v) {_s('borderImage', v);}
  //@override
  String get borderImageOutset => _g('borderImageOutset');
  void set borderImageOutset(v) {_s('borderImageOutset', v);}
  //@override
  String get borderImageRepeat => _g('borderImageRepeat');
  void set borderImageRepeat(v) {_s('borderImageRepeat', v);}
  //@override
  String get borderImageSlice => _g('borderImageSlice');
  void set borderImageSlice(v) {_s('borderImageSlice', v);}
  //@override
  String get borderImageSource => _g('borderImageSource');
  void set borderImageSource(v) {_s('borderImageSource', v);}
  //@override
  String get borderImageWidth => _g('borderImageWidth');
  void set borderImageWidth(v) {_s('borderImageWidth', v);}
  //@override
  String get borderLeft => _g('borderLeft');
  void set borderLeft(v) {_s('borderLeft', v);}
  //@override
  String get borderLeftColor => _g('borderLeftColor');
  void set borderLeftColor(v) {_s('borderLeftColor', v);}
  //@override
  String get borderLeftStyle => _g('borderLeftStyle');
  void set borderLeftStyle(v) {_s('borderLeftStyle', v);}
  //@override
  String get borderLeftWidth => _g('borderLeftWidth');
  void set borderLeftWidth(v) {_s('borderLeftWidth', v);}
  //@override
  String get borderRadius => _g('borderRadius');
  void set borderRadius(v) {_s('borderRadius', v);}
  //@override
  String get borderRight => _g('borderRight');
  void set borderRight(v) {_s('borderRight', v);}
  //@override
  String get borderRightColor => _g('borderRightColor');
  void set borderRightColor(v) {_s('borderRightColor', v);}
  //@override
  String get borderRightStyle => _g('borderRightStyle');
  void set borderRightStyle(v) {_s('borderRightStyle', v);}
  //@override
  String get borderRightWidth => _g('borderRightWidth');
  void set borderRightWidth(v) {_s('borderRightWidth', v);}
  //@override
  String get borderSpacing => _g('borderSpacing');
  void set borderSpacing(v) {_s('borderSpacing', v);}
  //@override
  String get borderStart => _g('borderStart');
  void set borderStart(v) {_s('borderStart', v);}
  //@override
  String get borderStartColor => _g('borderStartColor');
  void set borderStartColor(v) {_s('borderStartColor', v);}
  //@override
  String get borderStartStyle => _g('borderStartStyle');
  void set borderStartStyle(v) {_s('borderStartStyle', v);}
  //@override
  String get borderStartWidth => _g('borderStartWidth');
  void set borderStartWidth(v) {_s('borderStartWidth', v);}
  //@override
  String get borderStyle => _g('borderStyle');
  void set borderStyle(v) {_s('borderStyle', v);}
  //@override
  String get borderTop => _g('borderTop');
  void set borderTop(v) {_s('borderTop', v);}
  //@override
  String get borderTopColor => _g('borderTopColor');
  void set borderTopColor(v) {_s('borderTopColor', v);}
  //@override
  String get borderTopLeftRadius => _g('borderTopLeftRadius');
  void set borderTopLeftRadius(v) {_s('borderTopLeftRadius', v);}
  //@override
  String get borderTopRightRadius => _g('borderTopRightRadius');
  void set borderTopRightRadius(v) {_s('borderTopRightRadius', v);}
  //@override
  String get borderTopStyle => _g('borderTopStyle');
  void set borderTopStyle(v) {_s('borderTopStyle', v);}
  //@override
  String get borderTopWidth => _g('borderTopWidth');
  void set borderTopWidth(v) {_s('borderTopWidth', v);}
  //@override
  String get borderVerticalSpacing => _g('borderVerticalSpacing');
  void set borderVerticalSpacing(v) {_s('borderVerticalSpacing', v);}
  //@override
  String get borderWidth => _g('borderWidth');
  void set borderWidth(v) {_s('borderWidth', v);}
  //@override
  String get bottom => _g('bottom');
  void set bottom(v) {_s('bottom', v);}
  //@override
  String get boxAlign => _g('boxAlign');
  void set boxAlign(v) {_s('boxAlign', v);}
  //@override
  String get boxDecorationBreak => _g('boxDecorationBreak');
  void set boxDecorationBreak(v) {_s('boxDecorationBreak', v);}
  //@override
  String get boxDirection => _g('boxDirection');
  void set boxDirection(v) {_s('boxDirection', v);}
  //@override
  String get boxFlex => _g('boxFlex');
  void set boxFlex(v) {_s('boxFlex', v);}
  //@override
  String get boxFlexGroup => _g('boxFlexGroup');
  void set boxFlexGroup(v) {_s('boxFlexGroup', v);}
  //@override
  String get boxLines => _g('boxLines');
  void set boxLines(v) {_s('boxLines', v);}
  //@override
  String get boxOrdinalGroup => _g('boxOrdinalGroup');
  void set boxOrdinalGroup(v) {_s('boxOrdinalGroup', v);}
  //@override
  String get boxOrient => _g('boxOrient');
  void set boxOrient(v) {_s('boxOrient', v);}
  //@override
  String get boxPack => _g('boxPack');
  void set boxPack(v) {_s('boxPack', v);}
  //@override
  String get boxReflect => _g('boxReflect');
  void set boxReflect(v) {_s('boxReflect', v);}
  //@override
  String get boxShadow => _g('boxShadow');
  void set boxShadow(v) {_s('boxShadow', v);}
  //@override
  String get boxSizing => _g('boxSizing');
  void set boxSizing(v) {_s('boxSizing', v);}
  //@override
  String get captionSide => _g('captionSide');
  void set captionSide(v) {_s('captionSide', v);}
  //@override
  String get clear => _g('clear');
  void set clear(v) {_s('clear', v);}
  //@override
  String get clip => _g('clip');
  void set clip(v) {_s('clip', v);}
  //@override
  String get clipPath => _g('clipPath');
  void set clipPath(v) {_s('clipPath', v);}
  //@override
  String get color => _g('color');
  void set color(v) {_s('color', v);}
  //@override
  String get colorCorrection => _g('colorCorrection');
  void set colorCorrection(v) {_s('colorCorrection', v);}
  //@override
  String get columnAxis => _g('columnAxis');
  void set columnAxis(v) {_s('columnAxis', v);}
  //@override
  String get columnBreakAfter => _g('columnBreakAfter');
  void set columnBreakAfter(v) {_s('columnBreakAfter', v);}
  //@override
  String get columnBreakBefore => _g('columnBreakBefore');
  void set columnBreakBefore(v) {_s('columnBreakBefore', v);}
  //@override
  String get columnBreakInside => _g('columnBreakInside');
  void set columnBreakInside(v) {_s('columnBreakInside', v);}
  //@override
  String get columnCount => _g('columnCount');
  void set columnCount(v) {_s('columnCount', v);}
  //@override
  String get columnGap => _g('columnGap');
  void set columnGap(v) {_s('columnGap', v);}
  //@override
  String get columnProgression => _g('columnProgression');
  void set columnProgression(v) {_s('columnProgression', v);}
  //@override
  String get columnRule => _g('columnRule');
  void set columnRule(v) {_s('columnRule', v);}
  //@override
  String get columnRuleColor => _g('columnRuleColor');
  void set columnRuleColor(v) {_s('columnRuleColor', v);}
  //@override
  String get columnRuleStyle => _g('columnRuleStyle');
  void set columnRuleStyle(v) {_s('columnRuleStyle', v);}
  //@override
  String get columnRuleWidth => _g('columnRuleWidth');
  void set columnRuleWidth(v) {_s('columnRuleWidth', v);}
  //@override
  String get columnSpan => _g('columnSpan');
  void set columnSpan(v) {_s('columnSpan', v);}
  //@override
  String get columnWidth => _g('columnWidth');
  void set columnWidth(v) {_s('columnWidth', v);}
  //@override
  String get columns => _g('columns');
  void set columns(v) {_s('columns', v);}
  //@override
  String get content => _g('content');
  void set content(v) {_s('content', v);}
  //@override
  String get counterIncrement => _g('counterIncrement');
  void set counterIncrement(v) {_s('counterIncrement', v);}
  //@override
  String get counterReset => _g('counterReset');
  void set counterReset(v) {_s('counterReset', v);}
  //@override
  String get cursor => _g('cursor');
  void set cursor(v) {_s('cursor', v);}
  //@override
  String get dashboardRegion => _g('dashboardRegion');
  void set dashboardRegion(v) {_s('dashboardRegion', v);}
  //@override
  String get direction => _g('direction');
  void set direction(v) {_s('direction', v);}
  //@override
  String get display => _g('display');
  void set display(v) {_s('display', v);}
  //@override
  String get emptyCells => _g('emptyCells');
  void set emptyCells(v) {_s('emptyCells', v);}
  //@override
  String get filter => _g('filter');
  void set filter(v) {_s('filter', v);}
  //@override
  String get flex => _g('flex');
  void set flex(v) {_s('flex', v);}
  //@override
  String get flexAlign => _g('flexAlign');
  void set flexAlign(v) {_s('flexAlign', v);}
  //@override
  String get flexBasis => _g('flexBasis');
  void set flexBasis(v) {_s('flexBasis', v);}
  //@override
  String get flexDirection => _g('flexDirection');
  void set flexDirection(v) {_s('flexDirection', v);}
  //@override
  String get flexFlow => _g('flexFlow');
  void set flexFlow(v) {_s('flexFlow', v);}
  //@override
  String get flexGrow => _g('flexGrow');
  void set flexGrow(v) {_s('flexGrow', v);}
  //@override
  String get flexOrder => _g('flexOrder');
  void set flexOrder(v) {_s('flexOrder', v);}
  //@override
  String get flexPack => _g('flexPack');
  void set flexPack(v) {_s('flexPack', v);}
  //@override
  String get flexShrink => _g('flexShrink');
  void set flexShrink(v) {_s('flexShrink', v);}
  //@override
  String get flexWrap => _g('flexWrap');
  void set flexWrap(v) {_s('flexWrap', v);}
  //@override
  String get float => _g('float');
  void set float(v) {_s('float', v);}
  //@override
  String get flowFrom => _g('flowFrom');
  void set flowFrom(v) {_s('flowFrom', v);}
  //@override
  String get flowInto => _g('flowInto');
  void set flowInto(v) {_s('flowInto', v);}
  //@override
  String get font => _g('font');
  void set font(v) {_s('font', v);}
  //@override
  String get fontFamily => _g('fontFamily');
  void set fontFamily(v) {_s('fontFamily', v);}
  //@override
  String get fontFeatureSettings => _g('fontFeatureSettings');
  void set fontFeatureSettings(v) {_s('fontFeatureSettings', v);}
  //@override
  String get fontKerning => _g('fontKerning');
  void set fontKerning(v) {_s('fontKerning', v);}
  //@override
  String get fontSize => _g('fontSize');
  void set fontSize(v) {_s('fontSize', v);}
  //@override
  String get fontSizeDelta => _g('fontSizeDelta');
  void set fontSizeDelta(v) {_s('fontSizeDelta', v);}
  //@override
  String get fontSmoothing => _g('fontSmoothing');
  void set fontSmoothing(v) {_s('fontSmoothing', v);}
  //@override
  String get fontStretch => _g('fontStretch');
  void set fontStretch(v) {_s('fontStretch', v);}
  //@override
  String get fontStyle => _g('fontStyle');
  void set fontStyle(v) {_s('fontStyle', v);}
  //@override
  String get fontVariant => _g('fontVariant');
  void set fontVariant(v) {_s('fontVariant', v);}
  //@override
  String get fontVariantLigatures => _g('fontVariantLigatures');
  void set fontVariantLigatures(v) {_s('fontVariantLigatures', v);}
  //@override
  String get fontWeight => _g('fontWeight');
  void set fontWeight(v) {_s('fontWeight', v);}
  //@override
  String get gridColumn => _g('gridColumn');
  void set gridColumn(v) {_s('gridColumn', v);}
  //@override
  String get gridColumns => _g('gridColumns');
  void set gridColumns(v) {_s('gridColumns', v);}
  //@override
  String get gridRow => _g('gridRow');
  void set gridRow(v) {_s('gridRow', v);}
  //@override
  String get gridRows => _g('gridRows');
  void set gridRows(v) {_s('gridRows', v);}
  //@override
  String get height => _g('height');
  void set height(v) {_s('height', v);}
  //@override
  String get highlight => _g('highlight');
  void set highlight(v) {_s('highlight', v);}
  //@override
  String get hyphenateCharacter => _g('hyphenateCharacter');
  void set hyphenateCharacter(v) {_s('hyphenateCharacter', v);}
  //@override
  String get hyphenateLimitAfter => _g('hyphenateLimitAfter');
  void set hyphenateLimitAfter(v) {_s('hyphenateLimitAfter', v);}
  //@override
  String get hyphenateLimitBefore => _g('hyphenateLimitBefore');
  void set hyphenateLimitBefore(v) {_s('hyphenateLimitBefore', v);}
  //@override
  String get hyphenateLimitLines => _g('hyphenateLimitLines');
  void set hyphenateLimitLines(v) {_s('hyphenateLimitLines', v);}
  //@override
  String get hyphens => _g('hyphens');
  void set hyphens(v) {_s('hyphens', v);}
  //@override
  String get imageOrientation => _g('imageOrientation');
  void set imageOrientation(v) {_s('imageOrientation', v);}
  //@override
  String get imageRendering => _g('imageRendering');
  void set imageRendering(v) {_s('imageRendering', v);}
  //@override
  String get imageResolution => _g('imageResolution');
  void set imageResolution(v) {_s('imageResolution', v);}
  //@override
  String get justifyContent => _g('justifyContent');
  void set justifyContent(v) {_s('justifyContent', v);}
  //@override
  String get left => _g('left');
  void set left(v) {_s('left', v);}
  //@override
  String get letterSpacing => _g('letterSpacing');
  void set letterSpacing(v) {_s('letterSpacing', v);}
  //@override
  String get lineAlign => _g('lineAlign');
  void set lineAlign(v) {_s('lineAlign', v);}
  //@override
  String get lineBoxContain => _g('lineBoxContain');
  void set lineBoxContain(v) {_s('lineBoxContain', v);}
  //@override
  String get lineBreak => _g('lineBreak');
  void set lineBreak(v) {_s('lineBreak', v);}
  //@override
  String get lineClamp => _g('lineClamp');
  void set lineClamp(v) {_s('lineClamp', v);}
  //@override
  String get lineGrid => _g('lineGrid');
  void set lineGrid(v) {_s('lineGrid', v);}
  //@override
  String get lineHeight => _g('lineHeight');
  void set lineHeight(v) {_s('lineHeight', v);}
  //@override
  String get lineSnap => _g('lineSnap');
  void set lineSnap(v) {_s('lineSnap', v);}
  //@override
  String get listStyle => _g('listStyle');
  void set listStyle(v) {_s('listStyle', v);}
  //@override
  String get listStyleImage => _g('listStyleImage');
  void set listStyleImage(v) {_s('listStyleImage', v);}
  //@override
  String get listStylePosition => _g('listStylePosition');
  void set listStylePosition(v) {_s('listStylePosition', v);}
  //@override
  String get listStyleType => _g('listStyleType');
  void set listStyleType(v) {_s('listStyleType', v);}
  //@override
  String get locale => _g('locale');
  void set locale(v) {_s('locale', v);}
  //@override
  String get logicalHeight => _g('logicalHeight');
  void set logicalHeight(v) {_s('logicalHeight', v);}
  //@override
  String get logicalWidth => _g('logicalWidth');
  void set logicalWidth(v) {_s('logicalWidth', v);}
  //@override
  String get margin => _g('margin');
  void set margin(v) {_s('margin', v);}
  //@override
  String get marginAfter => _g('marginAfter');
  void set marginAfter(v) {_s('marginAfter', v);}
  //@override
  String get marginAfterCollapse => _g('marginAfterCollapse');
  void set marginAfterCollapse(v) {_s('marginAfterCollapse', v);}
  //@override
  String get marginBefore => _g('marginBefore');
  void set marginBefore(v) {_s('marginBefore', v);}
  //@override
  String get marginBeforeCollapse => _g('marginBeforeCollapse');
  void set marginBeforeCollapse(v) {_s('marginBeforeCollapse', v);}
  //@override
  String get marginBottom => _g('marginBottom');
  void set marginBottom(v) {_s('marginBottom', v);}
  //@override
  String get marginBottomCollapse => _g('marginBottomCollapse');
  void set marginBottomCollapse(v) {_s('marginBottomCollapse', v);}
  //@override
  String get marginCollapse => _g('marginCollapse');
  void set marginCollapse(v) {_s('marginCollapse', v);}
  //@override
  String get marginEnd => _g('marginEnd');
  void set marginEnd(v) {_s('marginEnd', v);}
  //@override
  String get marginLeft => _g('marginLeft');
  void set marginLeft(v) {_s('marginLeft', v);}
  //@override
  String get marginRight => _g('marginRight');
  void set marginRight(v) {_s('marginRight', v);}
  //@override
  String get marginStart => _g('marginStart');
  void set marginStart(v) {_s('marginStart', v);}
  //@override
  String get marginTop => _g('marginTop');
  void set marginTop(v) {_s('marginTop', v);}
  //@override
  String get marginTopCollapse => _g('marginTopCollapse');
  void set marginTopCollapse(v) {_s('marginTopCollapse', v);}
  //@override
  String get marquee => _g('marquee');
  void set marquee(v) {_s('marquee', v);}
  //@override
  String get marqueeDirection => _g('marqueeDirection');
  void set marqueeDirection(v) {_s('marqueeDirection', v);}
  //@override
  String get marqueeIncrement => _g('marqueeIncrement');
  void set marqueeIncrement(v) {_s('marqueeIncrement', v);}
  //@override
  String get marqueeRepetition => _g('marqueeRepetition');
  void set marqueeRepetition(v) {_s('marqueeRepetition', v);}
  //@override
  String get marqueeSpeed => _g('marqueeSpeed');
  void set marqueeSpeed(v) {_s('marqueeSpeed', v);}
  //@override
  String get marqueeStyle => _g('marqueeStyle');
  void set marqueeStyle(v) {_s('marqueeStyle', v);}
  //@override
  String get mask => _g('mask');
  void set mask(v) {_s('mask', v);}
  //@override
  String get maskAttachment => _g('maskAttachment');
  void set maskAttachment(v) {_s('maskAttachment', v);}
  //@override
  String get maskBoxImage => _g('maskBoxImage');
  void set maskBoxImage(v) {_s('maskBoxImage', v);}
  //@override
  String get maskBoxImageOutset => _g('maskBoxImageOutset');
  void set maskBoxImageOutset(v) {_s('maskBoxImageOutset', v);}
  //@override
  String get maskBoxImageRepeat => _g('maskBoxImageRepeat');
  void set maskBoxImageRepeat(v) {_s('maskBoxImageRepeat', v);}
  //@override
  String get maskBoxImageSlice => _g('maskBoxImageSlice');
  void set maskBoxImageSlice(v) {_s('maskBoxImageSlice', v);}
  //@override
  String get maskBoxImageSource => _g('maskBoxImageSource');
  void set maskBoxImageSource(v) {_s('maskBoxImageSource', v);}
  //@override
  String get maskBoxImageWidth => _g('maskBoxImageWidth');
  void set maskBoxImageWidth(v) {_s('maskBoxImageWidth', v);}
  //@override
  String get maskClip => _g('maskClip');
  void set maskClip(v) {_s('maskClip', v);}
  //@override
  String get maskComposite => _g('maskComposite');
  void set maskComposite(v) {_s('maskComposite', v);}
  //@override
  String get maskImage => _g('maskImage');
  void set maskImage(v) {_s('maskImage', v);}
  //@override
  String get maskOrigin => _g('maskOrigin');
  void set maskOrigin(v) {_s('maskOrigin', v);}
  //@override
  String get maskPosition => _g('maskPosition');
  void set maskPosition(v) {_s('maskPosition', v);}
  //@override
  String get maskPositionX => _g('maskPositionX');
  void set maskPositionX(v) {_s('maskPositionX', v);}
  //@override
  String get maskPositionY => _g('maskPositionY');
  void set maskPositionY(v) {_s('maskPositionY', v);}
  //@override
  String get maskRepeat => _g('maskRepeat');
  void set maskRepeat(v) {_s('maskRepeat', v);}
  //@override
  String get maskRepeatX => _g('maskRepeatX');
  void set maskRepeatX(v) {_s('maskRepeatX', v);}
  //@override
  String get maskRepeatY => _g('maskRepeatY');
  void set maskRepeatY(v) {_s('maskRepeatY', v);}
  //@override
  String get maskSize => _g('maskSize');
  void set maskSize(v) {_s('maskSize', v);}
  //@override
  String get matchNearestMailBlockquoteColor => _g('matchNearestMailBlockquoteColor');
  void set matchNearestMailBlockquoteColor(v) {_s('matchNearestMailBlockquoteColor', v);}
  //@override
  String get maxHeight => _g('maxHeight');
  void set maxHeight(v) {_s('maxHeight', v);}
  //@override
  String get maxLogicalHeight => _g('maxLogicalHeight');
  void set maxLogicalHeight(v) {_s('maxLogicalHeight', v);}
  //@override
  String get maxLogicalWidth => _g('maxLogicalWidth');
  void set maxLogicalWidth(v) {_s('maxLogicalWidth', v);}
  //@override
  String get maxWidth => _g('maxWidth');
  void set maxWidth(v) {_s('maxWidth', v);}
  //@override
  String get maxZoom => _g('maxZoom');
  void set maxZoom(v) {_s('maxZoom', v);}
  //@override
  String get minHeight => _g('minHeight');
  void set minHeight(v) {_s('minHeight', v);}
  //@override
  String get minLogicalHeight => _g('minLogicalHeight');
  void set minLogicalHeight(v) {_s('minLogicalHeight', v);}
  //@override
  String get minLogicalWidth => _g('minLogicalWidth');
  void set minLogicalWidth(v) {_s('minLogicalWidth', v);}
  //@override
  String get minWidth => _g('minWidth');
  void set minWidth(v) {_s('minWidth', v);}
  //@override
  String get minZoom => _g('minZoom');
  void set minZoom(v) {_s('minZoom', v);}
  //@override
  String get nbspMode => _g('nbspMode');
  void set nbspMode(v) {_s('nbspMode', v);}
  //@override
  String get opacity => _g('opacity');
  void set opacity(v) {_s('opacity', v);}
  //@override
  String get order => _g('order');
  void set order(v) {_s('order', v);}
  //@override
  String get orientation => _g('orientation');
  void set orientation(v) {_s('orientation', v);}
  //@override
  String get orphans => _g('orphans');
  void set orphans(v) {_s('orphans', v);}
  //@override
  String get outline => _g('outline');
  void set outline(v) {_s('outline', v);}
  //@override
  String get outlineColor => _g('outlineColor');
  void set outlineColor(v) {_s('outlineColor', v);}
  //@override
  String get outlineOffset => _g('outlineOffset');
  void set outlineOffset(v) {_s('outlineOffset', v);}
  //@override
  String get outlineStyle => _g('outlineStyle');
  void set outlineStyle(v) {_s('outlineStyle', v);}
  //@override
  String get outlineWidth => _g('outlineWidth');
  void set outlineWidth(v) {_s('outlineWidth', v);}
  //@override
  String get overflow => _g('overflow');
  void set overflow(v) {_s('overflow', v);}
  //@override
  String get overflowScrolling => _g('overflowScrolling');
  void set overflowScrolling(v) {_s('overflowScrolling', v);}
  //@override
  String get overflowWrap => _g('overflowWrap');
  void set overflowWrap(v) {_s('overflowWrap', v);}
  //@override
  String get overflowX => _g('overflowX');
  void set overflowX(v) {_s('overflowX', v);}
  //@override
  String get overflowY => _g('overflowY');
  void set overflowY(v) {_s('overflowY', v);}
  //@override
  String get padding => _g('padding');
  void set padding(v) {_s('padding', v);}
  //@override
  String get paddingAfter => _g('paddingAfter');
  void set paddingAfter(v) {_s('paddingAfter', v);}
  //@override
  String get paddingBefore => _g('paddingBefore');
  void set paddingBefore(v) {_s('paddingBefore', v);}
  //@override
  String get paddingBottom => _g('paddingBottom');
  void set paddingBottom(v) {_s('paddingBottom', v);}
  //@override
  String get paddingEnd => _g('paddingEnd');
  void set paddingEnd(v) {_s('paddingEnd', v);}
  //@override
  String get paddingLeft => _g('paddingLeft');
  void set paddingLeft(v) {_s('paddingLeft', v);}
  //@override
  String get paddingRight => _g('paddingRight');
  void set paddingRight(v) {_s('paddingRight', v);}
  //@override
  String get paddingStart => _g('paddingStart');
  void set paddingStart(v) {_s('paddingStart', v);}
  //@override
  String get paddingTop => _g('paddingTop');
  void set paddingTop(v) {_s('paddingTop', v);}
  //@override
  String get page => _g('page');
  void set page(v) {_s('page', v);}
  //@override
  String get pageBreakAfter => _g('pageBreakAfter');
  void set pageBreakAfter(v) {_s('pageBreakAfter', v);}
  //@override
  String get pageBreakBefore => _g('pageBreakBefore');
  void set pageBreakBefore(v) {_s('pageBreakBefore', v);}
  //@override
  String get pageBreakInside => _g('pageBreakInside');
  void set pageBreakInside(v) {_s('pageBreakInside', v);}
  //@override
  String get perspective => _g('perspective');
  void set perspective(v) {_s('perspective', v);}
  //@override
  String get perspectiveOrigin => _g('perspectiveOrigin');
  void set perspectiveOrigin(v) {_s('perspectiveOrigin', v);}
  //@override
  String get perspectiveOriginX => _g('perspectiveOriginX');
  void set perspectiveOriginX(v) {_s('perspectiveOriginX', v);}
  //@override
  String get perspectiveOriginY => _g('perspectiveOriginY');
  void set perspectiveOriginY(v) {_s('perspectiveOriginY', v);}
  //@override
  String get pointerEvents => _g('pointerEvents');
  void set pointerEvents(v) {_s('pointerEvents', v);}
  //@override
  String get position => _g('position');
  void set position(v) {_s('position', v);}
  //@override
  String get printColorAdjust => _g('printColorAdjust');
  void set printColorAdjust(v) {_s('printColorAdjust', v);}
  //@override
  String get quotes => _g('quotes');
  void set quotes(v) {_s('quotes', v);}
  //@override
  String get regionBreakAfter => _g('regionBreakAfter');
  void set regionBreakAfter(v) {_s('regionBreakAfter', v);}
  //@override
  String get regionBreakBefore => _g('regionBreakBefore');
  void set regionBreakBefore(v) {_s('regionBreakBefore', v);}
  //@override
  String get regionBreakInside => _g('regionBreakInside');
  void set regionBreakInside(v) {_s('regionBreakInside', v);}
  //@override
  String get regionOverflow => _g('regionOverflow');
  void set regionOverflow(v) {_s('regionOverflow', v);}
  //@override
  String get resize => _g('resize');
  void set resize(v) {_s('resize', v);}
  //@override
  String get right => _g('right');
  void set right(v) {_s('right', v);}
  //@override
  String get rtlOrdering => _g('rtlOrdering');
  void set rtlOrdering(v) {_s('rtlOrdering', v);}
  //@override
  String get shapeInside => _g('shapeInside');
  void set shapeInside(v) {_s('shapeInside', v);}
  //@override
  String get shapeMargin => _g('shapeMargin');
  void set shapeMargin(v) {_s('shapeMargin', v);}
  //@override
  String get shapeOutside => _g('shapeOutside');
  void set shapeOutside(v) {_s('shapeOutside', v);}
  //@override
  String get shapePadding => _g('shapePadding');
  void set shapePadding(v) {_s('shapePadding', v);}
  //@override
  String get size => _g('size');
  void set size(v) {_s('size', v);}
  //@override
  String get speak => _g('speak');
  void set speak(v) {_s('speak', v);}
  //@override
  String get src => _g('src');
  void set src(v) {_s('src', v);}
  //@override
  String get tableLayout => _g('tableLayout');
  void set tableLayout(v) {_s('tableLayout', v);}
  //@override
  String get tabSize => _g('tabSize');
  void set tabSize(v) {_s('tabSize', v);}
  //@override
  String get tapHighlightColor => _g('tapHighlightColor');
  void set tapHighlightColor(v) {_s('tapHighlightColor', v);}
  //@override
  String get textAlign => _g('textAlign');
  void set textAlign(v) {_s('textAlign', v);}
  //@override
  String get textAlignLast => _g('textAlignLast');
  void set textAlignLast(v) {_s('textAlignLast', v);}
  //@override
  String get textCombine => _g('textCombine');
  void set textCombine(v) {_s('textCombine', v);}
  //@override
  String get textDecoration => _g('textDecoration');
  void set textDecoration(v) {_s('textDecoration', v);}
  //@override
  String get textDecorationLine => _g('textDecorationLine');
  void set textDecorationLine(v) {_s('textDecorationLine', v);}
  //@override
  String get textDecorationsInEffect => _g('textDecorationsInEffect');
  void set textDecorationsInEffect(v) {_s('textDecorationsInEffect', v);}
  //@override
  String get textDecorationStyle => _g('textDecorationStyle');
  void set textDecorationStyle(v) {_s('textDecorationStyle', v);}
  //@override
  String get textEmphasis => _g('textEmphasis');
  void set textEmphasis(v) {_s('textEmphasis', v);}
  //@override
  String get textEmphasisColor => _g('textEmphasisColor');
  void set textEmphasisColor(v) {_s('textEmphasisColor', v);}
  //@override
  String get textEmphasisPosition => _g('textEmphasisPosition');
  void set textEmphasisPosition(v) {_s('textEmphasisPosition', v);}
  //@override
  String get textEmphasisStyle => _g('textEmphasisStyle');
  void set textEmphasisStyle(v) {_s('textEmphasisStyle', v);}
  //@override
  String get textFillColor => _g('textFillColor');
  void set textFillColor(v) {_s('textFillColor', v);}
  //@override
  String get textIndent => _g('textIndent');
  void set textIndent(v) {_s('textIndent', v);}
  //@override
  String get textLineThrough => _g('textLineThrough');
  void set textLineThrough(v) {_s('textLineThrough', v);}
  //@override
  String get textLineThroughColor => _g('textLineThroughColor');
  void set textLineThroughColor(v) {_s('textLineThroughColor', v);}
  //@override
  String get textLineThroughMode => _g('textLineThroughMode');
  void set textLineThroughMode(v) {_s('textLineThroughMode', v);}
  //@override
  String get textLineThroughStyle => _g('textLineThroughStyle');
  void set textLineThroughStyle(v) {_s('textLineThroughStyle', v);}
  //@override
  String get textLineThroughWidth => _g('textLineThroughWidth');
  void set textLineThroughWidth(v) {_s('textLineThroughWidth', v);}
  //@override
  String get textOrientation => _g('textOrientation');
  void set textOrientation(v) {_s('textOrientation', v);}
  //@override
  String get textOverflow => _g('textOverflow');
  void set textOverflow(v) {_s('textOverflow', v);}
  //@override
  String get textOverline => _g('textOverline');
  void set textOverline(v) {_s('textOverline', v);}
  //@override
  String get textOverlineColor => _g('textOverlineColor');
  void set textOverlineColor(v) {_s('textOverlineColor', v);}
  //@override
  String get textOverlineMode => _g('textOverlineMode');
  void set textOverlineMode(v) {_s('textOverlineMode', v);}
  //@override
  String get textOverlineStyle => _g('textOverlineStyle');
  void set textOverlineStyle(v) {_s('textOverlineStyle', v);}
  //@override
  String get textOverlineWidth => _g('textOverlineWidth');
  void set textOverlineWidth(v) {_s('textOverlineWidth', v);}
  //@override
  String get textRendering => _g('textRendering');
  void set textRendering(v) {_s('textRendering', v);}
  //@override
  String get textSecurity => _g('textSecurity');
  void set textSecurity(v) {_s('textSecurity', v);}
  //@override
  String get textShadow => _g('textShadow');
  void set textShadow(v) {_s('textShadow', v);}
  //@override
  String get textSizeAdjust => _g('textSizeAdjust');
  void set textSizeAdjust(v) {_s('textSizeAdjust', v);}
  //@override
  String get textStroke => _g('textStroke');
  void set textStroke(v) {_s('textStroke', v);}
  //@override
  String get textStrokeColor => _g('textStrokeColor');
  void set textStrokeColor(v) {_s('textStrokeColor', v);}
  //@override
  String get textStrokeWidth => _g('textStrokeWidth');
  void set textStrokeWidth(v) {_s('textStrokeWidth', v);}
  //@override
  String get textTransform => _g('textTransform');
  void set textTransform(v) {_s('textTransform', v);}
  //@override
  String get textUnderline => _g('textUnderline');
  void set textUnderline(v) {_s('textUnderline', v);}
  //@override
  String get textUnderlineColor => _g('textUnderlineColor');
  void set textUnderlineColor(v) {_s('textUnderlineColor', v);}
  //@override
  String get textUnderlineMode => _g('textUnderlineMode');
  void set textUnderlineMode(v) {_s('textUnderlineMode', v);}
  //@override
  String get textUnderlineStyle => _g('textUnderlineStyle');
  void set textUnderlineStyle(v) {_s('textUnderlineStyle', v);}
  //@override
  String get textUnderlineWidth => _g('textUnderlineWidth');
  void set textUnderlineWidth(v) {_s('textUnderlineWidth', v);}
  //@override
  String get top => _g('top');
  void set top(v) {_s('top', v);}
  //@override
  String get transform => _g('transform');
  void set transform(v) {_s('transform', v);}
  //@override
  String get transformOrigin => _g('transformOrigin');
  void set transformOrigin(v) {_s('transformOrigin', v);}
  //@override
  String get transformOriginX => _g('transformOriginX');
  void set transformOriginX(v) {_s('transformOriginX', v);}
  //@override
  String get transformOriginY => _g('transformOriginY');
  void set transformOriginY(v) {_s('transformOriginY', v);}
  //@override
  String get transformOriginZ => _g('transformOriginZ');
  void set transformOriginZ(v) {_s('transformOriginZ', v);}
  //@override
  String get transformStyle => _g('transformStyle');
  void set transformStyle(v) {_s('transformStyle', v);}
  //@override
  String get transition => _g('transition');
  void set transition(v) {_s('transition', v);}
  //@override
  String get transitionDelay => _g('transitionDelay');
  void set transitionDelay(v) {_s('transitionDelay', v);}
  //@override
  String get transitionDuration => _g('transitionDuration');
  void set transitionDuration(v) {_s('transitionDuration', v);}
  //@override
  String get transitionProperty => _g('transitionProperty');
  void set transitionProperty(v) {_s('transitionProperty', v);}
  //@override
  String get transitionTimingFunction => _g('transitionTimingFunction');
  void set transitionTimingFunction(v) {_s('transitionTimingFunction', v);}
  //@override
  String get unicodeBidi => _g('unicodeBidi');
  void set unicodeBidi(v) {_s('unicodeBidi', v);}
  //@override
  String get unicodeRange => _g('unicodeRange');
  void set unicodeRange(v) {_s('unicodeRange', v);}
  //@override
  String get userDrag => _g('userDrag');
  void set userDrag(v) {_s('userDrag', v);}
  //@override
  String get userModify => _g('userModify');
  void set userModify(v) {_s('userModify', v);}
  //@override
  String get userSelect => _g('userSelect');
  void set userSelect(v) {_s('userSelect', v);}
  //@override
  String get userZoom => _g('userZoom');
  void set userZoom(v) {_s('userZoom', v);}
  //@override
  String get verticalAlign => _g('verticalAlign');
  void set verticalAlign(v) {_s('verticalAlign', v);}
  //@override
  String get visibility => _g('visibility');
  void set visibility(v) {_s('visibility', v);}
  //@override
  String get whiteSpace => _g('whiteSpace');
  void set whiteSpace(v) {_s('whiteSpace', v);}
  //@override
  String get widows => _g('widows');
  void set widows(v) {_s('widows', v);}
  //@override
  String get width => _g('width');
  void set width(v) {_s('width', v);}
  //@override
  String get wordBreak => _g('wordBreak');
  void set wordBreak(v) {_s('wordBreak', v);}
  //@override
  String get wordSpacing => _g('wordSpacing');
  void set wordSpacing(v) {_s('wordSpacing', v);}
  //@override
  String get wordWrap => _g('wordWrap');
  void set wordWrap(v) {_s('wordWrap', v);}
  //@override
  String get wrap => _g('wrap');
  void set wrap(v) {_s('wrap', v);}
  //@override
  String get wrapFlow => _g('wrapFlow');
  void set wrapFlow(v) {_s('wrapFlow', v);}
  //@override
  String get wrapShape => _g('wrapShape');
  void set wrapShape(v) {_s('wrapShape', v);}
  //@override
  String get wrapThrough => _g('wrapThrough');
  void set wrapThrough(v) {_s('wrapThrough', v);}
  //@override
  String get writingMode => _g('writingMode');
  void set writingMode(v) {_s('writingMode', v);}
  //@override
  String get zIndex => _g('zIndex');
  void set zIndex(v) {_s('zIndex', v);}
  //@override
  String get zoom => _g('zoom');
  void set zoom(v) {_s('zoom', v);}
}
