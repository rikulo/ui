//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 26, 2012  6:20:13 PM
// Author: tomyeh

/** Returns a DOM-level event listener that converts a DOM event to a view event
 * ([ViewEvent]) and dispatch to the right target.
 */
typedef EventListener DOMEventDispatcher(View target);

/**
 * The configuration of views.
 */
class ViewConfig {
  /** The prefix used for the default style class of a view.
   *
   * Default: "v-".
   */
  String classPrefix = "v-";
  /** The prefix used for [View.uuid].
   *
   * Default: an unique string in a window to avoid conficts among
   * multiple Rikulo applications in the same page, if any.
   */
  String uuidPrefix = "v_";

  ViewConfig() {
    final int appid = application.uuid;
    if (appid > 0)
      uuidPrefix = "${StringUtil.encodeId(appid, 'v')}_";
  }
  static final String _PREFIX_COUNT = "data-rikuloPrefixCount";
}
ViewConfig viewConfig;

/** Used with [View]'s `domAttrs_` to control which attributes to generate.
 */
class DOMAttrsCtrl {
  bool noId, noStyle, noClass, noVisible, noDraggable;

  DOMAttrsCtrl([bool this.noId=false, bool this.noStyle=false,
    bool this.noClass=false, bool this.noVisible=false, bool this.noDraggable=false]);
}
/** Used with [View]'s `domStyle_` to control which styles to generate.
 */
class DOMStyleCtrl {
  bool noLeft, noTop, noWidth, noHeight, noStyle, noVisible;

  DOMStyleCtrl([bool this.noLeft=false, bool this.noTop=false,
    bool this.noWidth=false, bool this.noHeight=false,
    bool this.noStyle=false, bool this.noVisible=false]);
}