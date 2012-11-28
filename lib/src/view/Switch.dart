//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 18, 2012  9:46:29 AM
// Author: tomyeh
part of rikulo_view;

/**
 * A switch button that the user can turn an option on or off.
 *
 * ##Events
 *
 * + change: an instance of [ChangeEvent] indicates the check state is changed.
 *
 * ##Styles
 *
 * To create a smaller switch, you can assign `"v-small"` to it. For example,
 *
 *     new Switch().classes.add("v-small");
 */
class Switch extends View implements Input<bool> {
  String _onLabel, _offLabel;
  DragGesture _dg;
  bool _value = false, _disabled = false;

  /** Instantaites a switch.
   */
  Switch([bool value, String onLabel, String offLabel]) {
    _value = _b(value);
    _onLabel = onLabel != null ? onLabel: "ON";
    _offLabel = offLabel != null ? offLabel: "OFF";
  }

  /** Returns whether it is value (i.e., the switch is ON).
   *
   * Default: false.
   */
  bool get value => _value;
  /** Sets whether it is value (i.e., the switch is ON).
   */
  void set value(bool value) {
    _setValue(value);
  }

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled => _disabled;
  /** Sets whether it is disabled.
   */
  void set disabled(bool disabled) {
    _disabled = disabled;

    if (disabled)
      classes.add("v-disabled");
    else
      classes.remove("v-disabled");
  }

  /** Returns the label to indicate the switch is ON.
   */
  String get onLabel => _onLabel;
  /** Returns the label to indicate the switch is OFF.
   */
  String get offLabel => _offLabel;

  Element get _sdNode => getNode('sd');
  Element get _bgNode => getNode('bg');
  int get _marginDiff => 1 - (realHeight >> 1); //-(radius - 1) (border)
  /** X offset for the OFF label. */
  int get _x_off => realWidth - realHeight; //-(width - 2 * radius)
  void _setValue(bool value, [bool bAnimate=false, bool bSendEvent=false]) {
    final bool bChanged = _value != (value = _b(value));
    _value = value;
    if (inDocument) {
      final int nofs = _value ? 0 : -_x_off;
      if (bAnimate) {
        final int sofs = _translate3dXValue(_sdNode.style.transform);
        final int dofs = nofs - sofs;
        new EasingMotion((num x, MotionState state) {
          int cofs = sofs + (dofs * x).toInt();
          _updateBg(cofs);
        }, period: 150).run();
      } else {
        _updateBg(nofs);
      }
    }
    if (bSendEvent && bChanged)
      sendEvent(new ChangeEvent(_value));
  }
  void _updateBg(int delta) {
    _sdNode.style.transform = Css.translate3d(delta, 0);
    _bgNode.style.marginLeft = Css.px(delta + _marginDiff);
  }
  int _translate3dXValue(String str) => str == null ? 0 : Css.intOf(str.substring(12));
  
  int _snapDrag(num value) => max(min(value, 0), -_x_off).toInt();
  
  void mount_() {
    super.mount_();

    _setValue(_value);
    bool moved = false;
    int mgoff;
    _dg = new DragGesture(_sdNode,
      start: (state) {
        mgoff = Css.intOf(_bgNode.style.marginLeft) - _marginDiff;
        moved = false;
        
      }, move: (state) {
        _updateBg(_snapDrag(state.transition.x + mgoff));
        moved = true;
        
      }, end: (state) {
        _setValue(moved ? (state.transition.x + mgoff) > (-(_x_off>>1)) : !_value, true, true);
        
      });
  }
  void unmount_() {
    _dg.destroy();
    _dg = null;
    super.unmount_();
  }
  void onLayout_(MeasureContext mctx) { //Issue 5: if its parent's visible is changed
    //we call it before super.onLayout_, i.e., before sending event out
    //Note: overriding doLayout_ can't control between layouted and send event
    _setValue(_value);
    super.onLayout_(mctx);
  }

  //@override
  Element render_()
  => new Element.html(
      new StringBuffer().add('<div><div class="v-bg"><div class="v-bgi" id="')
        .add(uuid).add('-bg"></div></div><div class="v-slide" id="')
        .add(uuid).add('-sd"><div class="v-text-on v-button">')
        .add(onLabel).add('</div><div class="v-text-off v-button">')
        .add(offLabel).add('</div><div class="v-knot"></div></div></div>')
        .toString());

  /** Returns false to indicate this view doesn't allow any child views.
   */
  //@override
  bool get isViewGroup => false;
  String toString() => "$className($value)";
}
