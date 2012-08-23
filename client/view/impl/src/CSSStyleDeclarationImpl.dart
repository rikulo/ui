//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  2:30:35 PM
// Author: tomyeh

/**
 * An implementation of [CSSStyleDeclaration].
 */
class CSSStyleDeclarationImpl implements CSSStyleDeclaration {
  final View _view;
  CSSStyleDeclaration _pcss;

  CSSStyleDeclarationImpl(View this._view) {
  }

  CSSStyleDeclaration get _css {
    if (_pcss == null)
      _pcss = new CSSStyleDeclaration();
    return _pcss;
  }

  String getPropertyValue(String propertyName) {
    _check(propertyName);
    return _pcss != null ? _unwrap(_pcss.getPropertyValue(CSS.name(propertyName))): "";
  }

  String removeProperty(String propertyName) {
    propertyName = CSS.name(propertyName);

    final String prev = _pcss != null ? _pcss.removeProperty(propertyName): "";
    if (_view != null && _view.inDocument)
      _view.node.style.removeProperty(propertyName);
    return prev;
  }

  void setProperty(String propertyName, String value, [String priority]) {
    _check(propertyName);
    propertyName = CSS.name(propertyName);

    if (priority == null) {
      _css.setProperty(propertyName, value);

      if (_view != null && _view.inDocument)
        _view.node.style.setProperty(propertyName, value);
    } else {
      _css.setProperty(propertyName, value, priority);

      if (_view != null && _view.inDocument)
        _view.node.style.setProperty(propertyName, value, priority);
    }
  }

  String get cssText => _pcss != null ? _pcss.cssText: "";
  void set cssText(String value) {
    if (_pcss != null || (value != null && !value.isEmpty()))
      _css.cssText = value;

    if (_view != null && _view.inDocument)
      _view.node.style.cssText = value;
  }

  int get length => _pcss != null ? _pcss.length: 0;

  CSSRule get parentRule => _pcss != null ? _pcss.parentRule: null;
  CSSValue getPropertyCSSValue(String propertyName)
    => _pcss != null ? _pcss.getPropertyCSSValue(CSS.name(propertyName)): null;
  String getPropertyPriority(String propertyName)
    => _pcss != null ? _pcss.getPropertyPriority(CSS.name(propertyName)): "";
  String getPropertyShorthand(String propertyName)
    => _css.getPropertyShorthand(CSS.name(propertyName)); 
      //Not sure what to return by default

  bool isPropertyImplicit(String propertyName)
    => _css.isPropertyImplicit(CSS.name(propertyName)); //Not sure what to return by default

  String item(int index) => _css.item(index); //Not sure what to return by default


  // TODO(jacobr): generate this list of properties using the existing script.
    /** Gets the value of "animation" */
  String get animation => getPropertyValue('animation');
  /** Sets the value of "animation" */
  void set animation(var value) {
    setProperty('animation', value, '');
  }

  /** Gets the value of "animation-delay" */
  String get animationDelay => getPropertyValue('animation-delay');
  /** Sets the value of "animation-delay" */
  void set animationDelay(var value) {
    setProperty('animation-delay', value, '');
  }

  /** Gets the value of "animation-direction" */
  String get animationDirection => getPropertyValue('animation-direction');
  /** Sets the value of "animation-direction" */
  void set animationDirection(var value) {
    setProperty('animation-direction', value, '');
  }

  /** Gets the value of "animation-duration" */
  String get animationDuration => getPropertyValue('animation-duration');
  /** Sets the value of "animation-duration" */
  void set animationDuration(var value) {
    setProperty('animation-duration', value, '');
  }

  /** Gets the value of "animation-fill-mode" */
  String get animationFillMode => getPropertyValue('animation-fill-mode');
  /** Sets the value of "animation-fill-mode" */
  void set animationFillMode(var value) {
    setProperty('animation-fill-mode', value, '');
  }

  /** Gets the value of "animation-iteration-count" */
  String get animationIterationCount => getPropertyValue('animation-iteration-count');
  /** Sets the value of "animation-iteration-count" */
  void set animationIterationCount(var value) {
    setProperty('animation-iteration-count', value, '');
  }

  /** Gets the value of "animation-name" */
  String get animationName => getPropertyValue('animation-name');
  /** Sets the value of "animation-name" */
  void set animationName(var value) {
    setProperty('animation-name', value, '');
  }

  /** Gets the value of "animation-play-state" */
  String get animationPlayState => getPropertyValue('animation-play-state');
  /** Sets the value of "animation-play-state" */
  void set animationPlayState(var value) {
    setProperty('animation-play-state', value, '');
  }

  /** Gets the value of "animation-timing-function" */
  String get animationTimingFunction => getPropertyValue('animation-timing-function');
  /** Sets the value of "animation-timing-function" */
  void set animationTimingFunction(var value) {
    setProperty('animation-timing-function', value, '');
  }

  /** Gets the value of "appearance" */
  String get appearance => getPropertyValue('appearance');
  /** Sets the value of "appearance" */
  void set appearance(var value) {
    setProperty('appearance', value, '');
  }

  /** Gets the value of "backface-visibility" */
  String get backfaceVisibility => getPropertyValue('backface-visibility');
  /** Sets the value of "backface-visibility" */
  void set backfaceVisibility(var value) {
    setProperty('backface-visibility', value, '');
  }

  /** Gets the value of "background" */
  String get background => getPropertyValue('background');
  /** Sets the value of "background" */
  void set background(var value) {
    setProperty('background', value, '');
  }

  /** Gets the value of "background-attachment" */
  String get backgroundAttachment => getPropertyValue('background-attachment');
  /** Sets the value of "background-attachment" */
  void set backgroundAttachment(var value) {
    setProperty('background-attachment', value, '');
  }

  /** Gets the value of "background-clip" */
  String get backgroundClip => getPropertyValue('background-clip');
  /** Sets the value of "background-clip" */
  void set backgroundClip(var value) {
    setProperty('background-clip', value, '');
  }

  /** Gets the value of "background-color" */
  String get backgroundColor => getPropertyValue('background-color');
  /** Sets the value of "background-color" */
  void set backgroundColor(var value) {
    setProperty('background-color', value, '');
  }

  /** Gets the value of "background-composite" */
  String get backgroundComposite => getPropertyValue('background-composite');
  /** Sets the value of "background-composite" */
  void set backgroundComposite(var value) {
    setProperty('background-composite', value, '');
  }

  /** Gets the value of "background-image" */
  String get backgroundImage => getPropertyValue('background-image');
  /** Sets the value of "background-image" */
  void set backgroundImage(var value) {
    setProperty('background-image', value, '');
  }

  /** Gets the value of "background-origin" */
  String get backgroundOrigin => getPropertyValue('background-origin');
  /** Sets the value of "background-origin" */
  void set backgroundOrigin(var value) {
    setProperty('background-origin', value, '');
  }

  /** Gets the value of "background-position" */
  String get backgroundPosition => getPropertyValue('background-position');
  /** Sets the value of "background-position" */
  void set backgroundPosition(var value) {
    setProperty('background-position', value, '');
  }

  /** Gets the value of "background-position-x" */
  String get backgroundPositionX => getPropertyValue('background-position-x');
  /** Sets the value of "background-position-x" */
  void set backgroundPositionX(var value) {
    setProperty('background-position-x', value, '');
  }

  /** Gets the value of "background-position-y" */
  String get backgroundPositionY => getPropertyValue('background-position-y');
  /** Sets the value of "background-position-y" */
  void set backgroundPositionY(var value) {
    setProperty('background-position-y', value, '');
  }

  /** Gets the value of "background-repeat" */
  String get backgroundRepeat => getPropertyValue('background-repeat');
  /** Sets the value of "background-repeat" */
  void set backgroundRepeat(var value) {
    setProperty('background-repeat', value, '');
  }

  /** Gets the value of "background-repeat-x" */
  String get backgroundRepeatX => getPropertyValue('background-repeat-x');
  /** Sets the value of "background-repeat-x" */
  void set backgroundRepeatX(var value) {
    setProperty('background-repeat-x', value, '');
  }

  /** Gets the value of "background-repeat-y" */
  String get backgroundRepeatY => getPropertyValue('background-repeat-y');
  /** Sets the value of "background-repeat-y" */
  void set backgroundRepeatY(var value) {
    setProperty('background-repeat-y', value, '');
  }

  /** Gets the value of "background-size" */
  String get backgroundSize => getPropertyValue('background-size');
  /** Sets the value of "background-size" */
  void set backgroundSize(var value) {
    setProperty('background-size', value, '');
  }

  /** Gets the value of "border" */
  String get border => getPropertyValue('border');
  /** Sets the value of "border" */
  void set border(var value) {
    setProperty('border', value, '');
  }

  /** Gets the value of "border-after" */
  String get borderAfter => getPropertyValue('border-after');
  /** Sets the value of "border-after" */
  void set borderAfter(var value) {
    setProperty('border-after', value, '');
  }

  /** Gets the value of "border-after-color" */
  String get borderAfterColor => getPropertyValue('border-after-color');
  /** Sets the value of "border-after-color" */
  void set borderAfterColor(var value) {
    setProperty('border-after-color', value, '');
  }

  /** Gets the value of "border-after-style" */
  String get borderAfterStyle => getPropertyValue('border-after-style');
  /** Sets the value of "border-after-style" */
  void set borderAfterStyle(var value) {
    setProperty('border-after-style', value, '');
  }

