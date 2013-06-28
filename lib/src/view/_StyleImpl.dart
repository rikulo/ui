// DO NOT EDIT
// Auto-generated
// Copyright (C) 2013 Potix Corporation. All Rights Reserved.
part of rikulo_view;

class _StyleImpl implements CssStyleDeclaration {
  final View _view;
  _StyleImpl(View this._view);

  CssStyleDeclaration get _st => _view.node.style;

  @override
  String getPropertyValue(String propertyName)
  => _st.getPropertyValue(propertyName);
  @override
  String removeProperty(String propertyName)
  => _st.removeProperty(propertyName);
  @override
  String getPropertyPriority(String propertyName)
  => _st.getPropertyPriority(propertyName);

  @override
  void setProperty(String propertyName, String value, [String priority]) {
    if (priority != null)
      _st.setProperty(propertyName, value, priority);
    else
      _st.setProperty(propertyName, value);
  }

  @override
  String get cssText => _st.cssText;
  @override
  void set cssText(String value) {
    final st = _st;
    st.cssText = value;

    var v;
    if ((v = st.left).isEmpty) //restore if not set
      st.left = CssUtil.px(_view.left);
    else
      _view.left = CssUtil.intOf(v);

    if ((v = st.top).isEmpty)
      st.top = CssUtil.px(_view.top);
    else
      _view.top = CssUtil.intOf(v);

    if ((v = st.width).isEmpty)
      st.width = CssUtil.px(_view.width);
    else
      _view.width = CssUtil.intOf(v, defaultValue: null);

    if ((v = st.height).isEmpty)
      st.height = CssUtil.px(_view.height);
    else
      _view.height = CssUtil.intOf(v, defaultValue: null);
  }

  @override
  int get length => _st.length;
  @override
  String item(int index) => _st.item(index);
  @override
  CssRule get parentRule => _st.parentRule;

  String get left => _st.left;
  void set left(String v) {_view.left = CssUtil.intOf(v);}
  String get top => _st.top;
  void set top(String v) {_view.top = CssUtil.intOf(v);}

  String get width => _st.width;
  void set width(String v) {
    _view.width = CssUtil.intOf(v, defaultValue: null);
  }
  String get height => _st.height;
  void set height(String v) {
    _view.height = CssUtil.intOf(v, defaultValue: null);
  }

