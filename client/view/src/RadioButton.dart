//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  6:01:59 PM
// Author: tomyeh

/**
 * A radio button.
 *
 * To group a collection of radio buttons, you have to create an instance of [RadioGroup]
 * to represent then group and then handle the select event, [SelectEvent],
 * for the radio group (note: not the check event).
 * You don't need to handle radio buttons seperately.
 *
 *     radioGroup.on.select.add((SelectEvent event) {
 *       ...
 *     });
 *
 * To associate a radio button, you can make a radio button as a descendant
 * of a radio group, or you can assign it explicitly with [radioGroup].
 * 
 * ##Events##
 *
 * + check: an instance of [CheckEvent] indicates the check state is changed.
 */
class RadioButton<E> extends CheckBox<E> {
  RadioGroup _group;

  RadioButton([String text="", String html="", bool checked=false, E value]):
  super(text, html, checked, value) {
  }

  //@Override
  String get className() => "RadioButton"; //TODO: replace with reflection if Dart supports it

  /** Returns the radio group that this radio button belongs to.
   * If no radio group is assigned, it assumed to be the nearest
   * ancestor radio group.
   */
  RadioGroup get radioGroup() {
    return _group !== null ? _group: _groupOf(this);
  }
  /** Sets the radio group that this radio button belongs to.
   * You don't need to invoke this method if the radio group is ancestor of this radio button.
   */
  void set radioGroup(RadioGroup group) {
    final RadioGroup oldgroup = radioGroup;

    _group = group;

    group = radioGroup;
    if (group !== oldgroup)
      _groupChanged(oldgroup, group);
  }

  //@Override
  void set checked(bool checked) {
    _setChecked(checked, true); //yes, sync the radio group
  }
  void _setChecked(bool checked, bool updateGroup) {
    if (_checked != checked) {
      super.checked = checked;

      if (updateGroup) {
        RadioGroup group = radioGroup;
        if (group !== null)
          group._updateSelected(this, checked);
      }
    }
  }
  //@Override
  void onCheck_() {
    assert(_checked); //it must be checked for radio button

    final CheckEvent event = new CheckEvent(this, _checked);
    sendEvent(event);

    final RadioGroup group = radioGroup;
    if (group !== null) {
      RadioButton selItem = group.selectedItem;
      group._updateSelected(this, _checked);

      if (selItem !== null) //notify the previous radio button
        selItem.sendEvent(new CheckEvent(selItem, !_checked));

      //note: we have to use List rather than Set since 1) value might be null,
      //2) the order might be different
      final List<RadioButton> selItems = new List();
      final List<E> selValues = new List();
      if ((selItem = group.selectedItem) !== null) {
        selItems.add(selItem);
        selValues.add(selItem.value);
      }
      group.sendEvent(new SelectEvent(group, selItems, selValues));
    }
  }
  //@Override
  void onParentChanged_(View oldParent) {
    super.onParentChanged_(oldParent);

    if (_group === null)
      _groupChanged(_groupOf(oldParent), _groupOf(parent));
  }
  RadioGroup _groupOf(View view) {
    for (;; view = view.parent)
      if (view === null || view is RadioGroup)
        return view;
  }
  void _groupChanged(RadioGroup oldgroup, RadioGroup newgroup) {
    if (checked) {
      if (oldgroup !== null)
        oldgroup._updateSelected(this, false);

      if (newgroup !== null) {
        if (newgroup.selectedItem !== null)
          _setChecked(false, false);
        else
          newgroup._updateSelected(this, true);
      }
      final InputElement n = inputNode;
      if (n !== null)
        n.name = newgroup !== null ? newgroup.uuid: "";
    }
  }

  //@Override
  String get domInputType_() => "radio";
  //@Override
  /** Default: [radioGroup]'s UUID.
   */
  String get domInputName_() {
    final RadioGroup group = radioGroup;
    return group != null ? group.uuid: null;
  }
}