  /** Gets the value of "border-after-width" */
  String get borderAfterWidth => getPropertyValue('border-after-width');
  /** Sets the value of "border-after-width" */
  void set borderAfterWidth(var value) {
    setProperty('border-after-width', value, '');
  }

  /** Gets the value of "border-before" */
  String get borderBefore => getPropertyValue('border-before');
  /** Sets the value of "border-before" */
  void set borderBefore(var value) {
    setProperty('border-before', value, '');
  }

  /** Gets the value of "border-before-color" */
  String get borderBeforeColor => getPropertyValue('border-before-color');
  /** Sets the value of "border-before-color" */
  void set borderBeforeColor(var value) {
    setProperty('border-before-color', value, '');
  }

  /** Gets the value of "border-before-style" */
  String get borderBeforeStyle => getPropertyValue('border-before-style');
  /** Sets the value of "border-before-style" */
  void set borderBeforeStyle(var value) {
    setProperty('border-before-style', value, '');
  }

  /** Gets the value of "border-before-width" */
  String get borderBeforeWidth => getPropertyValue('border-before-width');
  /** Sets the value of "border-before-width" */
  void set borderBeforeWidth(var value) {
    setProperty('border-before-width', value, '');
  }

  /** Gets the value of "border-bottom" */
  String get borderBottom => getPropertyValue('border-bottom');
  /** Sets the value of "border-bottom" */
  void set borderBottom(var value) {
    setProperty('border-bottom', value, '');
  }

  /** Gets the value of "border-bottom-color" */
  String get borderBottomColor => getPropertyValue('border-bottom-color');
  /** Sets the value of "border-bottom-color" */
  void set borderBottomColor(var value) {
    setProperty('border-bottom-color', value, '');
  }

  /** Gets the value of "border-bottom-left-radius" */
  String get borderBottomLeftRadius => getPropertyValue('border-bottom-left-radius');
  /** Sets the value of "border-bottom-left-radius" */
  void set borderBottomLeftRadius(var value) {
    setProperty('border-bottom-left-radius', value, '');
  }

  /** Gets the value of "border-bottom-right-radius" */
  String get borderBottomRightRadius => getPropertyValue('border-bottom-right-radius');
  /** Sets the value of "border-bottom-right-radius" */
  void set borderBottomRightRadius(var value) {
    setProperty('border-bottom-right-radius', value, '');
  }

  /** Gets the value of "border-bottom-style" */
  String get borderBottomStyle => getPropertyValue('border-bottom-style');
  /** Sets the value of "border-bottom-style" */
  void set borderBottomStyle(var value) {
    setProperty('border-bottom-style', value, '');
  }

  /** Gets the value of "border-bottom-width" */
  String get borderBottomWidth => getPropertyValue('border-bottom-width');
  /** Sets the value of "border-bottom-width" */
  void set borderBottomWidth(var value) {
    setProperty('border-bottom-width', value, '');
  }

  /** Gets the value of "border-collapse" */
  String get borderCollapse => getPropertyValue('border-collapse');
  /** Sets the value of "border-collapse" */
  void set borderCollapse(var value) {
    setProperty('border-collapse', value, '');
  }

  /** Gets the value of "border-color" */
  String get borderColor => getPropertyValue('border-color');
  /** Sets the value of "border-color" */
  void set borderColor(var value) {
    setProperty('border-color', value, '');
  }

  /** Gets the value of "border-end" */
  String get borderEnd => getPropertyValue('border-end');
  /** Sets the value of "border-end" */
  void set borderEnd(var value) {
    setProperty('border-end', value, '');
  }

  /** Gets the value of "border-end-color" */
  String get borderEndColor => getPropertyValue('border-end-color');
  /** Sets the value of "border-end-color" */
  void set borderEndColor(var value) {
    setProperty('border-end-color', value, '');
  }

  /** Gets the value of "border-end-style" */
  String get borderEndStyle => getPropertyValue('border-end-style');
  /** Sets the value of "border-end-style" */
  void set borderEndStyle(var value) {
    setProperty('border-end-style', value, '');
  }

  /** Gets the value of "border-end-width" */
  String get borderEndWidth => getPropertyValue('border-end-width');
  /** Sets the value of "border-end-width" */
  void set borderEndWidth(var value) {
    setProperty('border-end-width', value, '');
  }

  /** Gets the value of "border-fit" */
  String get borderFit => getPropertyValue('border-fit');
  /** Sets the value of "border-fit" */
  void set borderFit(var value) {
    setProperty('border-fit', value, '');
  }

  /** Gets the value of "border-horizontal-spacing" */
  String get borderHorizontalSpacing => getPropertyValue('border-horizontal-spacing');
  /** Sets the value of "border-horizontal-spacing" */
  void set borderHorizontalSpacing(var value) {
    setProperty('border-horizontal-spacing', value, '');
  }

  /** Gets the value of "border-image" */
  String get borderImage => getPropertyValue('border-image');
  /** Sets the value of "border-image" */
  void set borderImage(var value) {
    setProperty('border-image', value, '');
  }

  /** Gets the value of "border-image-outset" */
  String get borderImageOutset => getPropertyValue('border-image-outset');
  /** Sets the value of "border-image-outset" */
  void set borderImageOutset(var value) {
    setProperty('border-image-outset', value, '');
  }

  /** Gets the value of "border-image-repeat" */
  String get borderImageRepeat => getPropertyValue('border-image-repeat');
  /** Sets the value of "border-image-repeat" */
  void set borderImageRepeat(var value) {
    setProperty('border-image-repeat', value, '');
  }

  /** Gets the value of "border-image-slice" */
  String get borderImageSlice => getPropertyValue('border-image-slice');
  /** Sets the value of "border-image-slice" */
  void set borderImageSlice(var value) {
    setProperty('border-image-slice', value, '');
  }

  /** Gets the value of "border-image-source" */
  String get borderImageSource => getPropertyValue('border-image-source');
  /** Sets the value of "border-image-source" */
  void set borderImageSource(var value) {
    setProperty('border-image-source', value, '');
  }

  /** Gets the value of "border-image-width" */
  String get borderImageWidth => getPropertyValue('border-image-width');
  /** Sets the value of "border-image-width" */
  void set borderImageWidth(var value) {
    setProperty('border-image-width', value, '');
  }

  /** Gets the value of "border-left" */
  String get borderLeft => getPropertyValue('border-left');
  /** Sets the value of "border-left" */
  void set borderLeft(var value) {
    setProperty('border-left', value, '');
  }

  /** Gets the value of "border-left-color" */
  String get borderLeftColor => getPropertyValue('border-left-color');
  /** Sets the value of "border-left-color" */
  void set borderLeftColor(var value) {
    setProperty('border-left-color', value, '');
  }

  /** Gets the value of "border-left-style" */
  String get borderLeftStyle => getPropertyValue('border-left-style');
  /** Sets the value of "border-left-style" */
  void set borderLeftStyle(var value) {
    setProperty('border-left-style', value, '');
  }

  /** Gets the value of "border-left-width" */
  String get borderLeftWidth => getPropertyValue('border-left-width');
  /** Sets the value of "border-left-width" */
  void set borderLeftWidth(var value) {
    setProperty('border-left-width', value, '');
  }

  /** Gets the value of "border-radius" */
  String get borderRadius => getPropertyValue('border-radius');
  /** Sets the value of "border-radius" */
  void set borderRadius(var value) {
    setProperty('border-radius', value, '');
  }

  /** Gets the value of "border-right" */
  String get borderRight => getPropertyValue('border-right');
  /** Sets the value of "border-right" */
  void set borderRight(var value) {
    setProperty('border-right', value, '');
  }

  /** Gets the value of "border-right-color" */
  String get borderRightColor => getPropertyValue('border-right-color');
  /** Sets the value of "border-right-color" */
  void set borderRightColor(var value) {
    setProperty('border-right-color', value, '');
  }

  /** Gets the value of "border-right-style" */
  String get borderRightStyle => getPropertyValue('border-right-style');
  /** Sets the value of "border-right-style" */
  void set borderRightStyle(var value) {
    setProperty('border-right-style', value, '');
  }

  /** Gets the value of "border-right-width" */
  String get borderRightWidth => getPropertyValue('border-right-width');
  /** Sets the value of "border-right-width" */
  void set borderRightWidth(var value) {
    setProperty('border-right-width', value, '');
  }

  /** Gets the value of "border-spacing" */
  String get borderSpacing => getPropertyValue('border-spacing');
  /** Sets the value of "border-spacing" */
  void set borderSpacing(var value) {
    setProperty('border-spacing', value, '');
  }

  /** Gets the value of "border-start" */
  String get borderStart => getPropertyValue('border-start');
  /** Sets the value of "border-start" */
  void set borderStart(var value) {
    setProperty('border-start', value, '');
  }

  /** Gets the value of "border-start-color" */
  String get borderStartColor => getPropertyValue('border-start-color');
  /** Sets the value of "border-start-color" */
  void set borderStartColor(var value) {
    setProperty('border-start-color', value, '');
  }

  /** Gets the value of "border-start-style" */
  String get borderStartStyle => getPropertyValue('border-start-style');
  /** Sets the value of "border-start-style" */
  void set borderStartStyle(var value) {
    setProperty('border-start-style', value, '');
  }

  /** Gets the value of "border-start-width" */
  String get borderStartWidth => getPropertyValue('border-start-width');
  /** Sets the value of "border-start-width" */
  void set borderStartWidth(var value) {
    setProperty('border-start-width', value, '');
  }

