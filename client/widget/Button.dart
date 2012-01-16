//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012

/** A button.
 */
class Button extends Widget {
  String _label;

  Button([String label=""]) {
    wclass = "w-label";
    this.label = label;
    
  }
  Button.from(Map<String, Object> props): super.from(props);

  String get label() => this._label;
  void set label(String label) {
    this._label = label != null ? label: "";
  }
}