  @override
  String get alignContent => _st.alignContent;
  @override
  void set alignContent(String v) {_st.alignContent = _s(v);}
  @override
  String get alignItems => _st.alignItems;
  @override
  void set alignItems(String v) {_st.alignItems = _s(v);}
  @override
  String get alignSelf => _st.alignSelf;
  @override
  void set alignSelf(String v) {_st.alignSelf = _s(v);}
  @override
  String get animation => _st.animation;
  @override
  void set animation(String v) {_st.animation = _s(v);}
  @override
  String get animationDelay => _st.animationDelay;
  @override
  void set animationDelay(String v) {_st.animationDelay = _s(v);}
  @override
  String get animationDirection => _st.animationDirection;
  @override
  void set animationDirection(String v) {_st.animationDirection = _s(v);}
  @override
  String get animationDuration => _st.animationDuration;
  @override
  void set animationDuration(String v) {_st.animationDuration = _s(v);}
  @override
  String get animationFillMode => _st.animationFillMode;
  @override
  void set animationFillMode(String v) {_st.animationFillMode = _s(v);}
  @override
  String get animationIterationCount => _st.animationIterationCount;
  @override
  void set animationIterationCount(String v) {_st.animationIterationCount = _s(v);}
  @override
  String get animationName => _st.animationName;
  @override
  void set animationName(String v) {_st.animationName = _s(v);}
  @override
  String get animationPlayState => _st.animationPlayState;
  @override
  void set animationPlayState(String v) {_st.animationPlayState = _s(v);}
  @override
  String get animationTimingFunction => _st.animationTimingFunction;
  @override
  void set animationTimingFunction(String v) {_st.animationTimingFunction = _s(v);}
  @override
  String get appearance => _st.appearance;
  @override
  void set appearance(String v) {_st.appearance = _s(v);}
  @override
  String get appRegion => _st.appRegion;
  @override
  void set appRegion(String v) {_st.appRegion = _s(v);}
  @override
  String get aspectRatio => _st.aspectRatio;
  @override
  void set aspectRatio(String v) {_st.aspectRatio = _s(v);}
  @override
  String get backfaceVisibility => _st.backfaceVisibility;
  @override
  void set backfaceVisibility(String v) {_st.backfaceVisibility = _s(v);}
  @override
  String get background => _st.background;
  @override
  void set background(String v) {_st.background = _s(v);}
  @override
  String get backgroundAttachment => _st.backgroundAttachment;
  @override
  void set backgroundAttachment(String v) {_st.backgroundAttachment = _s(v);}
  @override
  String get backgroundClip => _st.backgroundClip;
  @override
  void set backgroundClip(String v) {_st.backgroundClip = _s(v);}
  @override
  String get backgroundColor => _st.backgroundColor;
  @override
  void set backgroundColor(String v) {_st.backgroundColor = _s(v);}
  @override
  String get backgroundComposite => _st.backgroundComposite;
  @override
  void set backgroundComposite(String v) {_st.backgroundComposite = _s(v);}
  @override
  String get backgroundImage => _st.backgroundImage;
  @override
  void set backgroundImage(String v) {_st.backgroundImage = _s(v);}
  @override
  String get backgroundOrigin => _st.backgroundOrigin;
  @override
  void set backgroundOrigin(String v) {_st.backgroundOrigin = _s(v);}
  @override
  String get backgroundPosition => _st.backgroundPosition;
  @override
  void set backgroundPosition(String v) {_st.backgroundPosition = _s(v);}
  @override
  String get backgroundPositionX => _st.backgroundPositionX;
  @override
  void set backgroundPositionX(String v) {_st.backgroundPositionX = _s(v);}
  @override
  String get backgroundPositionY => _st.backgroundPositionY;
  @override
  void set backgroundPositionY(String v) {_st.backgroundPositionY = _s(v);}
  @override
  String get backgroundRepeat => _st.backgroundRepeat;
  @override
  void set backgroundRepeat(String v) {_st.backgroundRepeat = _s(v);}
  @override
  String get backgroundRepeatX => _st.backgroundRepeatX;
  @override
  void set backgroundRepeatX(String v) {_st.backgroundRepeatX = _s(v);}
  @override
  String get backgroundRepeatY => _st.backgroundRepeatY;
  @override
  void set backgroundRepeatY(String v) {_st.backgroundRepeatY = _s(v);}
  @override
  String get backgroundSize => _st.backgroundSize;
  @override
  void set backgroundSize(String v) {_st.backgroundSize = _s(v);}
  @override
  String get blendMode => _st.blendMode;
  @override
  void set blendMode(String v) {_st.blendMode = _s(v);}
  @override
  String get border => _st.border;
  @override
  void set border(String v) {_st.border = _s(v);}
  @override
  String get borderAfter => _st.borderAfter;
  @override
  void set borderAfter(String v) {_st.borderAfter = _s(v);}
  @override
  String get borderAfterColor => _st.borderAfterColor;
  @override
  void set borderAfterColor(String v) {_st.borderAfterColor = _s(v);}
  @override
  String get borderAfterStyle => _st.borderAfterStyle;
  @override
  void set borderAfterStyle(String v) {_st.borderAfterStyle = _s(v);}
  @override
  String get borderAfterWidth => _st.borderAfterWidth;
  @override
  void set borderAfterWidth(String v) {_st.borderAfterWidth = _s(v);}
  @override
  String get borderBefore => _st.borderBefore;
  @override
  void set borderBefore(String v) {_st.borderBefore = _s(v);}
  @override
  String get borderBeforeColor => _st.borderBeforeColor;
  @override
  void set borderBeforeColor(String v) {_st.borderBeforeColor = _s(v);}
  @override
  String get borderBeforeStyle => _st.borderBeforeStyle;
  @override
  void set borderBeforeStyle(String v) {_st.borderBeforeStyle = _s(v);}
  @override
  String get borderBeforeWidth => _st.borderBeforeWidth;
  @override
  void set borderBeforeWidth(String v) {_st.borderBeforeWidth = _s(v);}
  @override
  String get borderBottom => _st.borderBottom;
  @override
  void set borderBottom(String v) {_st.borderBottom = _s(v);}
  @override
  String get borderBottomColor => _st.borderBottomColor;
  @override
  void set borderBottomColor(String v) {_st.borderBottomColor = _s(v);}
  @override
  String get borderBottomLeftRadius => _st.borderBottomLeftRadius;
  @override
  void set borderBottomLeftRadius(String v) {_st.borderBottomLeftRadius = _s(v);}
  @override
  String get borderBottomRightRadius => _st.borderBottomRightRadius;
  @override
  void set borderBottomRightRadius(String v) {_st.borderBottomRightRadius = _s(v);}
  @override
  String get borderBottomStyle => _st.borderBottomStyle;
  @override
  void set borderBottomStyle(String v) {_st.borderBottomStyle = _s(v);}
  @override
  String get borderBottomWidth => _st.borderBottomWidth;
  @override
  void set borderBottomWidth(String v) {_st.borderBottomWidth = _s(v);}
  @override
  String get borderCollapse => _st.borderCollapse;
  @override
  void set borderCollapse(String v) {_st.borderCollapse = _s(v);}
  @override
  String get borderColor => _st.borderColor;
  @override
  void set borderColor(String v) {_st.borderColor = _s(v);}
  @override
  String get borderEnd => _st.borderEnd;
  @override
  void set borderEnd(String v) {_st.borderEnd = _s(v);}
  @override
  String get borderEndColor => _st.borderEndColor;
  @override
  void set borderEndColor(String v) {_st.borderEndColor = _s(v);}
  @override
  String get borderEndStyle => _st.borderEndStyle;
  @override
  void set borderEndStyle(String v) {_st.borderEndStyle = _s(v);}
  @override
  String get borderEndWidth => _st.borderEndWidth;
  @override
  void set borderEndWidth(String v) {_st.borderEndWidth = _s(v);}
  @override
  String get borderFit => _st.borderFit;
  @override
  void set borderFit(String v) {_st.borderFit = _s(v);}
  @override
  String get borderHorizontalSpacing => _st.borderHorizontalSpacing;
  @override
  void set borderHorizontalSpacing(String v) {_st.borderHorizontalSpacing = _s(v);}
  @override
  String get borderImage => _st.borderImage;
  @override
  void set borderImage(String v) {_st.borderImage = _s(v);}
  @override
  String get borderImageOutset => _st.borderImageOutset;
  @override
  void set borderImageOutset(String v) {_st.borderImageOutset = _s(v);}
  @override
  String get borderImageRepeat => _st.borderImageRepeat;
  @override
  void set borderImageRepeat(String v) {_st.borderImageRepeat = _s(v);}
  @override
  String get borderImageSlice => _st.borderImageSlice;
  @override
  void set borderImageSlice(String v) {_st.borderImageSlice = _s(v);}
  @override
  String get borderImageSource => _st.borderImageSource;
  @override
  void set borderImageSource(String v) {_st.borderImageSource = _s(v);}
  @override
  String get borderImageWidth => _st.borderImageWidth;
  @override
  void set borderImageWidth(String v) {_st.borderImageWidth = _s(v);}
  @override
  String get borderLeft => _st.borderLeft;
  @override
  void set borderLeft(String v) {_st.borderLeft = _s(v);}
  @override
  String get borderLeftColor => _st.borderLeftColor;
  @override
  void set borderLeftColor(String v) {_st.borderLeftColor = _s(v);}
  @override
  String get borderLeftStyle => _st.borderLeftStyle;
  @override
  void set borderLeftStyle(String v) {_st.borderLeftStyle = _s(v);}
  @override
  String get borderLeftWidth => _st.borderLeftWidth;
  @override
  void set borderLeftWidth(String v) {_st.borderLeftWidth = _s(v);}
  @override
  String get borderRadius => _st.borderRadius;
  @override
  void set borderRadius(String v) {_st.borderRadius = _s(v);}
  @override
  String get borderRight => _st.borderRight;
  @override
  void set borderRight(String v) {_st.borderRight = _s(v);}
  @override
  String get borderRightColor => _st.borderRightColor;
  @override
  void set borderRightColor(String v) {_st.borderRightColor = _s(v);}
  @override
  String get borderRightStyle => _st.borderRightStyle;
  @override
  void set borderRightStyle(String v) {_st.borderRightStyle = _s(v);}
  @override
  String get borderRightWidth => _st.borderRightWidth;
  @override
  void set borderRightWidth(String v) {_st.borderRightWidth = _s(v);}
  @override
  String get borderSpacing => _st.borderSpacing;
  @override
  void set borderSpacing(String v) {_st.borderSpacing = _s(v);}
  @override
  String get borderStart => _st.borderStart;
  @override
  void set borderStart(String v) {_st.borderStart = _s(v);}
  @override
  String get borderStartColor => _st.borderStartColor;
  @override
  void set borderStartColor(String v) {_st.borderStartColor = _s(v);}
  @override
  String get borderStartStyle => _st.borderStartStyle;
  @override
  void set borderStartStyle(String v) {_st.borderStartStyle = _s(v);}
  @override
  String get borderStartWidth => _st.borderStartWidth;
  @override
  void set borderStartWidth(String v) {_st.borderStartWidth = _s(v);}
  @override
  String get borderStyle => _st.borderStyle;
  @override
  void set borderStyle(String v) {_st.borderStyle = _s(v);}
  @override
  String get borderTop => _st.borderTop;
  @override
  void set borderTop(String v) {_st.borderTop = _s(v);}
  @override
  String get borderTopColor => _st.borderTopColor;
  @override
  void set borderTopColor(String v) {_st.borderTopColor = _s(v);}
  @override
  String get borderTopLeftRadius => _st.borderTopLeftRadius;
  @override
  void set borderTopLeftRadius(String v) {_st.borderTopLeftRadius = _s(v);}
  @override
  String get borderTopRightRadius => _st.borderTopRightRadius;
  @override
  void set borderTopRightRadius(String v) {_st.borderTopRightRadius = _s(v);}
  @override
  String get borderTopStyle => _st.borderTopStyle;
  @override
  void set borderTopStyle(String v) {_st.borderTopStyle = _s(v);}
  @override
  String get borderTopWidth => _st.borderTopWidth;
  @override
  void set borderTopWidth(String v) {_st.borderTopWidth = _s(v);}
  @override
  String get borderVerticalSpacing => _st.borderVerticalSpacing;
  @override
  void set borderVerticalSpacing(String v) {_st.borderVerticalSpacing = _s(v);}
  @override
  String get borderWidth => _st.borderWidth;
  @override
  void set borderWidth(String v) {_st.borderWidth = _s(v);}
  @override
  String get bottom => _st.bottom;
  @override
  void set bottom(String v) {_st.bottom = _s(v);}
  @override
  String get boxAlign => _st.boxAlign;
  @override
  void set boxAlign(String v) {_st.boxAlign = _s(v);}
  @override
  String get boxDecorationBreak => _st.boxDecorationBreak;
  @override
  void set boxDecorationBreak(String v) {_st.boxDecorationBreak = _s(v);}
  @override
  String get boxDirection => _st.boxDirection;
  @override
  void set boxDirection(String v) {_st.boxDirection = _s(v);}
  @override
  String get boxFlex => _st.boxFlex;
  @override
  void set boxFlex(String v) {_st.boxFlex = _s(v);}
  @override
  String get boxFlexGroup => _st.boxFlexGroup;
  @override
  void set boxFlexGroup(String v) {_st.boxFlexGroup = _s(v);}
  @override
  String get boxLines => _st.boxLines;
  @override
  void set boxLines(String v) {_st.boxLines = _s(v);}
  @override
  String get boxOrdinalGroup => _st.boxOrdinalGroup;
  @override
  void set boxOrdinalGroup(String v) {_st.boxOrdinalGroup = _s(v);}
  @override
  String get boxOrient => _st.boxOrient;
  @override
  void set boxOrient(String v) {_st.boxOrient = _s(v);}
  @override
  String get boxPack => _st.boxPack;
  @override
  void set boxPack(String v) {_st.boxPack = _s(v);}
  @override
  String get boxReflect => _st.boxReflect;
  @override
  void set boxReflect(String v) {_st.boxReflect = _s(v);}
  @override
  String get boxShadow => _st.boxShadow;
  @override
  void set boxShadow(String v) {_st.boxShadow = _s(v);}
  @override
  String get boxSizing => _st.boxSizing;
  @override
  void set boxSizing(String v) {_st.boxSizing = _s(v);}
  @override
  String get captionSide => _st.captionSide;
  @override
  void set captionSide(String v) {_st.captionSide = _s(v);}
  @override
  String get clear => _st.clear;
  @override
  void set clear(String v) {_st.clear = _s(v);}
  @override
  String get clip => _st.clip;
  @override
  void set clip(String v) {_st.clip = _s(v);}
  @override
  String get clipPath => _st.clipPath;
  @override
  void set clipPath(String v) {_st.clipPath = _s(v);}
  @override
  String get color => _st.color;
  @override
  void set color(String v) {_st.color = _s(v);}
  @override
  String get colorCorrection => _st.colorCorrection;
  @override
  void set colorCorrection(String v) {_st.colorCorrection = _s(v);}
  @override
  String get columnAxis => _st.columnAxis;
  @override
  void set columnAxis(String v) {_st.columnAxis = _s(v);}
  @override
  String get columnBreakAfter => _st.columnBreakAfter;
  @override
  void set columnBreakAfter(String v) {_st.columnBreakAfter = _s(v);}
  @override
  String get columnBreakBefore => _st.columnBreakBefore;
  @override
  void set columnBreakBefore(String v) {_st.columnBreakBefore = _s(v);}
  @override
  String get columnBreakInside => _st.columnBreakInside;
  @override
  void set columnBreakInside(String v) {_st.columnBreakInside = _s(v);}
  @override
  String get columnCount => _st.columnCount;
  @override
  void set columnCount(String v) {_st.columnCount = _s(v);}
  @override
  String get columnGap => _st.columnGap;
  @override
  void set columnGap(String v) {_st.columnGap = _s(v);}
  @override
  String get columnProgression => _st.columnProgression;
  @override
  void set columnProgression(String v) {_st.columnProgression = _s(v);}
  @override
  String get columnRule => _st.columnRule;
  @override
  void set columnRule(String v) {_st.columnRule = _s(v);}
  @override
  String get columnRuleColor => _st.columnRuleColor;
  @override
  void set columnRuleColor(String v) {_st.columnRuleColor = _s(v);}
  @override
  String get columnRuleStyle => _st.columnRuleStyle;
  @override
  void set columnRuleStyle(String v) {_st.columnRuleStyle = _s(v);}
  @override
  String get columnRuleWidth => _st.columnRuleWidth;
  @override
  void set columnRuleWidth(String v) {_st.columnRuleWidth = _s(v);}
  @override
  String get columnSpan => _st.columnSpan;
  @override
  void set columnSpan(String v) {_st.columnSpan = _s(v);}
  @override
  String get columnWidth => _st.columnWidth;
  @override
  void set columnWidth(String v) {_st.columnWidth = _s(v);}
  @override
  String get columns => _st.columns;
  @override
  void set columns(String v) {_st.columns = _s(v);}
  @override
  String get content => _st.content;
  @override
  void set content(String v) {_st.content = _s(v);}
  @override
  String get counterIncrement => _st.counterIncrement;
  @override
  void set counterIncrement(String v) {_st.counterIncrement = _s(v);}
  @override
  String get counterReset => _st.counterReset;
  @override
  void set counterReset(String v) {_st.counterReset = _s(v);}
  @override
  String get cursor => _st.cursor;
  @override
  void set cursor(String v) {_st.cursor = _s(v);}
  @override
  String get dashboardRegion => _st.dashboardRegion;
  @override
  void set dashboardRegion(String v) {_st.dashboardRegion = _s(v);}
  @override
  String get direction => _st.direction;
  @override
  void set direction(String v) {_st.direction = _s(v);}
  @override
  String get display => _st.display;
  @override
  void set display(String v) {_st.display = _s(v);}
  @override
  String get emptyCells => _st.emptyCells;
  @override
  void set emptyCells(String v) {_st.emptyCells = _s(v);}
  @override
  String get filter => _st.filter;
  @override
  void set filter(String v) {_st.filter = _s(v);}
  @override
  String get flex => _st.flex;
  @override
  void set flex(String v) {_st.flex = _s(v);}
  @override
  String get flexBasis => _st.flexBasis;
  @override
  void set flexBasis(String v) {_st.flexBasis = _s(v);}
  @override
  String get flexDirection => _st.flexDirection;
  @override
  void set flexDirection(String v) {_st.flexDirection = _s(v);}
  @override
  String get flexFlow => _st.flexFlow;
  @override
  void set flexFlow(String v) {_st.flexFlow = _s(v);}
  @override
  String get flexGrow => _st.flexGrow;
  @override
  void set flexGrow(String v) {_st.flexGrow = _s(v);}
  @override
  String get flexShrink => _st.flexShrink;
  @override
  void set flexShrink(String v) {_st.flexShrink = _s(v);}
  @override
  String get flexWrap => _st.flexWrap;
  @override
  void set flexWrap(String v) {_st.flexWrap = _s(v);}
  @override
  String get float => _st.float;
  @override
  void set float(String v) {_st.float = _s(v);}
  @override
  String get flowFrom => _st.flowFrom;
  @override
  void set flowFrom(String v) {_st.flowFrom = _s(v);}
  @override
  String get flowInto => _st.flowInto;
  @override
  void set flowInto(String v) {_st.flowInto = _s(v);}
  @override
  String get font => _st.font;
  @override
  void set font(String v) {_st.font = _s(v);}
  @override
  String get fontFamily => _st.fontFamily;
  @override
  void set fontFamily(String v) {_st.fontFamily = _s(v);}
  @override
  String get fontFeatureSettings => _st.fontFeatureSettings;
  @override
  void set fontFeatureSettings(String v) {_st.fontFeatureSettings = _s(v);}
  @override
  String get fontKerning => _st.fontKerning;
  @override
  void set fontKerning(String v) {_st.fontKerning = _s(v);}
  @override
  String get fontSize => _st.fontSize;
  @override
  void set fontSize(String v) {_st.fontSize = _s(v);}
  @override
  String get fontSizeDelta => _st.fontSizeDelta;
  @override
  void set fontSizeDelta(String v) {_st.fontSizeDelta = _s(v);}
  @override
  String get fontSmoothing => _st.fontSmoothing;
  @override
  void set fontSmoothing(String v) {_st.fontSmoothing = _s(v);}
  @override
  String get fontStretch => _st.fontStretch;
  @override
  void set fontStretch(String v) {_st.fontStretch = _s(v);}
  @override
  String get fontStyle => _st.fontStyle;
  @override
  void set fontStyle(String v) {_st.fontStyle = _s(v);}
  @override
  String get fontVariant => _st.fontVariant;
  @override
  void set fontVariant(String v) {_st.fontVariant = _s(v);}
  @override
  String get fontVariantLigatures => _st.fontVariantLigatures;
  @override
  void set fontVariantLigatures(String v) {_st.fontVariantLigatures = _s(v);}
  @override
  String get fontWeight => _st.fontWeight;
  @override
  void set fontWeight(String v) {_st.fontWeight = _s(v);}
  @override
  String get gridColumn => _st.gridColumn;
  @override
  void set gridColumn(String v) {_st.gridColumn = _s(v);}
  @override
  String get gridColumns => _st.gridColumns;
  @override
  void set gridColumns(String v) {_st.gridColumns = _s(v);}
  @override
  String get gridRow => _st.gridRow;
  @override
  void set gridRow(String v) {_st.gridRow = _s(v);}
  @override
  String get gridRows => _st.gridRows;
  @override
  void set gridRows(String v) {_st.gridRows = _s(v);}
  @override
  String get highlight => _st.highlight;
  @override
  void set highlight(String v) {_st.highlight = _s(v);}
  @override
  String get hyphenateCharacter => _st.hyphenateCharacter;
  @override
  void set hyphenateCharacter(String v) {_st.hyphenateCharacter = _s(v);}
  @override
  String get hyphenateLimitAfter => _st.hyphenateLimitAfter;
  @override
  void set hyphenateLimitAfter(String v) {_st.hyphenateLimitAfter = _s(v);}
  @override
  String get hyphenateLimitBefore => _st.hyphenateLimitBefore;
  @override
  void set hyphenateLimitBefore(String v) {_st.hyphenateLimitBefore = _s(v);}
  @override
  String get hyphenateLimitLines => _st.hyphenateLimitLines;
  @override
  void set hyphenateLimitLines(String v) {_st.hyphenateLimitLines = _s(v);}
  @override
  String get hyphens => _st.hyphens;
  @override
  void set hyphens(String v) {_st.hyphens = _s(v);}
  @override
  String get imageOrientation => _st.imageOrientation;
  @override
  void set imageOrientation(String v) {_st.imageOrientation = _s(v);}
  @override
  String get imageRendering => _st.imageRendering;
  @override
  void set imageRendering(String v) {_st.imageRendering = _s(v);}
  @override
  String get imageResolution => _st.imageResolution;
  @override
  void set imageResolution(String v) {_st.imageResolution = _s(v);}
  @override
  String get justifyContent => _st.justifyContent;
  @override
  void set justifyContent(String v) {_st.justifyContent = _s(v);}
  @override
  String get letterSpacing => _st.letterSpacing;
  @override
  void set letterSpacing(String v) {_st.letterSpacing = _s(v);}
  @override
  String get lineAlign => _st.lineAlign;
  @override
  void set lineAlign(String v) {_st.lineAlign = _s(v);}
  @override
  String get lineBoxContain => _st.lineBoxContain;
  @override
  void set lineBoxContain(String v) {_st.lineBoxContain = _s(v);}
  @override
  String get lineBreak => _st.lineBreak;
  @override
  void set lineBreak(String v) {_st.lineBreak = _s(v);}
  @override
  String get lineClamp => _st.lineClamp;
  @override
  void set lineClamp(String v) {_st.lineClamp = _s(v);}
  @override
  String get lineGrid => _st.lineGrid;
  @override
  void set lineGrid(String v) {_st.lineGrid = _s(v);}
  @override
  String get lineHeight => _st.lineHeight;
  @override
  void set lineHeight(String v) {_st.lineHeight = _s(v);}
  @override
  String get lineSnap => _st.lineSnap;
  @override
  void set lineSnap(String v) {_st.lineSnap = _s(v);}
  @override
  String get listStyle => _st.listStyle;
  @override
  void set listStyle(String v) {_st.listStyle = _s(v);}
  @override
  String get listStyleImage => _st.listStyleImage;
  @override
  void set listStyleImage(String v) {_st.listStyleImage = _s(v);}
  @override
  String get listStylePosition => _st.listStylePosition;
  @override
  void set listStylePosition(String v) {_st.listStylePosition = _s(v);}
  @override
  String get listStyleType => _st.listStyleType;
  @override
  void set listStyleType(String v) {_st.listStyleType = _s(v);}
  @override
  String get locale => _st.locale;
  @override
  void set locale(String v) {_st.locale = _s(v);}
  @override
  String get logicalHeight => _st.logicalHeight;
  @override
  void set logicalHeight(String v) {_st.logicalHeight = _s(v);}
  @override
  String get logicalWidth => _st.logicalWidth;
  @override
  void set logicalWidth(String v) {_st.logicalWidth = _s(v);}
  @override
  String get margin => _st.margin;
  @override
  void set margin(String v) {_st.margin = _s(v);}
  @override
  String get marginAfter => _st.marginAfter;
  @override
  void set marginAfter(String v) {_st.marginAfter = _s(v);}
  @override
  String get marginAfterCollapse => _st.marginAfterCollapse;
  @override
  void set marginAfterCollapse(String v) {_st.marginAfterCollapse = _s(v);}
  @override
  String get marginBefore => _st.marginBefore;
  @override
  void set marginBefore(String v) {_st.marginBefore = _s(v);}
  @override
  String get marginBeforeCollapse => _st.marginBeforeCollapse;
  @override
  void set marginBeforeCollapse(String v) {_st.marginBeforeCollapse = _s(v);}
  @override
  String get marginBottom => _st.marginBottom;
  @override
  void set marginBottom(String v) {_st.marginBottom = _s(v);}
  @override
  String get marginBottomCollapse => _st.marginBottomCollapse;
  @override
  void set marginBottomCollapse(String v) {_st.marginBottomCollapse = _s(v);}
  @override
  String get marginCollapse => _st.marginCollapse;
  @override
  void set marginCollapse(String v) {_st.marginCollapse = _s(v);}
  @override
  String get marginEnd => _st.marginEnd;
  @override
  void set marginEnd(String v) {_st.marginEnd = _s(v);}
  @override
  String get marginLeft => _st.marginLeft;
  @override
  void set marginLeft(String v) {_st.marginLeft = _s(v);}
  @override
  String get marginRight => _st.marginRight;
  @override
  void set marginRight(String v) {_st.marginRight = _s(v);}
  @override
  String get marginStart => _st.marginStart;
  @override
  void set marginStart(String v) {_st.marginStart = _s(v);}
  @override
  String get marginTop => _st.marginTop;
  @override
  void set marginTop(String v) {_st.marginTop = _s(v);}
  @override
  String get marginTopCollapse => _st.marginTopCollapse;
  @override
  void set marginTopCollapse(String v) {_st.marginTopCollapse = _s(v);}
  @override
  String get marquee => _st.marquee;
  @override
  void set marquee(String v) {_st.marquee = _s(v);}
  @override
  String get marqueeDirection => _st.marqueeDirection;
  @override
  void set marqueeDirection(String v) {_st.marqueeDirection = _s(v);}
  @override
  String get marqueeIncrement => _st.marqueeIncrement;
  @override
  void set marqueeIncrement(String v) {_st.marqueeIncrement = _s(v);}
  @override
  String get marqueeRepetition => _st.marqueeRepetition;
  @override
  void set marqueeRepetition(String v) {_st.marqueeRepetition = _s(v);}
  @override
  String get marqueeSpeed => _st.marqueeSpeed;
  @override
  void set marqueeSpeed(String v) {_st.marqueeSpeed = _s(v);}
  @override
  String get marqueeStyle => _st.marqueeStyle;
  @override
  void set marqueeStyle(String v) {_st.marqueeStyle = _s(v);}
  @override
  String get mask => _st.mask;
  @override
  void set mask(String v) {_st.mask = _s(v);}
  @override
  String get maskAttachment => _st.maskAttachment;
  @override
  void set maskAttachment(String v) {_st.maskAttachment = _s(v);}
  @override
  String get maskBoxImage => _st.maskBoxImage;
  @override
  void set maskBoxImage(String v) {_st.maskBoxImage = _s(v);}
  @override
  String get maskBoxImageOutset => _st.maskBoxImageOutset;
  @override
  void set maskBoxImageOutset(String v) {_st.maskBoxImageOutset = _s(v);}
  @override
  String get maskBoxImageRepeat => _st.maskBoxImageRepeat;
  @override
  void set maskBoxImageRepeat(String v) {_st.maskBoxImageRepeat = _s(v);}
  @override
  String get maskBoxImageSlice => _st.maskBoxImageSlice;
  @override
  void set maskBoxImageSlice(String v) {_st.maskBoxImageSlice = _s(v);}
  @override
  String get maskBoxImageSource => _st.maskBoxImageSource;
  @override
  void set maskBoxImageSource(String v) {_st.maskBoxImageSource = _s(v);}
  @override
  String get maskBoxImageWidth => _st.maskBoxImageWidth;
  @override
  void set maskBoxImageWidth(String v) {_st.maskBoxImageWidth = _s(v);}
  @override
  String get maskClip => _st.maskClip;
  @override
  void set maskClip(String v) {_st.maskClip = _s(v);}
  @override
  String get maskComposite => _st.maskComposite;
  @override
  void set maskComposite(String v) {_st.maskComposite = _s(v);}
  @override
  String get maskImage => _st.maskImage;
  @override
  void set maskImage(String v) {_st.maskImage = _s(v);}
  @override
  String get maskOrigin => _st.maskOrigin;
  @override
  void set maskOrigin(String v) {_st.maskOrigin = _s(v);}
  @override
  String get maskPosition => _st.maskPosition;
  @override
  void set maskPosition(String v) {_st.maskPosition = _s(v);}
  @override
  String get maskPositionX => _st.maskPositionX;
  @override
  void set maskPositionX(String v) {_st.maskPositionX = _s(v);}
  @override
  String get maskPositionY => _st.maskPositionY;
  @override
  void set maskPositionY(String v) {_st.maskPositionY = _s(v);}
  @override
  String get maskRepeat => _st.maskRepeat;
  @override
  void set maskRepeat(String v) {_st.maskRepeat = _s(v);}
  @override
  String get maskRepeatX => _st.maskRepeatX;
  @override
  void set maskRepeatX(String v) {_st.maskRepeatX = _s(v);}
  @override
  String get maskRepeatY => _st.maskRepeatY;
  @override
  void set maskRepeatY(String v) {_st.maskRepeatY = _s(v);}
  @override
  String get maskSize => _st.maskSize;
  @override
  void set maskSize(String v) {_st.maskSize = _s(v);}
  @override
  String get maxHeight => _st.maxHeight;
  @override
  void set maxHeight(String v) {_st.maxHeight = _s(v);}
  @override
  String get maxLogicalHeight => _st.maxLogicalHeight;
  @override
  void set maxLogicalHeight(String v) {_st.maxLogicalHeight = _s(v);}
  @override
  String get maxLogicalWidth => _st.maxLogicalWidth;
  @override
  void set maxLogicalWidth(String v) {_st.maxLogicalWidth = _s(v);}
  @override
  String get maxWidth => _st.maxWidth;
  @override
  void set maxWidth(String v) {_st.maxWidth = _s(v);}
  @override
  String get maxZoom => _st.maxZoom;
  @override
  void set maxZoom(String v) {_st.maxZoom = _s(v);}
  @override
  String get minHeight => _st.minHeight;
  @override
  void set minHeight(String v) {_st.minHeight = _s(v);}
  @override
  String get minLogicalHeight => _st.minLogicalHeight;
  @override
  void set minLogicalHeight(String v) {_st.minLogicalHeight = _s(v);}
  @override
  String get minLogicalWidth => _st.minLogicalWidth;
  @override
  void set minLogicalWidth(String v) {_st.minLogicalWidth = _s(v);}
  @override
  String get minWidth => _st.minWidth;
  @override
  void set minWidth(String v) {_st.minWidth = _s(v);}
  @override
  String get minZoom => _st.minZoom;
  @override
  void set minZoom(String v) {_st.minZoom = _s(v);}
  @override
  String get nbspMode => _st.nbspMode;
  @override
  void set nbspMode(String v) {_st.nbspMode = _s(v);}
  @override
  String get opacity => _st.opacity;
  @override
  void set opacity(String v) {_st.opacity = _s(v);}
  @override
  String get order => _st.order;
  @override
  void set order(String v) {_st.order = _s(v);}
  @override
  String get orientation => _st.orientation;
  @override
  void set orientation(String v) {_st.orientation = _s(v);}
  @override
  String get orphans => _st.orphans;
  @override
  void set orphans(String v) {_st.orphans = _s(v);}
  @override
  String get outline => _st.outline;
  @override
  void set outline(String v) {_st.outline = _s(v);}
  @override
  String get outlineColor => _st.outlineColor;
  @override
  void set outlineColor(String v) {_st.outlineColor = _s(v);}
  @override
  String get outlineOffset => _st.outlineOffset;
  @override
  void set outlineOffset(String v) {_st.outlineOffset = _s(v);}
  @override
  String get outlineStyle => _st.outlineStyle;
  @override
  void set outlineStyle(String v) {_st.outlineStyle = _s(v);}
  @override
  String get outlineWidth => _st.outlineWidth;
  @override
  void set outlineWidth(String v) {_st.outlineWidth = _s(v);}
  @override
  String get overflow => _st.overflow;
  @override
  void set overflow(String v) {_st.overflow = _s(v);}
  @override
  String get overflowScrolling => _st.overflowScrolling;
  @override
  void set overflowScrolling(String v) {_st.overflowScrolling = _s(v);}
  @override
  String get overflowWrap => _st.overflowWrap;
  @override
  void set overflowWrap(String v) {_st.overflowWrap = _s(v);}
  @override
  String get overflowX => _st.overflowX;
  @override
  void set overflowX(String v) {_st.overflowX = _s(v);}
  @override
  String get overflowY => _st.overflowY;
  @override
  void set overflowY(String v) {_st.overflowY = _s(v);}
  @override
  String get padding => _st.padding;
  @override
  void set padding(String v) {_st.padding = _s(v);}
  @override
  String get paddingAfter => _st.paddingAfter;
  @override
  void set paddingAfter(String v) {_st.paddingAfter = _s(v);}
  @override
  String get paddingBefore => _st.paddingBefore;
  @override
  void set paddingBefore(String v) {_st.paddingBefore = _s(v);}
  @override
  String get paddingBottom => _st.paddingBottom;
  @override
  void set paddingBottom(String v) {_st.paddingBottom = _s(v);}
  @override
  String get paddingEnd => _st.paddingEnd;
  @override
  void set paddingEnd(String v) {_st.paddingEnd = _s(v);}
  @override
  String get paddingLeft => _st.paddingLeft;
  @override
  void set paddingLeft(String v) {_st.paddingLeft = _s(v);}
  @override
  String get paddingRight => _st.paddingRight;
  @override
  void set paddingRight(String v) {_st.paddingRight = _s(v);}
  @override
  String get paddingStart => _st.paddingStart;
  @override
  void set paddingStart(String v) {_st.paddingStart = _s(v);}
  @override
  String get paddingTop => _st.paddingTop;
  @override
  void set paddingTop(String v) {_st.paddingTop = _s(v);}
  @override
  String get page => _st.page;
  @override
  void set page(String v) {_st.page = _s(v);}
  @override
  String get pageBreakAfter => _st.pageBreakAfter;
  @override
  void set pageBreakAfter(String v) {_st.pageBreakAfter = _s(v);}
  @override
  String get pageBreakBefore => _st.pageBreakBefore;
  @override
  void set pageBreakBefore(String v) {_st.pageBreakBefore = _s(v);}
  @override
  String get pageBreakInside => _st.pageBreakInside;
  @override
  void set pageBreakInside(String v) {_st.pageBreakInside = _s(v);}
  @override
  String get perspective => _st.perspective;
  @override
  void set perspective(String v) {_st.perspective = _s(v);}
  @override
  String get perspectiveOrigin => _st.perspectiveOrigin;
  @override
  void set perspectiveOrigin(String v) {_st.perspectiveOrigin = _s(v);}
  @override
  String get perspectiveOriginX => _st.perspectiveOriginX;
  @override
  void set perspectiveOriginX(String v) {_st.perspectiveOriginX = _s(v);}
  @override
  String get perspectiveOriginY => _st.perspectiveOriginY;
  @override
  void set perspectiveOriginY(String v) {_st.perspectiveOriginY = _s(v);}
  @override
  String get pointerEvents => _st.pointerEvents;
  @override
  void set pointerEvents(String v) {_st.pointerEvents = _s(v);}
  @override
  String get position => _st.position;
  @override
  void set position(String v) {_st.position = _s(v);}
  @override
  String get printColorAdjust => _st.printColorAdjust;
  @override
  void set printColorAdjust(String v) {_st.printColorAdjust = _s(v);}
  @override
  String get quotes => _st.quotes;
  @override
  void set quotes(String v) {_st.quotes = _s(v);}
  @override
  String get regionBreakAfter => _st.regionBreakAfter;
  @override
  void set regionBreakAfter(String v) {_st.regionBreakAfter = _s(v);}
  @override
  String get regionBreakBefore => _st.regionBreakBefore;
  @override
  void set regionBreakBefore(String v) {_st.regionBreakBefore = _s(v);}
  @override
  String get regionBreakInside => _st.regionBreakInside;
  @override
  void set regionBreakInside(String v) {_st.regionBreakInside = _s(v);}
  @override
  String get regionOverflow => _st.regionOverflow;
  @override
  void set regionOverflow(String v) {_st.regionOverflow = _s(v);}
  @override
  String get resize => _st.resize;
  @override
  void set resize(String v) {_st.resize = _s(v);}
  @override
  String get right => _st.right;
  @override
  void set right(String v) {_st.right = _s(v);}
  @override
  String get rtlOrdering => _st.rtlOrdering;
  @override
  void set rtlOrdering(String v) {_st.rtlOrdering = _s(v);}
  @override
  String get shapeInside => _st.shapeInside;
  @override
  void set shapeInside(String v) {_st.shapeInside = _s(v);}
  @override
  String get shapeMargin => _st.shapeMargin;
  @override
  void set shapeMargin(String v) {_st.shapeMargin = _s(v);}
  @override
  String get shapeOutside => _st.shapeOutside;
  @override
  void set shapeOutside(String v) {_st.shapeOutside = _s(v);}
  @override
  String get shapePadding => _st.shapePadding;
  @override
  void set shapePadding(String v) {_st.shapePadding = _s(v);}
  @override
  String get size => _st.size;
  @override
  void set size(String v) {_st.size = _s(v);}
  @override
  String get speak => _st.speak;
  @override
  void set speak(String v) {_st.speak = _s(v);}
  @override
  String get src => _st.src;
  @override
  void set src(String v) {_st.src = _s(v);}
  @override
  String get tableLayout => _st.tableLayout;
  @override
  void set tableLayout(String v) {_st.tableLayout = _s(v);}
  @override
  String get tabSize => _st.tabSize;
  @override
  void set tabSize(String v) {_st.tabSize = _s(v);}
  @override
  String get tapHighlightColor => _st.tapHighlightColor;
  @override
  void set tapHighlightColor(String v) {_st.tapHighlightColor = _s(v);}
  @override
  String get textAlign => _st.textAlign;
  @override
  void set textAlign(String v) {_st.textAlign = _s(v);}
  @override
  String get textAlignLast => _st.textAlignLast;
  @override
  void set textAlignLast(String v) {_st.textAlignLast = _s(v);}
  @override
  String get textCombine => _st.textCombine;
  @override
  void set textCombine(String v) {_st.textCombine = _s(v);}
  @override
  String get textDecoration => _st.textDecoration;
  @override
  void set textDecoration(String v) {_st.textDecoration = _s(v);}
  @override
  String get textDecorationLine => _st.textDecorationLine;
  @override
  void set textDecorationLine(String v) {_st.textDecorationLine = _s(v);}
  @override
  String get textDecorationsInEffect => _st.textDecorationsInEffect;
  @override
  void set textDecorationsInEffect(String v) {_st.textDecorationsInEffect = _s(v);}
  @override
  String get textDecorationStyle => _st.textDecorationStyle;
  @override
  void set textDecorationStyle(String v) {_st.textDecorationStyle = _s(v);}
  @override
  String get textEmphasis => _st.textEmphasis;
  @override
  void set textEmphasis(String v) {_st.textEmphasis = _s(v);}
  @override
  String get textEmphasisColor => _st.textEmphasisColor;
  @override
  void set textEmphasisColor(String v) {_st.textEmphasisColor = _s(v);}
  @override
  String get textEmphasisPosition => _st.textEmphasisPosition;
  @override
  void set textEmphasisPosition(String v) {_st.textEmphasisPosition = _s(v);}
  @override
  String get textEmphasisStyle => _st.textEmphasisStyle;
  @override
  void set textEmphasisStyle(String v) {_st.textEmphasisStyle = _s(v);}
  @override
  String get textFillColor => _st.textFillColor;
  @override
  void set textFillColor(String v) {_st.textFillColor = _s(v);}
  @override
  String get textIndent => _st.textIndent;
  @override
  void set textIndent(String v) {_st.textIndent = _s(v);}
  @override
  String get textLineThrough => _st.textLineThrough;
  @override
  void set textLineThrough(String v) {_st.textLineThrough = _s(v);}
  @override
  String get textLineThroughColor => _st.textLineThroughColor;
  @override
  void set textLineThroughColor(String v) {_st.textLineThroughColor = _s(v);}
  @override
  String get textLineThroughMode => _st.textLineThroughMode;
  @override
  void set textLineThroughMode(String v) {_st.textLineThroughMode = _s(v);}
  @override
  String get textLineThroughStyle => _st.textLineThroughStyle;
  @override
  void set textLineThroughStyle(String v) {_st.textLineThroughStyle = _s(v);}
  @override
  String get textLineThroughWidth => _st.textLineThroughWidth;
  @override
  void set textLineThroughWidth(String v) {_st.textLineThroughWidth = _s(v);}
  @override
  String get textOrientation => _st.textOrientation;
  @override
  void set textOrientation(String v) {_st.textOrientation = _s(v);}
  @override
  String get textOverflow => _st.textOverflow;
  @override
  void set textOverflow(String v) {_st.textOverflow = _s(v);}
  @override
  String get textOverline => _st.textOverline;
  @override
  void set textOverline(String v) {_st.textOverline = _s(v);}
  @override
  String get textOverlineColor => _st.textOverlineColor;
  @override
  void set textOverlineColor(String v) {_st.textOverlineColor = _s(v);}
  @override
  String get textOverlineMode => _st.textOverlineMode;
  @override
  void set textOverlineMode(String v) {_st.textOverlineMode = _s(v);}
  @override
  String get textOverlineStyle => _st.textOverlineStyle;
  @override
  void set textOverlineStyle(String v) {_st.textOverlineStyle = _s(v);}
  @override
  String get textOverlineWidth => _st.textOverlineWidth;
  @override
  void set textOverlineWidth(String v) {_st.textOverlineWidth = _s(v);}
  @override
  String get textRendering => _st.textRendering;
  @override
  void set textRendering(String v) {_st.textRendering = _s(v);}
  @override
  String get textSecurity => _st.textSecurity;
  @override
  void set textSecurity(String v) {_st.textSecurity = _s(v);}
  @override
  String get textShadow => _st.textShadow;
  @override
  void set textShadow(String v) {_st.textShadow = _s(v);}
  @override
  String get textSizeAdjust => _st.textSizeAdjust;
  @override
  void set textSizeAdjust(String v) {_st.textSizeAdjust = _s(v);}
  @override
  String get textStroke => _st.textStroke;
  @override
  void set textStroke(String v) {_st.textStroke = _s(v);}
  @override
  String get textStrokeColor => _st.textStrokeColor;
  @override
  void set textStrokeColor(String v) {_st.textStrokeColor = _s(v);}
  @override
  String get textStrokeWidth => _st.textStrokeWidth;
  @override
  void set textStrokeWidth(String v) {_st.textStrokeWidth = _s(v);}
  @override
  String get textTransform => _st.textTransform;
  @override
  void set textTransform(String v) {_st.textTransform = _s(v);}
  @override
  String get textUnderline => _st.textUnderline;
  @override
  void set textUnderline(String v) {_st.textUnderline = _s(v);}
  @override
  String get textUnderlineColor => _st.textUnderlineColor;
  @override
  void set textUnderlineColor(String v) {_st.textUnderlineColor = _s(v);}
  @override
  String get textUnderlineMode => _st.textUnderlineMode;
  @override
  void set textUnderlineMode(String v) {_st.textUnderlineMode = _s(v);}
  @override
  String get textUnderlineStyle => _st.textUnderlineStyle;
  @override
  void set textUnderlineStyle(String v) {_st.textUnderlineStyle = _s(v);}
  @override
  String get textUnderlineWidth => _st.textUnderlineWidth;
  @override
  void set textUnderlineWidth(String v) {_st.textUnderlineWidth = _s(v);}
  @override
  String get transform => _st.transform;
  @override
  void set transform(String v) {_st.transform = _s(v);}
  @override
  String get transformOrigin => _st.transformOrigin;
  @override
  void set transformOrigin(String v) {_st.transformOrigin = _s(v);}
  @override
  String get transformOriginX => _st.transformOriginX;
  @override
  void set transformOriginX(String v) {_st.transformOriginX = _s(v);}
  @override
  String get transformOriginY => _st.transformOriginY;
  @override
  void set transformOriginY(String v) {_st.transformOriginY = _s(v);}
  @override
  String get transformOriginZ => _st.transformOriginZ;
  @override
  void set transformOriginZ(String v) {_st.transformOriginZ = _s(v);}
  @override
  String get transformStyle => _st.transformStyle;
  @override
  void set transformStyle(String v) {_st.transformStyle = _s(v);}
  @override
  String get transition => _st.transition;
  @override
  void set transition(String v) {_st.transition = _s(v);}
  @override
  String get transitionDelay => _st.transitionDelay;
  @override
  void set transitionDelay(String v) {_st.transitionDelay = _s(v);}
  @override
  String get transitionDuration => _st.transitionDuration;
  @override
  void set transitionDuration(String v) {_st.transitionDuration = _s(v);}
  @override
  String get transitionProperty => _st.transitionProperty;
  @override
  void set transitionProperty(String v) {_st.transitionProperty = _s(v);}
  @override
  String get transitionTimingFunction => _st.transitionTimingFunction;
  @override
  void set transitionTimingFunction(String v) {_st.transitionTimingFunction = _s(v);}
  @override
  String get unicodeBidi => _st.unicodeBidi;
  @override
  void set unicodeBidi(String v) {_st.unicodeBidi = _s(v);}
  @override
  String get unicodeRange => _st.unicodeRange;
  @override
  void set unicodeRange(String v) {_st.unicodeRange = _s(v);}
  @override
  String get userDrag => _st.userDrag;
  @override
  void set userDrag(String v) {_st.userDrag = _s(v);}
  @override
  String get userModify => _st.userModify;
  @override
  void set userModify(String v) {_st.userModify = _s(v);}
  @override
  String get userSelect => _st.userSelect;
  @override
  void set userSelect(String v) {_st.userSelect = _s(v);}
  @override
  String get userZoom => _st.userZoom;
  @override
  void set userZoom(String v) {_st.userZoom = _s(v);}
  @override
  String get verticalAlign => _st.verticalAlign;
  @override
  void set verticalAlign(String v) {_st.verticalAlign = _s(v);}
  @override
  String get visibility => _st.visibility;
  @override
  void set visibility(String v) {_st.visibility = _s(v);}
  @override
  String get whiteSpace => _st.whiteSpace;
  @override
  void set whiteSpace(String v) {_st.whiteSpace = _s(v);}
  @override
  String get widows => _st.widows;
  @override
  void set widows(String v) {_st.widows = _s(v);}
  @override
  String get wordBreak => _st.wordBreak;
  @override
  void set wordBreak(String v) {_st.wordBreak = _s(v);}
  @override
  String get wordSpacing => _st.wordSpacing;
  @override
  void set wordSpacing(String v) {_st.wordSpacing = _s(v);}
  @override
  String get wordWrap => _st.wordWrap;
  @override
  void set wordWrap(String v) {_st.wordWrap = _s(v);}
  @override
  String get wrap => _st.wrap;
  @override
  void set wrap(String v) {_st.wrap = _s(v);}
  @override
  String get wrapFlow => _st.wrapFlow;
  @override
  void set wrapFlow(String v) {_st.wrapFlow = _s(v);}
  @override
  String get wrapThrough => _st.wrapThrough;
  @override
  void set wrapThrough(String v) {_st.wrapThrough = _s(v);}
  @override
  String get writingMode => _st.writingMode;
  @override
  void set writingMode(String v) {_st.writingMode = _s(v);}
  @override
  String get zIndex => _st.zIndex;
  @override
  void set zIndex(String v) {_st.zIndex = _s(v);}
  @override
  String get zoom => _st.zoom;
  @override
  void set zoom(String v) {_st.zoom = _s(v);}
}