  /** Gets the value of "border-style" */
  String get borderStyle => getPropertyValue('border-style');
  /** Sets the value of "border-style" */
  void set borderStyle(var value) {
    setProperty('border-style', value, '');
  }

  /** Gets the value of "border-top" */
  String get borderTop => getPropertyValue('border-top');
  /** Sets the value of "border-top" */
  void set borderTop(var value) {
    setProperty('border-top', value, '');
  }

  /** Gets the value of "border-top-color" */
  String get borderTopColor => getPropertyValue('border-top-color');
  /** Sets the value of "border-top-color" */
  void set borderTopColor(var value) {
    setProperty('border-top-color', value, '');
  }

  /** Gets the value of "border-top-left-radius" */
  String get borderTopLeftRadius => getPropertyValue('border-top-left-radius');
  /** Sets the value of "border-top-left-radius" */
  void set borderTopLeftRadius(var value) {
    setProperty('border-top-left-radius', value, '');
  }

  /** Gets the value of "border-top-right-radius" */
  String get borderTopRightRadius => getPropertyValue('border-top-right-radius');
  /** Sets the value of "border-top-right-radius" */
  void set borderTopRightRadius(var value) {
    setProperty('border-top-right-radius', value, '');
  }

  /** Gets the value of "border-top-style" */
  String get borderTopStyle => getPropertyValue('border-top-style');
  /** Sets the value of "border-top-style" */
  void set borderTopStyle(var value) {
    setProperty('border-top-style', value, '');
  }

  /** Gets the value of "border-top-width" */
  String get borderTopWidth => getPropertyValue('border-top-width');
  /** Sets the value of "border-top-width" */
  void set borderTopWidth(var value) {
    setProperty('border-top-width', value, '');
  }

  /** Gets the value of "border-vertical-spacing" */
  String get borderVerticalSpacing => getPropertyValue('border-vertical-spacing');
  /** Sets the value of "border-vertical-spacing" */
  void set borderVerticalSpacing(var value) {
    setProperty('border-vertical-spacing', value, '');
  }

  /** Gets the value of "border-width" */
  String get borderWidth => getPropertyValue('border-width');
  /** Sets the value of "border-width" */
  void set borderWidth(var value) {
    setProperty('border-width', value, '');
  }

  /** Not allowed. Please  use [View.top] instead. */
  String get bottom => getPropertyValue('bottom');
  /** Not allowed. Please  use [View.top] instead. */
  void set bottom(var value) {
    setProperty('bottom', value, '');
  }

  /** Gets the value of "box-align" */
  String get boxAlign => getPropertyValue('box-align');
  /** Sets the value of "box-align" */
  void set boxAlign(var value) {
    setProperty('box-align', value, '');
  }

  /** Gets the value of "box-direction" */
  String get boxDirection => getPropertyValue('box-direction');
  /** Sets the value of "box-direction" */
  void set boxDirection(var value) {
    setProperty('box-direction', value, '');
  }

  /** Gets the value of "box-flex" */
  String get boxFlex => getPropertyValue('box-flex');
  /** Sets the value of "box-flex" */
  void set boxFlex(var value) {
    setProperty('box-flex', value, '');
  }

  /** Gets the value of "box-flex-group" */
  String get boxFlexGroup => getPropertyValue('box-flex-group');
  /** Sets the value of "box-flex-group" */
  void set boxFlexGroup(var value) {
    setProperty('box-flex-group', value, '');
  }

  /** Gets the value of "box-lines" */
  String get boxLines => getPropertyValue('box-lines');
  /** Sets the value of "box-lines" */
  void set boxLines(var value) {
    setProperty('box-lines', value, '');
  }

  /** Gets the value of "box-ordinal-group" */
  String get boxOrdinalGroup => getPropertyValue('box-ordinal-group');
  /** Sets the value of "box-ordinal-group" */
  void set boxOrdinalGroup(var value) {
    setProperty('box-ordinal-group', value, '');
  }

  /** Gets the value of "box-orient" */
  String get boxOrient => getPropertyValue('box-orient');
  /** Sets the value of "box-orient" */
  void set boxOrient(var value) {
    setProperty('box-orient', value, '');
  }

  /** Gets the value of "box-pack" */
  String get boxPack => getPropertyValue('box-pack');
  /** Sets the value of "box-pack" */
  void set boxPack(var value) {
    setProperty('box-pack', value, '');
  }

  /** Gets the value of "box-reflect" */
  String get boxReflect => getPropertyValue('box-reflect');
  /** Sets the value of "box-reflect" */
  void set boxReflect(var value) {
    setProperty('box-reflect', value, '');
  }

  /** Gets the value of "box-shadow" */
  String get boxShadow => getPropertyValue('box-shadow');
  /** Sets the value of "box-shadow" */
  void set boxShadow(var value) {
    setProperty('box-shadow', value, '');
  }

  /** Gets the value of "box-sizing" */
  String get boxSizing => getPropertyValue('box-sizing');
  /** Sets the value of "box-sizing" */
  void set boxSizing(var value) {
    setProperty('box-sizing', value, '');
  }

  /** Gets the value of "caption-side" */
  String get captionSide => getPropertyValue('caption-side');
  /** Sets the value of "caption-side" */
  void set captionSide(var value) {
    setProperty('caption-side', value, '');
  }

  /** Gets the value of "clear" */
  String get clear => getPropertyValue('clear');
  /** Sets the value of "clear" */
  void set clear(var value) {
    setProperty('clear', value, '');
  }

  /** Gets the value of "clip" */
  String get clip => getPropertyValue('clip');
  /** Sets the value of "clip" */
  void set clip(var value) {
    setProperty('clip', value, '');
  }

  /** Gets the value of "color" */
  String get color => getPropertyValue('color');
  /** Sets the value of "color" */
  void set color(var value) {
    setProperty('color', value, '');
  }

  /** Gets the value of "color-correction" */
  String get colorCorrection => getPropertyValue('color-correction');
  /** Sets the value of "color-correction" */
  void set colorCorrection(var value) {
    setProperty('color-correction', value, '');
  }

  /** Gets the value of "column-break-after" */
  String get columnBreakAfter => getPropertyValue('column-break-after');
  /** Sets the value of "column-break-after" */
  void set columnBreakAfter(var value) {
    setProperty('column-break-after', value, '');
  }

  /** Gets the value of "column-break-before" */
  String get columnBreakBefore => getPropertyValue('column-break-before');
  /** Sets the value of "column-break-before" */
  void set columnBreakBefore(var value) {
    setProperty('column-break-before', value, '');
  }

  /** Gets the value of "column-break-inside" */
  String get columnBreakInside => getPropertyValue('column-break-inside');
  /** Sets the value of "column-break-inside" */
  void set columnBreakInside(var value) {
    setProperty('column-break-inside', value, '');
  }

  /** Gets the value of "column-count" */
  String get columnCount => getPropertyValue('column-count');
  /** Sets the value of "column-count" */
  void set columnCount(var value) {
    setProperty('column-count', value, '');
  }

  /** Gets the value of "column-gap" */
  String get columnGap => getPropertyValue('column-gap');
  /** Sets the value of "column-gap" */
  void set columnGap(var value) {
    setProperty('column-gap', value, '');
  }

  /** Gets the value of "column-rule" */
  String get columnRule => getPropertyValue('column-rule');
  /** Sets the value of "column-rule" */
  void set columnRule(var value) {
    setProperty('column-rule', value, '');
  }

  /** Gets the value of "column-rule-color" */
  String get columnRuleColor => getPropertyValue('column-rule-color');
  /** Sets the value of "column-rule-color" */
  void set columnRuleColor(var value) {
    setProperty('column-rule-color', value, '');
  }

  /** Gets the value of "column-rule-style" */
  String get columnRuleStyle => getPropertyValue('column-rule-style');
  /** Sets the value of "column-rule-style" */
  void set columnRuleStyle(var value) {
    setProperty('column-rule-style', value, '');
  }

  /** Gets the value of "column-rule-width" */
  String get columnRuleWidth => getPropertyValue('column-rule-width');
  /** Sets the value of "column-rule-width" */
  void set columnRuleWidth(var value) {
    setProperty('column-rule-width', value, '');
  }

  /** Gets the value of "column-span" */
  String get columnSpan => getPropertyValue('column-span');
  /** Sets the value of "column-span" */
  void set columnSpan(var value) {
    setProperty('column-span', value, '');
  }

  /** Gets the value of "column-width" */
  String get columnWidth => getPropertyValue('column-width');
  /** Sets the value of "column-width" */
  void set columnWidth(var value) {
    setProperty('column-width', value, '');
  }

  /** Gets the value of "columns" */
  String get columns => getPropertyValue('columns');
  /** Sets the value of "columns" */
  void set columns(var value) {
    setProperty('columns', value, '');
  }

  /** Gets the value of "content" */
  String get content => getPropertyValue('content');
  /** Sets the value of "content" */
  void set content(var value) {
    setProperty('content', value, '');
  }

  /** Gets the value of "counter-increment" */
  String get counterIncrement => getPropertyValue('counter-increment');
  /** Sets the value of "counter-increment" */
  void set counterIncrement(var value) {
    setProperty('counter-increment', value, '');
  }

  /** Gets the value of "counter-reset" */
  String get counterReset => getPropertyValue('counter-reset');
  /** Sets the value of "counter-reset" */
  void set counterReset(var value) {
    setProperty('counter-reset', value, '');
  }

  /** Gets the value of "cursor" */
  String get cursor => getPropertyValue('cursor');
  /** Sets the value of "cursor" */
  void set cursor(var value) {
    setProperty('cursor', value, '');
  }

