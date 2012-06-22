//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 18, 2012  9:46:29 AM
// Author: tomyeh

/**
 * A switch button.
 */
class Switch extends View {
  String _onLabel, _offLabel;
  DragGesture _dg;
  bool _checked = false, _disabled = false;

  static final int _X_OFF = -44,
    _X_OFF_EX = -10; //to cover half of the knot

  /** Instantaites a switch.
   */
  Switch([bool checked, String onLabel, String offLabel]) {
    _checked = checked !== null && checked;
    _onLabel = onLabel !== null ? onLabel: "ON";
    _offLabel = offLabel !== null ? offLabel: "OFF";
  }
  //@Override
  String get className() => "Switch"; //TODO: replace with reflection if Dart supports it

  /** Returns whether it is checked (i.e., the switch is ON).
   *
   * Default: false.
   */
  bool get checked() => _checked;
  /** Sets whether it is checked (i.e., the switch is ON).
   */
  void set checked(bool checked) {
    _setChecked(checked);
  }

  /** Returns whether it is disabled.
   *
   * Default: false.
   */
  bool get disabled() => _disabled;
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
  String get onLabel() => _onLabel;
  /** Returns the label to indicate the switch is OFF.
   */
  String get offLabel() => _offLabel;

  Element get _sdNode() => getNode('sd');
  Element get _bgNode() => getNode('bg');
  void _setChecked(bool checked, [bool bAnimate=false, bool bSendEvent=false]) {
    final bool bChanged = _checked != checked;
    _checked = checked;
    if (inDocument) {
      //TODO: handle animation
      _sdNode.style.setProperty(CSS.name('transform'),
        CSS.translate3d(_checked ? 0: _X_OFF, 0));
      _updateBg(_checked ? 0: _X_OFF);
    }
    if (bSendEvent && bChanged)
      sendEvent(new CheckEvent(this, _checked));
  }
  void _updateBg(int delta) {
    _bgNode.style.marginLeft = CSS.px(delta + _X_OFF_EX);
  }

  void enterDocument_() {
    super.enterDocument_();

    _setChecked(_checked);
    _dg = new DragGesture(_sdNode, transform: true,
      range: () => new Rectangle(0, 0, _X_OFF, 0),
      start: (state) {
        state.data = CSS.intOf(_bgNode.style.marginLeft) - _X_OFF_EX;
        return state.gesture.owner;
      },
      moving: (state) {
        _updateBg(state.delta.x + state.data);
        return false;
      },
      end: (state) {
        _setChecked(state.moved ?
					(state.delta.x + state.data) > (_X_OFF>>1): !_checked,
					true, true);
        return true; //no more move
      });
  }
  void exitDocument_() {
    _dg.destroy();
    super.exitDocument_();
  }

  void domInner_(StringBuffer out) {
    out.add('<div class="v-bg"><div class="v-bgi" id="')
      .add(uuid).add('-bg"></div></div><div class="v-slide" id="')
      .add(uuid).add('-sd"><div class="v-text-on">')
      .add(onLabel).add('</div><div class="v-text-off">')
      .add(offLabel).add('</div><div class="v-knot"></div></div>');
  }

  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isChildable_() => false;
  String toString() => "$className($checked)";
}
