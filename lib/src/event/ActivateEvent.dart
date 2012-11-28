//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, May 10, 2012  3:33:05 PM
// Author: tomyeh
part of rikulo_event;

/**
 * An event to indicate activation.
 * It is a broadcast event used to notify root views and any listeners
 * that a view or an element is *activated*. By activated it means the view
 * or the element will become the *focal point* for users to interact with.
 * For example, it happens when the user clicks on a view or an element
 * (it is done automatically).
 * If the application wants to bring some view to the top, it can broadcast
 * this event too.
 *
 *     broadcaster.sendEvent(new ActivateEvent(activatedView));
 *
 * Views that acts as popups shall then dismiss themselves when receiving this event.
 * For example,
 *
 *     class Popup extends View {
 *       Popup() {
 *         on.activate.add((event) {
 *           if (event.shallClose(this))
 *             remove();
 *         });
 *       }
 *     }
 *
 * If the popup is not the root view, it has to register an event listener to
 * [broadcaster].
 *
 * > By popup we mean a UI object that is shown up
 * only in short period of time, and dismissed as soon as the user takes an action.
 * Typical examples include a popup menu and an information bubble.
 */
class ActivateEvent extends ViewEvent {
  final _source;

  /** Constructor.
   * The source parameter is either an instance of [View], a DOM element, or null.
   * If null, it means all pop ups shall be closed.
   */
  ActivateEvent(var source, [String type="activate"]):
  super(type), _source = source {
  }
  /** Returns the UI object triggers this event.
   * It is either a view or a DOM element.
   */
  get source => _source;

  /** Whether the given view or element shall be closed.
   *
   * + [popup] is either a view or an element.
   */
  bool shallClose(popup) {
    if (source == null)
      return true;

    var srcNode, popNode;
    if (source is View) {
      if (popup is View)
        return !source.isDescendantOf(popup);
      srcNode = source.node;
      popNode = popup;
    } else {
      srcNode = source;
      popNode = popup is View ? popup.node: popup;
    }
    return !new DomAgent(srcNode).isDescendantOf(popNode);
  }
}