  /** Gets the value of "direction" */
  String get direction => getPropertyValue('direction');
  /** Sets the value of "direction" */
  void set direction(var value) {
    setProperty('direction', value, '');
  }

  /** Gets the value of "display". */
  String get display => getPropertyValue('display');
  /** Sets the value of "display". */
  void set display(var value) {
    setProperty('display', value, '');
  }

  /** Gets the value of "empty-cells" */
  String get emptyCells => getPropertyValue('empty-cells');
  /** Sets the value of "empty-cells" */
  void set emptyCells(var value) {
    setProperty('empty-cells', value, '');
  }

  /** Gets the value of "filter" */
  String get filter => getPropertyValue('filter');
  /** Sets the value of "filter" */
  void set filter(var value) {
    setProperty('filter', value, '');
  }

  /** Gets the value of "flex-align" */
  String get flexAlign => getPropertyValue('flex-align');
  /** Sets the value of "flex-align" */
  void set flexAlign(var value) {
    setProperty('flex-align', value, '');
  }

  /** Gets the value of "flex-flow" */
  String get flexFlow => getPropertyValue('flex-flow');
  /** Sets the value of "flex-flow" */
  void set flexFlow(var value) {
    setProperty('flex-flow', value, '');
  }

  /** Gets the value of "flex-order" */
  String get flexOrder => getPropertyValue('flex-order');
  /** Sets the value of "flex-order" */
  void set flexOrder(var value) {
    setProperty('flex-order', value, '');
  }

  /** Gets the value of "flex-pack" */
  String get flexPack => getPropertyValue('flex-pack');
  /** Sets the value of "flex-pack" */
  void set flexPack(var value) {
    setProperty('flex-pack', value, '');
  }

  /** Gets the value of "float" */
  String get float => getPropertyValue('float');
  /** Sets the value of "float" */
  void set float(var value) {
    setProperty('float', value, '');
  }

  /** Gets the value of "flow-from" */
  String get flowFrom => getPropertyValue('flow-from');
  /** Sets the value of "flow-from" */
  void set flowFrom(var value) {
    setProperty('flow-from', value, '');
  }

  /** Gets the value of "flow-into" */
  String get flowInto => getPropertyValue('flow-into');
  /** Sets the value of "flow-into" */
  void set flowInto(var value) {
    setProperty('flow-into', value, '');
  }

  /** Gets the value of "font" */
  String get font => getPropertyValue('font');
  /** Sets the value of "font" */
  void set font(var value) {
    setProperty('font', value, '');
  }

  /** Gets the value of "font-family" */
  String get fontFamily => getPropertyValue('font-family');
  /** Sets the value of "font-family" */
  void set fontFamily(var value) {
    setProperty('font-family', value, '');
  }

  /** Gets the value of "font-feature-settings" */
  String get fontFeatureSettings => getPropertyValue('font-feature-settings');
  /** Sets the value of "font-feature-settings" */
  void set fontFeatureSettings(var value) {
    setProperty('font-feature-settings', value, '');
  }

  /** Gets the value of "font-size" */
  String get fontSize => getPropertyValue('font-size');
  /** Sets the value of "font-size" */
  void set fontSize(var value) {
    setProperty('font-size', value, '');
  }

  /** Gets the value of "font-size-delta" */
  String get fontSizeDelta => getPropertyValue('font-size-delta');
  /** Sets the value of "font-size-delta" */
  void set fontSizeDelta(var value) {
    setProperty('font-size-delta', value, '');
  }

  /** Gets the value of "font-smoothing" */
  String get fontSmoothing => getPropertyValue('font-smoothing');
  /** Sets the value of "font-smoothing" */
  void set fontSmoothing(var value) {
    setProperty('font-smoothing', value, '');
  }

  /** Gets the value of "font-stretch" */
  String get fontStretch => getPropertyValue('font-stretch');
  /** Sets the value of "font-stretch" */
  void set fontStretch(var value) {
    setProperty('font-stretch', value, '');
  }

  /** Gets the value of "font-style" */
  String get fontStyle => getPropertyValue('font-style');
  /** Sets the value of "font-style" */
  void set fontStyle(var value) {
    setProperty('font-style', value, '');
  }

  /** Gets the value of "font-variant" */
  String get fontVariant => getPropertyValue('font-variant');
  /** Sets the value of "font-variant" */
  void set fontVariant(var value) {
    setProperty('font-variant', value, '');
  }

  /** Gets the value of "font-weight" */
  String get fontWeight => getPropertyValue('font-weight');
  /** Sets the value of "font-weight" */
  void set fontWeight(var value) {
    setProperty('font-weight', value, '');
  }

  /** Not allowed. Please  use [View.height] instead. */
  String get height => getPropertyValue('height');
  /** Not allowed. Please  use [View.height] instead. */
  void set height(var value) {
    setProperty('height', value, '');
  }

  /** Gets the value of "highlight" */
  String get highlight => getPropertyValue('highlight');
  /** Sets the value of "highlight" */
  void set highlight(var value) {
    setProperty('highlight', value, '');
  }

  /** Gets the value of "hyphenate-character" */
  String get hyphenateCharacter => getPropertyValue('hyphenate-character');
  /** Sets the value of "hyphenate-character" */
  void set hyphenateCharacter(var value) {
    setProperty('hyphenate-character', value, '');
  }

  /** Gets the value of "hyphenate-limit-after" */
  String get hyphenateLimitAfter => getPropertyValue('hyphenate-limit-after');
  /** Sets the value of "hyphenate-limit-after" */
  void set hyphenateLimitAfter(var value) {
    setProperty('hyphenate-limit-after', value, '');
  }

  /** Gets the value of "hyphenate-limit-before" */
  String get hyphenateLimitBefore => getPropertyValue('hyphenate-limit-before');
  /** Sets the value of "hyphenate-limit-before" */
  void set hyphenateLimitBefore(var value) {
    setProperty('hyphenate-limit-before', value, '');
  }

  /** Gets the value of "hyphenate-limit-lines" */
  String get hyphenateLimitLines => getPropertyValue('hyphenate-limit-lines');
  /** Sets the value of "hyphenate-limit-lines" */
  void set hyphenateLimitLines(var value) {
    setProperty('hyphenate-limit-lines', value, '');
  }

  /** Gets the value of "hyphens" */
  String get hyphens => getPropertyValue('hyphens');
  /** Sets the value of "hyphens" */
  void set hyphens(var value) {
    setProperty('hyphens', value, '');
  }

  /** Gets the value of "image-rendering" */
  String get imageRendering => getPropertyValue('image-rendering');
  /** Sets the value of "image-rendering" */
  void set imageRendering(var value) {
    setProperty('image-rendering', value, '');
  }

  /** Not allowed. Please  use [View.left] instead. */
  String get left => getPropertyValue('left');
  /** Not allowed. Please  use [View.left] instead. */
  void set left(var value) {
    setProperty('left', value, '');
  }

  /** Gets the value of "letter-spacing" */
  String get letterSpacing => getPropertyValue('letter-spacing');
  /** Sets the value of "letter-spacing" */
  void set letterSpacing(var value) {
    setProperty('letter-spacing', value, '');
  }

  /** Gets the value of "line-box-contain" */
  String get lineBoxContain => getPropertyValue('line-box-contain');
  /** Sets the value of "line-box-contain" */
  void set lineBoxContain(var value) {
    setProperty('line-box-contain', value, '');
  }

  /** Gets the value of "line-break" */
  String get lineBreak => getPropertyValue('line-break');
  /** Sets the value of "line-break" */
  void set lineBreak(var value) {
    setProperty('line-break', value, '');
  }

  /** Gets the value of "line-clamp" */
  String get lineClamp => getPropertyValue('line-clamp');
  /** Sets the value of "line-clamp" */
  void set lineClamp(var value) {
    setProperty('line-clamp', value, '');
  }

  /** Gets the value of "line-height" */
  String get lineHeight => getPropertyValue('line-height');
  /** Sets the value of "line-height" */
  void set lineHeight(var value) {
    setProperty('line-height', value, '');
  }

  /** Gets the value of "list-style" */
  String get listStyle => getPropertyValue('list-style');
  /** Sets the value of "list-style" */
  void set listStyle(var value) {
    setProperty('list-style', value, '');
  }

  /** Gets the value of "list-style-image" */
  String get listStyleImage => getPropertyValue('list-style-image');
  /** Sets the value of "list-style-image" */
  void set listStyleImage(var value) {
    setProperty('list-style-image', value, '');
  }

  /** Gets the value of "list-style-position" */
  String get listStylePosition => getPropertyValue('list-style-position');
  /** Sets the value of "list-style-position" */
  void set listStylePosition(var value) {
    setProperty('list-style-position', value, '');
  }

  /** Gets the value of "list-style-type" */
  String get listStyleType => getPropertyValue('list-style-type');
  /** Sets the value of "list-style-type" */
  void set listStyleType(var value) {
    setProperty('list-style-type', value, '');
  }

  /** Gets the value of "locale" */
  String get locale => getPropertyValue('locale');
  /** Sets the value of "locale" */
  void set locale(var value) {
    setProperty('locale', value, '');
  }

  /** Gets the value of "logical-height" */
  String get logicalHeight => getPropertyValue('logical-height');
  /** Sets the value of "logical-height" */
  void set logicalHeight(var value) {
    setProperty('logical-height', value, '');
  }

  /** Gets the value of "logical-width" */
  String get logicalWidth => getPropertyValue('logical-width');
  /** Sets the value of "logical-width" */
  void set logicalWidth(var value) {
    setProperty('logical-width', value, '');
  }

