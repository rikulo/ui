//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 18, 2012  9:46:29 AM
// Author: tomyeh

/**
 * A switch button.
 */
class Switch extends View {
  String _onLabel, _offLabel;
  EventListener _clickListener;
  bool _checked = false, _disabled = false;

  static final int _X_OFF = -44;

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
    _checked = checked;

    if (inDocument) {
      node.query('.v-inner').style.setProperty(CSS.name('transform'),
        CSS.translate3d(_checked ? 0: _X_OFF, 0));
    }
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

  void enterDocument_() {
    super.enterDocument_();
    //TODO: handle touch/drag
    node.on.click.add(_initClickListener());
  }
  void exitDocument_() {
    node.on.click.remove(_clickListener);
    super.exitDocument_();
  }
  void _initClickListener() {
    if (_clickListener === null)
      _clickListener = (event) {
        checked = !checked; //TODO: animation
      };
    return _clickListener;
  }

  void domInner_(StringBuffer out) {
    out.add('<div class="v-inner" style="')
      .add(CSS.name('transform')).add(':')
      .add(CSS.translate3d(_checked ? 0: _X_OFF, 0)).add('"')
      .add('><div class="v-text-on">')
      .add(onLabel).add('</div><div class="v-text-off">')
      .add(offLabel).add('</div><div class="v-knot"></div></div>');
  }

  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isChildable_() => false;
  String toString() => "$className($checked)";
}