  /** Gets the value of "margin" */
  String get margin => getPropertyValue('margin');
  /** Sets the value of "margin" */
  void set margin(var value) {
    setProperty('margin', value, '');
  }

  /** Gets the value of "margin-after" */
  String get marginAfter => getPropertyValue('margin-after');
  /** Sets the value of "margin-after" */
  void set marginAfter(var value) {
    setProperty('margin-after', value, '');
  }

  /** Gets the value of "margin-after-collapse" */
  String get marginAfterCollapse => getPropertyValue('margin-after-collapse');
  /** Sets the value of "margin-after-collapse" */
  void set marginAfterCollapse(var value) {
    setProperty('margin-after-collapse', value, '');
  }

  /** Gets the value of "margin-before" */
  String get marginBefore => getPropertyValue('margin-before');
  /** Sets the value of "margin-before" */
  void set marginBefore(var value) {
    setProperty('margin-before', value, '');
  }

  /** Gets the value of "margin-before-collapse" */
  String get marginBeforeCollapse => getPropertyValue('margin-before-collapse');
  /** Sets the value of "margin-before-collapse" */
  void set marginBeforeCollapse(var value) {
    setProperty('margin-before-collapse', value, '');
  }

  /** Gets the value of "margin-bottom" */
  String get marginBottom => getPropertyValue('margin-bottom');
  /** Sets the value of "margin-bottom" */
  void set marginBottom(var value) {
    setProperty('margin-bottom', value, '');
  }

  /** Gets the value of "margin-bottom-collapse" */
  String get marginBottomCollapse => getPropertyValue('margin-bottom-collapse');
  /** Sets the value of "margin-bottom-collapse" */
  void set marginBottomCollapse(var value) {
    setProperty('margin-bottom-collapse', value, '');
  }

  /** Gets the value of "margin-collapse" */
  String get marginCollapse => getPropertyValue('margin-collapse');
  /** Sets the value of "margin-collapse" */
  void set marginCollapse(var value) {
    setProperty('margin-collapse', value, '');
  }

  /** Gets the value of "margin-end" */
  String get marginEnd => getPropertyValue('margin-end');
  /** Sets the value of "margin-end" */
  void set marginEnd(var value) {
    setProperty('margin-end', value, '');
  }

  /** Gets the value of "margin-left" */
  String get marginLeft => getPropertyValue('margin-left');
  /** Sets the value of "margin-left" */
  void set marginLeft(var value) {
    setProperty('margin-left', value, '');
  }

  /** Gets the value of "margin-right" */
  String get marginRight => getPropertyValue('margin-right');
  /** Sets the value of "margin-right" */
  void set marginRight(var value) {
    setProperty('margin-right', value, '');
  }

  /** Gets the value of "margin-start" */
  String get marginStart => getPropertyValue('margin-start');
  /** Sets the value of "margin-start" */
  void set marginStart(var value) {
    setProperty('margin-start', value, '');
  }

  /** Gets the value of "margin-top" */
  String get marginTop => getPropertyValue('margin-top');
  /** Sets the value of "margin-top" */
  void set marginTop(var value) {
    setProperty('margin-top', value, '');
  }

  /** Gets the value of "margin-top-collapse" */
  String get marginTopCollapse => getPropertyValue('margin-top-collapse');
  /** Sets the value of "margin-top-collapse" */
  void set marginTopCollapse(var value) {
    setProperty('margin-top-collapse', value, '');
  }

  /** Gets the value of "marquee" */
  String get marquee => getPropertyValue('marquee');
  /** Sets the value of "marquee" */
  void set marquee(var value) {
    setProperty('marquee', value, '');
  }

  /** Gets the value of "marquee-direction" */
  String get marqueeDirection => getPropertyValue('marquee-direction');
  /** Sets the value of "marquee-direction" */
  void set marqueeDirection(var value) {
    setProperty('marquee-direction', value, '');
  }

  /** Gets the value of "marquee-increment" */
  String get marqueeIncrement => getPropertyValue('marquee-increment');
  /** Sets the value of "marquee-increment" */
  void set marqueeIncrement(var value) {
    setProperty('marquee-increment', value, '');
  }

  /** Gets the value of "marquee-repetition" */
  String get marqueeRepetition => getPropertyValue('marquee-repetition');
  /** Sets the value of "marquee-repetition" */
  void set marqueeRepetition(var value) {
    setProperty('marquee-repetition', value, '');
  }

  /** Gets the value of "marquee-speed" */
  String get marqueeSpeed => getPropertyValue('marquee-speed');
  /** Sets the value of "marquee-speed" */
  void set marqueeSpeed(var value) {
    setProperty('marquee-speed', value, '');
  }

  /** Gets the value of "marquee-style" */
  String get marqueeStyle => getPropertyValue('marquee-style');
  /** Sets the value of "marquee-style" */
  void set marqueeStyle(var value) {
    setProperty('marquee-style', value, '');
  }

  /** Gets the value of "mask" */
  String get mask => getPropertyValue('mask');
  /** Sets the value of "mask" */
  void set mask(var value) {
    setProperty('mask', value, '');
  }

  /** Gets the value of "mask-attachment" */
  String get maskAttachment => getPropertyValue('mask-attachment');
  /** Sets the value of "mask-attachment" */
  void set maskAttachment(var value) {
    setProperty('mask-attachment', value, '');
  }

  /** Gets the value of "mask-box-image" */
  String get maskBoxImage => getPropertyValue('mask-box-image');
  /** Sets the value of "mask-box-image" */
  void set maskBoxImage(var value) {
    setProperty('mask-box-image', value, '');
  }

  /** Gets the value of "mask-box-image-outset" */
  String get maskBoxImageOutset => getPropertyValue('mask-box-image-outset');
  /** Sets the value of "mask-box-image-outset" */
  void set maskBoxImageOutset(var value) {
    setProperty('mask-box-image-outset', value, '');
  }

  /** Gets the value of "mask-box-image-repeat" */
  String get maskBoxImageRepeat => getPropertyValue('mask-box-image-repeat');
  /** Sets the value of "mask-box-image-repeat" */
  void set maskBoxImageRepeat(var value) {
    setProperty('mask-box-image-repeat', value, '');
  }

  /** Gets the value of "mask-box-image-slice" */
  String get maskBoxImageSlice => getPropertyValue('mask-box-image-slice');
  /** Sets the value of "mask-box-image-slice" */
  void set maskBoxImageSlice(var value) {
    setProperty('mask-box-image-slice', value, '');
  }

  /** Gets the value of "mask-box-image-source" */
  String get maskBoxImageSource => getPropertyValue('mask-box-image-source');
  /** Sets the value of "mask-box-image-source" */
  void set maskBoxImageSource(var value) {
    setProperty('mask-box-image-source', value, '');
  }

  /** Gets the value of "mask-box-image-width" */
  String get maskBoxImageWidth => getPropertyValue('mask-box-image-width');
  /** Sets the value of "mask-box-image-width" */
  void set maskBoxImageWidth(var value) {
    setProperty('mask-box-image-width', value, '');
  }

  /** Gets the value of "mask-clip" */
  String get maskClip => getPropertyValue('mask-clip');
  /** Sets the value of "mask-clip" */
  void set maskClip(var value) {
    setProperty('mask-clip', value, '');
  }

  /** Gets the value of "mask-composite" */
  String get maskComposite => getPropertyValue('mask-composite');
  /** Sets the value of "mask-composite" */
  void set maskComposite(var value) {
    setProperty('mask-composite', value, '');
  }

  /** Gets the value of "mask-image" */
  String get maskImage => getPropertyValue('mask-image');
  /** Sets the value of "mask-image" */
  void set maskImage(var value) {
    setProperty('mask-image', value, '');
  }

  /** Gets the value of "mask-origin" */
  String get maskOrigin => getPropertyValue('mask-origin');
  /** Sets the value of "mask-origin" */
  void set maskOrigin(var value) {
    setProperty('mask-origin', value, '');
  }

  /** Gets the value of "mask-position" */
  String get maskPosition => getPropertyValue('mask-position');
  /** Sets the value of "mask-position" */
  void set maskPosition(var value) {
    setProperty('mask-position', value, '');
  }

  /** Gets the value of "mask-position-x" */
  String get maskPositionX => getPropertyValue('mask-position-x');
  /** Sets the value of "mask-position-x" */
  void set maskPositionX(var value) {
    setProperty('mask-position-x', value, '');
  }

  /** Gets the value of "mask-position-y" */
  String get maskPositionY => getPropertyValue('mask-position-y');
  /** Sets the value of "mask-position-y" */
  void set maskPositionY(var value) {
    setProperty('mask-position-y', value, '');
  }

  /** Gets the value of "mask-repeat" */
  String get maskRepeat => getPropertyValue('mask-repeat');
  /** Sets the value of "mask-repeat" */
  void set maskRepeat(var value) {
    setProperty('mask-repeat', value, '');
  }

  /** Gets the value of "mask-repeat-x" */
  String get maskRepeatX => getPropertyValue('mask-repeat-x');
  /** Sets the value of "mask-repeat-x" */
  void set maskRepeatX(var value) {
    setProperty('mask-repeat-x', value, '');
  }

  /** Gets the value of "mask-repeat-y" */
  String get maskRepeatY => getPropertyValue('mask-repeat-y');
  /** Sets the value of "mask-repeat-y" */
  void set maskRepeatY(var value) {
    setProperty('mask-repeat-y', value, '');
  }

  /** Gets the value of "mask-size" */
  String get maskSize => getPropertyValue('mask-size');
  /** Sets the value of "mask-size" */
  void set maskSize(var value) {
    setProperty('mask-size', value, '');
  }

  /** Gets the value of "match-nearest-mail-blockquote-color" */
  String get matchNearestMailBlockquoteColor => getPropertyValue('match-nearest-mail-blockquote-color');
  /** Sets the value of "match-nearest-mail-blockquote-color" */
  void set matchNearestMailBlockquoteColor(var value) {
    setProperty('match-nearest-mail-blockquote-color', value, '');
  }

  /** Gets the value of "max-height" */
  String get maxHeight => getPropertyValue('max-height');
  /** Sets the value of "max-height" */
  void set maxHeight(var value) {
    setProperty('max-height', value, '');
  }

  /** Gets the value of "max-logical-height" */
  String get maxLogicalHeight => getPropertyValue('max-logical-height');
  /** Sets the value of "max-logical-height" */
  void set maxLogicalHeight(var value) {
    setProperty('max-logical-height', value, '');
  }

  /** Gets the value of "max-logical-width" */
  String get maxLogicalWidth => getPropertyValue('max-logical-width');
  /** Sets the value of "max-logical-width" */
  void set maxLogicalWidth(var value) {
    setProperty('max-logical-width', value, '');
  }

  /** Gets the value of "max-width" */
  String get maxWidth => getPropertyValue('max-width');
  /** Sets the value of "max-width" */
  void set maxWidth(var value) {
    setProperty('max-width', value, '');
  }

  /** Gets the value of "min-height" */
  String get minHeight => getPropertyValue('min-height');
  /** Sets the value of "min-height" */
  void set minHeight(var value) {
    setProperty('min-height', value, '');
  }

  /** Gets the value of "min-logical-height" */
  String get minLogicalHeight => getPropertyValue('min-logical-height');
  /** Sets the value of "min-logical-height" */
  void set minLogicalHeight(var value) {
    setProperty('min-logical-height', value, '');
  }

  /** Gets the value of "min-logical-width" */
  String get minLogicalWidth => getPropertyValue('min-logical-width');
  /** Sets the value of "min-logical-width" */
  void set minLogicalWidth(var value) {
    setProperty('min-logical-width', value, '');
  }

  /** Gets the value of "min-width" */
  String get minWidth => getPropertyValue('min-width');
  /** Sets the value of "min-width" */
  void set minWidth(var value) {
    setProperty('min-width', value, '');
  }

  /** Gets the value of "nbsp-mode" */
  String get nbspMode => getPropertyValue('nbsp-mode');
  /** Sets the value of "nbsp-mode" */
  void set nbspMode(var value) {
    setProperty('nbsp-mode', value, '');
  }

  /** Gets the value of "opacity" */
  String get opacity => getPropertyValue('opacity');
  /** Sets the value of "opacity" */
  void set opacity(var value) {
    setProperty('opacity', value, '');
  }

  /** Gets the value of "orphans" */
  String get orphans => getPropertyValue('orphans');
  /** Sets the value of "orphans" */
  void set orphans(var value) {
    setProperty('orphans', value, '');
  }

  /** Gets the value of "outline" */
  String get outline => getPropertyValue('outline');
  /** Sets the value of "outline" */
  void set outline(var value) {
    setProperty('outline', value, '');
  }

  /** Gets the value of "outline-color" */
  String get outlineColor => getPropertyValue('outline-color');
  /** Sets the value of "outline-color" */
  void set outlineColor(var value) {
    setProperty('outline-color', value, '');
  }

  /** Gets the value of "outline-offset" */
  String get outlineOffset => getPropertyValue('outline-offset');
  /** Sets the value of "outline-offset" */
  void set outlineOffset(var value) {
    setProperty('outline-offset', value, '');
  }

  /** Gets the value of "outline-style" */
  String get outlineStyle => getPropertyValue('outline-style');
  /** Sets the value of "outline-style" */
  void set outlineStyle(var value) {
    setProperty('outline-style', value, '');
  }

  /** Gets the value of "outline-width" */
  String get outlineWidth => getPropertyValue('outline-width');
  /** Sets the value of "outline-width" */
  void set outlineWidth(var value) {
    setProperty('outline-width', value, '');
  }

  /** Gets the value of "overflow" */
  String get overflow => getPropertyValue('overflow');
  /** Sets the value of "overflow" */
  void set overflow(var value) {
    setProperty('overflow', value, '');
  }

  /** Gets the value of "overflow-x" */
  String get overflowX => getPropertyValue('overflow-x');
  /** Sets the value of "overflow-x" */
  void set overflowX(var value) {
    setProperty('overflow-x', value, '');
  }

  /** Gets the value of "overflow-y" */
  String get overflowY => getPropertyValue('overflow-y');
  /** Sets the value of "overflow-y" */
  void set overflowY(var value) {
    setProperty('overflow-y', value, '');
  }

  /** Gets the value of "padding" */
  String get padding => getPropertyValue('padding');
  /** Sets the value of "padding" */
  void set padding(var value) {
    setProperty('padding', value, '');
  }

  /** Gets the value of "padding-after" */
  String get paddingAfter => getPropertyValue('padding-after');
  /** Sets the value of "padding-after" */
  void set paddingAfter(var value) {
    setProperty('padding-after', value, '');
  }

  /** Gets the value of "padding-before" */
  String get paddingBefore => getPropertyValue('padding-before');
  /** Sets the value of "padding-before" */
  void set paddingBefore(var value) {
    setProperty('padding-before', value, '');
  }

  /** Gets the value of "padding-bottom" */
  String get paddingBottom => getPropertyValue('padding-bottom');
  /** Sets the value of "padding-bottom" */
  void set paddingBottom(var value) {
    setProperty('padding-bottom', value, '');
  }

  /** Gets the value of "padding-end" */
  String get paddingEnd => getPropertyValue('padding-end');
  /** Sets the value of "padding-end" */
  void set paddingEnd(var value) {
    setProperty('padding-end', value, '');
  }

  /** Gets the value of "padding-left" */
  String get paddingLeft => getPropertyValue('padding-left');
  /** Sets the value of "padding-left" */
  void set paddingLeft(var value) {
    setProperty('padding-left', value, '');
  }

  /** Gets the value of "padding-right" */
  String get paddingRight => getPropertyValue('padding-right');
  /** Sets the value of "padding-right" */
  void set paddingRight(var value) {
    setProperty('padding-right', value, '');
  }

  /** Gets the value of "padding-start" */
  String get paddingStart => getPropertyValue('padding-start');
  /** Sets the value of "padding-start" */
  void set paddingStart(var value) {
    setProperty('padding-start', value, '');
  }

  /** Gets the value of "padding-top" */
  String get paddingTop => getPropertyValue('padding-top');
  /** Sets the value of "padding-top" */
  void set paddingTop(var value) {
    setProperty('padding-top', value, '');
  }

  /** Gets the value of "page" */
  String get page => getPropertyValue('page');
  /** Sets the value of "page" */
  void set page(var value) {
    setProperty('page', value, '');
  }

  /** Gets the value of "page-break-after" */
  String get pageBreakAfter => getPropertyValue('page-break-after');
  /** Sets the value of "page-break-after" */
  void set pageBreakAfter(var value) {
    setProperty('page-break-after', value, '');
  }

  /** Gets the value of "page-break-before" */
  String get pageBreakBefore => getPropertyValue('page-break-before');
  /** Sets the value of "page-break-before" */
  void set pageBreakBefore(var value) {
    setProperty('page-break-before', value, '');
  }

  /** Gets the value of "page-break-inside" */
  String get pageBreakInside => getPropertyValue('page-break-inside');
  /** Sets the value of "page-break-inside" */
  void set pageBreakInside(var value) {
    setProperty('page-break-inside', value, '');
  }

  /** Gets the value of "perspective" */
  String get perspective => getPropertyValue('perspective');
  /** Sets the value of "perspective" */
  void set perspective(var value) {
    setProperty('perspective', value, '');
  }

  /** Gets the value of "perspective-origin" */
  String get perspectiveOrigin => getPropertyValue('perspective-origin');
  /** Sets the value of "perspective-origin" */
  void set perspectiveOrigin(var value) {
    setProperty('perspective-origin', value, '');
  }

  /** Gets the value of "perspective-origin-x" */
  String get perspectiveOriginX => getPropertyValue('perspective-origin-x');
  /** Sets the value of "perspective-origin-x" */
  void set perspectiveOriginX(var value) {
    setProperty('perspective-origin-x', value, '');
  }

  /** Gets the value of "perspective-origin-y" */
  String get perspectiveOriginY => getPropertyValue('perspective-origin-y');
  /** Sets the value of "perspective-origin-y" */
  void set perspectiveOriginY(var value) {
    setProperty('perspective-origin-y', value, '');
  }

  /** Gets the value of "pointer-events" */
  String get pointerEvents => getPropertyValue('pointer-events');
  /** Sets the value of "pointer-events" */
  void set pointerEvents(var value) {
    setProperty('pointer-events', value, '');
  }

  /** Gets the value of "position" */
  String get position => getPropertyValue('position');
  /** Sets the value of "position" */
  void set position(var value) {
    setProperty('position', value, '');
  }

  /** Gets the value of "quotes" */
  String get quotes => getPropertyValue('quotes');
  /** Sets the value of "quotes" */
  void set quotes(var value) {
    setProperty('quotes', value, '');
  }

  /** Gets the value of "region-break-after" */
  String get regionBreakAfter => getPropertyValue('region-break-after');
  /** Sets the value of "region-break-after" */
  void set regionBreakAfter(var value) {
    setProperty('region-break-after', value, '');
  }

  /** Gets the value of "region-break-before" */
  String get regionBreakBefore => getPropertyValue('region-break-before');
  /** Sets the value of "region-break-before" */
  void set regionBreakBefore(var value) {
    setProperty('region-break-before', value, '');
  }

  /** Gets the value of "region-break-inside" */
  String get regionBreakInside => getPropertyValue('region-break-inside');
  /** Sets the value of "region-break-inside" */
  void set regionBreakInside(var value) {
    setProperty('region-break-inside', value, '');
  }

  /** Gets the value of "region-overflow" */
  String get regionOverflow => getPropertyValue('region-overflow');
  /** Sets the value of "region-overflow" */
  void set regionOverflow(var value) {
    setProperty('region-overflow', value, '');
  }

  /** Gets the value of "resize" */
  String get resize => getPropertyValue('resize');
  /** Sets the value of "resize" */
  void set resize(var value) {
    setProperty('resize', value, '');
  }

  /** Not allowed. Please  use [View.left] instead. */
  String get right => getPropertyValue('right');
  /** Not allowed. Please  use [View.left] instead. */
  void set right(var value) {
    setProperty('right', value, '');
  }

  /** Gets the value of "rtl-ordering" */
  String get rtlOrdering => getPropertyValue('rtl-ordering');
  /** Sets the value of "rtl-ordering" */
  void set rtlOrdering(var value) {
    setProperty('rtl-ordering', value, '');
  }

  /** Gets the value of "size" */
  String get size => getPropertyValue('size');
  /** Sets the value of "size" */
  void set size(var value) {
    setProperty('size', value, '');
  }

  /** Gets the value of "speak" */
  String get speak => getPropertyValue('speak');
  /** Sets the value of "speak" */
  void set speak(var value) {
    setProperty('speak', value, '');
  }

  /** Gets the value of "src" */
  String get src => getPropertyValue('src');
  /** Sets the value of "src" */
  void set src(var value) {
    setProperty('src', value, '');
  }

  /** Gets the value of "table-layout" */
  String get tableLayout => getPropertyValue('table-layout');
  /** Sets the value of "table-layout" */
  void set tableLayout(var value) {
    setProperty('table-layout', value, '');
  }

  /** Gets the value of "tap-highlight-color" */
  String get tapHighlightColor => getPropertyValue('tap-highlight-color');
  /** Sets the value of "tap-highlight-color" */
  void set tapHighlightColor(var value) {
    setProperty('tap-highlight-color', value, '');
  }

  /** Gets the value of "text-align" */
  String get textAlign => getPropertyValue('text-align');
  /** Sets the value of "text-align" */
  void set textAlign(var value) {
    setProperty('text-align', value, '');
  }

  /** Gets the value of "text-combine" */
  String get textCombine => getPropertyValue('text-combine');
  /** Sets the value of "text-combine" */
  void set textCombine(var value) {
    setProperty('text-combine', value, '');
  }

  /** Gets the value of "text-decoration" */
  String get textDecoration => getPropertyValue('text-decoration');
  /** Sets the value of "text-decoration" */
  void set textDecoration(var value) {
    setProperty('text-decoration', value, '');
  }

  /** Gets the value of "text-decorations-in-effect" */
  String get textDecorationsInEffect => getPropertyValue('text-decorations-in-effect');
  /** Sets the value of "text-decorations-in-effect" */
  void set textDecorationsInEffect(var value) {
    setProperty('text-decorations-in-effect', value, '');
  }

  /** Gets the value of "text-emphasis" */
  String get textEmphasis => getPropertyValue('text-emphasis');
  /** Sets the value of "text-emphasis" */
  void set textEmphasis(var value) {
    setProperty('text-emphasis', value, '');
  }

  /** Gets the value of "text-emphasis-color" */
  String get textEmphasisColor => getPropertyValue('text-emphasis-color');
  /** Sets the value of "text-emphasis-color" */
  void set textEmphasisColor(var value) {
    setProperty('text-emphasis-color', value, '');
  }

  /** Gets the value of "text-emphasis-position" */
  String get textEmphasisPosition => getPropertyValue('text-emphasis-position');
  /** Sets the value of "text-emphasis-position" */
  void set textEmphasisPosition(var value) {
    setProperty('text-emphasis-position', value, '');
  }

  /** Gets the value of "text-emphasis-style" */
  String get textEmphasisStyle => getPropertyValue('text-emphasis-style');
  /** Sets the value of "text-emphasis-style" */
  void set textEmphasisStyle(var value) {
    setProperty('text-emphasis-style', value, '');
  }

  /** Gets the value of "text-fill-color" */
  String get textFillColor => getPropertyValue('text-fill-color');
  /** Sets the value of "text-fill-color" */
  void set textFillColor(var value) {
    setProperty('text-fill-color', value, '');
  }

  /** Gets the value of "text-indent" */
  String get textIndent => getPropertyValue('text-indent');
  /** Sets the value of "text-indent" */
  void set textIndent(var value) {
    setProperty('text-indent', value, '');
  }

  /** Gets the value of "text-line-through" */
  String get textLineThrough => getPropertyValue('text-line-through');
  /** Sets the value of "text-line-through" */
  void set textLineThrough(var value) {
    setProperty('text-line-through', value, '');
  }

  /** Gets the value of "text-line-through-color" */
  String get textLineThroughColor => getPropertyValue('text-line-through-color');
  /** Sets the value of "text-line-through-color" */
  void set textLineThroughColor(var value) {
    setProperty('text-line-through-color', value, '');
  }

  /** Gets the value of "text-line-through-mode" */
  String get textLineThroughMode => getPropertyValue('text-line-through-mode');
  /** Sets the value of "text-line-through-mode" */
  void set textLineThroughMode(var value) {
    setProperty('text-line-through-mode', value, '');
  }

  /** Gets the value of "text-line-through-style" */
  String get textLineThroughStyle => getPropertyValue('text-line-through-style');
  /** Sets the value of "text-line-through-style" */
  void set textLineThroughStyle(var value) {
    setProperty('text-line-through-style', value, '');
  }

  /** Gets the value of "text-line-through-width" */
  String get textLineThroughWidth => getPropertyValue('text-line-through-width');
  /** Sets the value of "text-line-through-width" */
  void set textLineThroughWidth(var value) {
    setProperty('text-line-through-width', value, '');
  }

  /** Gets the value of "text-orientation" */
  String get textOrientation => getPropertyValue('text-orientation');
  /** Sets the value of "text-orientation" */
  void set textOrientation(var value) {
    setProperty('text-orientation', value, '');
  }

  /** Gets the value of "text-overflow" */
  String get textOverflow => getPropertyValue('text-overflow');
  /** Sets the value of "text-overflow" */
  void set textOverflow(var value) {
    setProperty('text-overflow', value, '');
  }

  /** Gets the value of "text-overline" */
  String get textOverline => getPropertyValue('text-overline');
  /** Sets the value of "text-overline" */
  void set textOverline(var value) {
    setProperty('text-overline', value, '');
  }

  /** Gets the value of "text-overline-color" */
  String get textOverlineColor => getPropertyValue('text-overline-color');
  /** Sets the value of "text-overline-color" */
  void set textOverlineColor(var value) {
    setProperty('text-overline-color', value, '');
  }

  /** Gets the value of "text-overline-mode" */
  String get textOverlineMode => getPropertyValue('text-overline-mode');
  /** Sets the value of "text-overline-mode" */
  void set textOverlineMode(var value) {
    setProperty('text-overline-mode', value, '');
  }

  /** Gets the value of "text-overline-style" */
  String get textOverlineStyle => getPropertyValue('text-overline-style');
  /** Sets the value of "text-overline-style" */
  void set textOverlineStyle(var value) {
    setProperty('text-overline-style', value, '');
  }

  /** Gets the value of "text-overline-width" */
  String get textOverlineWidth => getPropertyValue('text-overline-width');
  /** Sets the value of "text-overline-width" */
  void set textOverlineWidth(var value) {
    setProperty('text-overline-width', value, '');
  }

  /** Gets the value of "text-rendering" */
  String get textRendering => getPropertyValue('text-rendering');
  /** Sets the value of "text-rendering" */
  void set textRendering(var value) {
    setProperty('text-rendering', value, '');
  }

  /** Gets the value of "text-security" */
  String get textSecurity => getPropertyValue('text-security');
  /** Sets the value of "text-security" */
  void set textSecurity(var value) {
    setProperty('text-security', value, '');
  }

  /** Gets the value of "text-shadow" */
  String get textShadow => getPropertyValue('text-shadow');
  /** Sets the value of "text-shadow" */
  void set textShadow(var value) {
    setProperty('text-shadow', value, '');
  }

  /** Gets the value of "text-size-adjust" */
  String get textSizeAdjust => getPropertyValue('text-size-adjust');
  /** Sets the value of "text-size-adjust" */
  void set textSizeAdjust(var value) {
    setProperty('text-size-adjust', value, '');
  }

  /** Gets the value of "text-stroke" */
  String get textStroke => getPropertyValue('text-stroke');
  /** Sets the value of "text-stroke" */
  void set textStroke(var value) {
    setProperty('text-stroke', value, '');
  }

  /** Gets the value of "text-stroke-color" */
  String get textStrokeColor => getPropertyValue('text-stroke-color');
  /** Sets the value of "text-stroke-color" */
  void set textStrokeColor(var value) {
    setProperty('text-stroke-color', value, '');
  }

  /** Gets the value of "text-stroke-width" */
  String get textStrokeWidth => getPropertyValue('text-stroke-width');
  /** Sets the value of "text-stroke-width" */
  void set textStrokeWidth(var value) {
    setProperty('text-stroke-width', value, '');
  }

  /** Gets the value of "text-transform" */
  String get textTransform => getPropertyValue('text-transform');
  /** Sets the value of "text-transform" */
  void set textTransform(var value) {
    setProperty('text-transform', value, '');
  }

  /** Gets the value of "text-underline" */
  String get textUnderline => getPropertyValue('text-underline');
  /** Sets the value of "text-underline" */
  void set textUnderline(var value) {
    setProperty('text-underline', value, '');
  }

  /** Gets the value of "text-underline-color" */
  String get textUnderlineColor => getPropertyValue('text-underline-color');
  /** Sets the value of "text-underline-color" */
  void set textUnderlineColor(var value) {
    setProperty('text-underline-color', value, '');
  }

  /** Gets the value of "text-underline-mode" */
  String get textUnderlineMode => getPropertyValue('text-underline-mode');
  /** Sets the value of "text-underline-mode" */
  void set textUnderlineMode(var value) {
    setProperty('text-underline-mode', value, '');
  }

  /** Gets the value of "text-underline-style" */
  String get textUnderlineStyle => getPropertyValue('text-underline-style');
  /** Sets the value of "text-underline-style" */
  void set textUnderlineStyle(var value) {
    setProperty('text-underline-style', value, '');
  }

  /** Gets the value of "text-underline-width" */
  String get textUnderlineWidth => getPropertyValue('text-underline-width');
  /** Sets the value of "text-underline-width" */
  void set textUnderlineWidth(var value) {
    setProperty('text-underline-width', value, '');
  }

  /** Not allowed. Please  use [View.top] instead. */
  String get top => getPropertyValue('top');
  /** Not allowed. Please  use [View.top] instead. */
  void set top(var value) {
    setProperty('top', value, '');
  }

  /** Gets the value of "transform" */
  String get transform => getPropertyValue('transform');
  /** Sets the value of "transform" */
  void set transform(var value) {
    setProperty('transform', value, '');
  }

  /** Gets the value of "transform-origin" */
  String get transformOrigin => getPropertyValue('transform-origin');
  /** Sets the value of "transform-origin" */
  void set transformOrigin(var value) {
    setProperty('transform-origin', value, '');
  }

  /** Gets the value of "transform-origin-x" */
  String get transformOriginX => getPropertyValue('transform-origin-x');
  /** Sets the value of "transform-origin-x" */
  void set transformOriginX(var value) {
    setProperty('transform-origin-x', value, '');
  }

  /** Gets the value of "transform-origin-y" */
  String get transformOriginY => getPropertyValue('transform-origin-y');
  /** Sets the value of "transform-origin-y" */
  void set transformOriginY(var value) {
    setProperty('transform-origin-y', value, '');
  }

  /** Gets the value of "transform-origin-z" */
  String get transformOriginZ => getPropertyValue('transform-origin-z');
  /** Sets the value of "transform-origin-z" */
  void set transformOriginZ(var value) {
    setProperty('transform-origin-z', value, '');
  }

  /** Gets the value of "transform-style" */
  String get transformStyle => getPropertyValue('transform-style');
  /** Sets the value of "transform-style" */
  void set transformStyle(var value) {
    setProperty('transform-style', value, '');
  }

  /** Gets the value of "transition" */
  String get transition => getPropertyValue('transition');
  /** Sets the value of "transition" */
  void set transition(var value) {
    setProperty('transition', value, '');
  }

  /** Gets the value of "transition-delay" */
  String get transitionDelay => getPropertyValue('transition-delay');
  /** Sets the value of "transition-delay" */
  void set transitionDelay(var value) {
    setProperty('transition-delay', value, '');
  }

  /** Gets the value of "transition-duration" */
  String get transitionDuration => getPropertyValue('transition-duration');
  /** Sets the value of "transition-duration" */
  void set transitionDuration(var value) {
    setProperty('transition-duration', value, '');
  }

  /** Gets the value of "transition-property" */
  String get transitionProperty => getPropertyValue('transition-property');
  /** Sets the value of "transition-property" */
  void set transitionProperty(var value) {
    setProperty('transition-property', value, '');
  }

  /** Gets the value of "transition-timing-function" */
  String get transitionTimingFunction => getPropertyValue('transition-timing-function');
  /** Sets the value of "transition-timing-function" */
  void set transitionTimingFunction(var value) {
    setProperty('transition-timing-function', value, '');
  }

  /** Gets the value of "unicode-bidi" */
  String get unicodeBidi => getPropertyValue('unicode-bidi');
  /** Sets the value of "unicode-bidi" */
  void set unicodeBidi(var value) {
    setProperty('unicode-bidi', value, '');
  }

  /** Gets the value of "unicode-range" */
  String get unicodeRange => getPropertyValue('unicode-range');
  /** Sets the value of "unicode-range" */
  void set unicodeRange(var value) {
    setProperty('unicode-range', value, '');
  }

  /** Gets the value of "user-drag" */
  String get userDrag => getPropertyValue('user-drag');
  /** Sets the value of "user-drag" */
  void set userDrag(var value) {
    setProperty('user-drag', value, '');
  }

  /** Gets the value of "user-modify" */
  String get userModify => getPropertyValue('user-modify');
  /** Sets the value of "user-modify" */
  void set userModify(var value) {
    setProperty('user-modify', value, '');
  }

  /** Gets the value of "user-select" */
  String get userSelect => getPropertyValue('user-select');
  /** Sets the value of "user-select" */
  void set userSelect(var value) {
    setProperty('user-select', value, '');
  }

  /** Gets the value of "vertical-align" */
  String get verticalAlign => getPropertyValue('vertical-align');
  /** Sets the value of "vertical-align" */
  void set verticalAlign(var value) {
    setProperty('vertical-align', value, '');
  }

  /** Gets the value of "visibility" */
  String get visibility => getPropertyValue('visibility');
  /** Sets the value of "visibility" */
  void set visibility(var value) {
    setProperty('visibility', value, '');
  }

  /** Gets the value of "white-space" */
  String get whiteSpace => getPropertyValue('white-space');
  /** Sets the value of "white-space" */
  void set whiteSpace(var value) {
    setProperty('white-space', value, '');
  }

  /** Gets the value of "widows" */
  String get widows => getPropertyValue('widows');
  /** Sets the value of "widows" */
  void set widows(var value) {
    setProperty('widows', value, '');
  }

  /** Not allowed. Please  use [View.width] instead. */
  String get width => getPropertyValue('width');
  /** Not allowed. Please  use [View.width] instead. */
  void set width(var value) {
    setProperty('width', value, '');
  }

  /** Gets the value of "word-break" */
  String get wordBreak => getPropertyValue('word-break');
  /** Sets the value of "word-break" */
  void set wordBreak(var value) {
    setProperty('word-break', value, '');
  }

  /** Gets the value of "word-spacing" */
  String get wordSpacing => getPropertyValue('word-spacing');
  /** Sets the value of "word-spacing" */
  void set wordSpacing(var value) {
    setProperty('word-spacing', value, '');
  }

  /** Gets the value of "word-wrap" */
  String get wordWrap => getPropertyValue('word-wrap');
  /** Sets the value of "word-wrap" */
  void set wordWrap(var value) {
    setProperty('word-wrap', value, '');
  }

  /** Gets the value of "wrap-shape" */
  String get wrapShape => getPropertyValue('wrap-shape');
  /** Sets the value of "wrap-shape" */
  void set wrapShape(var value) {
    setProperty('wrap-shape', value, '');
  }

  /** Gets the value of "writing-mode" */
  String get writingMode => getPropertyValue('writing-mode');
  /** Sets the value of "writing-mode" */
  void set writingMode(var value) {
    setProperty('writing-mode', value, '');
  }

  /** Gets the value of "z-index" */
  String get zIndex => getPropertyValue('z-index');
  /** Sets the value of "z-index" */
  void set zIndex(var value) {
    setProperty('z-index', value, '');
  }

  /** Gets the value of "zoom" */
  String get zoom => getPropertyValue('zoom');
  /** Sets the value of "zoom" */
  void set zoom(var value) {
    setProperty('zoom', value, '');
  }

  static String get _browserPrefix {
    if (_cacheBrowserPrefix == null)
      _cacheBrowserPrefix = browser.webkit ? '-webkit-':
        browser.msie ? '-ms-': browser.firefox ? '-moz-': '';
    return _cacheBrowserPrefix;
  }
  static String _cacheBrowserPrefix;

  //Checks if the property's name is allowed to access directly
  static void _check(String propertyName) {
    if (_illnms == null) {
      _illnms = new Set();
      for (final String nm in const [
        "left", "top", "right", "bottom", "width", "height"]) {
        _illnms.add(nm);
      }
    }
    
    if (_illnms.contains(propertyName))
      throw new UIException("$propertyName not allowed. Please use View's API instead, such as left and width.");
    if (propertyName.startsWith("margin"))
      throw const UIException("You can't change margin");
  }
  //Illegal names (that are not allowed to access directly
  static Set<String> _illnms;

  //Converts null to an empty string
  String _unwrap(String value) => value != null ? value: "";
    //TODO: test helloworld to see if Dart fixes Issue 2154
}
