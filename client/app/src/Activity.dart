//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/** A switching effect for hiding [from] and displaying [to],
 * such as fade-out and slide-in.
 *
 * + [mask] is the element inserted between [from] and [to]. It is used
 * to block the access of [from].
 */
typedef void ViewSwitchEffect(View from, View to, Element mask);

/**
 * An activity is a UI, aka., a desktop, that the user can interact with.
 * An activity is identified with an URL.
 */
class Activity {
  String _title = "";
  View _mainView;
  final List<_DialogInfo> _dlgInfos;

  Activity(): _dlgInfos = [] {
    _title = application.name; //also force "get application()" to be called
  }

  /** Returns the main view.
   * The main view is the view the activity is working on.
   * A default view (an instance of [Section]) is created when [run]
   * is called. You can change it to any view you like at any time by
   * calling [set mainView].
   *
   * The main view is a root view, i.e., it doesn't have any parent.
   * In additions, its size has been adjusted to cover the whole screen
   * (or the whole DOM element specified in the containerId parameter of [run] if
   * there is one).
   */
  View get mainView() => _mainView;
  /** Sets the main view.
   */
  void set mainView(View main) {
    setMainView(main);
  }
  /** Sets the main view with an effect.
   */
  void setMainView(View main, [ViewSwitchEffect effect]) {
    if (main === null)
      throw const UIException("mainView can't be null");
    final View prevroot = _mainView;
    _mainView = main;
    if (prevroot !== null) {
      if (main.width === null)
        main.width = prevroot.width;
      if (main.height === null)
        main.height = prevroot.height;

      if (prevroot.inDocument) {
        main.addToDocument(before: prevroot.node);
        prevroot.removeFromDocument();
        //TODO: effect
      }
    }
  }

  /** Returns the topmost dialog, or null if no dialog at all.
   * A dialog is a view sitting on top of [mainView].
   * A dialog is also a root view, i.e., it has no parent.
   *
   * An activity has at most one [mainView], while it might have
   * any number of dialogs. To add a dialog, please use [addPopup].
   * The last added dialog will be on top of the rest, including [mainView].
   */
  View get currentDialog() => _dlgInfos.isEmpty() ? null: _dlgInfos[0].dialog;
  /** Adds a dialog. The dialog will become the topmost view and obscure
   * the other dialogs and [mainView].
   *
   * If specified, [effect] controls how to make the given dialog visible,
   * and the previous dialog or [mainView] invisible.
   *
   * To obscure the dialogs and mainView under it, a semi-transparent mask
   * will be inserted on top of them and underneath the given dialog.
   * You can control the transparent and styles by giving a different CSS
   * class with [maskClass]. If you don't want the mask at all, you can specify
   * `null` to [maskClass]. For example, if the dialog occupies
   * the whole screen, you don't have to generate the mask.
   */
  void addDialog(View dialog, [ViewSwitchEffect effect, String maskClass="v-mask"]) {
    if (dialog.inDocument)
      throw new UIException("Can't be in document: ${dialog}");

    final _DialogInfo dlgInfo = new _DialogInfo(dialog, maskClass);
    _dlgInfos.insertRange(0, 1, dlgInfo);

    if (_mainView !== null && _mainView.node !== null) { //dialog might be added in onCreate_()
      _createDialog(dlgInfo, effect);
      broadcaster.sendEvent(new PopupEvent(dialog));
    }
  }
  void _createDialog(_DialogInfo dlgInfo, [ViewSwitchEffect effect]) {
    final Element parent = _mainView.node.parent;
    dlgInfo.createMask(parent);
    dlgInfo.dialog.addToDocument(parent);
    //TODO: effect
  }
  /** Removes the topmost dialog or the given dialog.
   * If [dialog] is not specified, the topmost one is assumed.
   * If specified, [effect] controls how to make the given dialog invisible,
   * and make the previous dialog or [mainView] visible.
   *
   * It returns false if the given dialog is not found.
   */
  bool removeDialog([View dialog, ViewSwitchEffect effect]) {
    _DialogInfo dlgInfo;
    if (dialog === null) {
      if (_dlgInfos.isEmpty())
        throw const UIException("No dialog at all");

      dlgInfo = _dlgInfos[0];
      _dlgInfos.removeRange(0, 1);
    } else {
      int j = _dlgInfos.length;
      for (;;) {
        if (--j < 0)
          return false;

        dlgInfo = _dlgInfos[j];
        if (dialog == dlgInfo.dialog) {
          _dlgInfos.removeRange(j, 1);
          break;
        }
      }
    }

    if (dlgInfo.dialog.inDocument) {
      //TODO: effect
      dlgInfo.removeMask();
      dlgInfo.dialog.removeFromDocument();
      broadcaster.sendEvent(new PopupEvent(null));
    }
    return true;
  }

  /** Starts the activity.
   * By default, it creates [mainView] (if it was not created yet)
   * and has it to occupies the whole screen.
   *
   * If the DOM element specified in [containerId] is found, [mainView]
   * will only occupy the DOM element. It is useful if you'd like
   * to have multiple activities (i.e., Dart applications) running
   * at the same time and each of them handles only a portion of the
   * screen.
   */
  void run([String containerId="v-main"]) {
    if (activity !== null) //TODO: switching activity (from another activity)
      throw const UIException("Only one activity is allowed");

    activity = this;
    _init();

    if (_mainView === null)
      _mainView = new Section();
    _mainView.width = browser.size.width;
    _mainView.height = browser.size.height;
    _mainView.style.overflow = "hidden"; //crop

    application._ready(() {
      onCreate_();

      if (!_mainView.inDocument) { //app might add it to Document manually
        Element container = containerId !== null ? document.query("#$containerId"): null;
        _mainView.addToDocument(container != null ? container: document.body);

        //the user might add dialog in onCreate_()
        for (final _DialogInfo dlgInfo in _dlgInfos)
          _createDialog(dlgInfo);
      }

      onMount_();
    });
  }
  /** Initializes the browser window, such as registering the events.
   */
  void _init() {
    (browser.mobile || application.inSimulator ?
      window.on.deviceOrientation: window.on.resize).add((event) { //DOM event
        updateSize();
      });
    (browser.touch ? document.on.touchStart: document.on.mouseDown).add(
      (event) { //DOM event
        broadcaster.sendEvent(new PopupEvent(event.target));
      });
    Set<String> clses = document.body.classes;
    clses.add("rikulo");
    clses.add(browser.name);
    if (browser.ios) clses.add("ios");
    else if (browser.android) clses.add("android");
  }
  /** Handles resizing, including device's orientation is changed.
   * It is called automatically, so the application rarely need to call it.
   */
  void updateSize() {
    final Element caveNode = document.query("#v-main");
    final DOMQuery qcave = new DOMQuery(caveNode !== null ? caveNode: window);
    browser.size.width = qcave.innerWidth;
    browser.size.height = qcave.innerHeight;

    //Note: we have to check if the size is changed, since deviceOrientation
    //will be always fired when the listener is added.
    if (mainView !== null && (mainView.width != browser.size.width
    || mainView.height != browser.size.height)) {
      mainView.width = browser.size.width;
      mainView.height = browser.size.height;
      mainView.requestLayout();
    }
  }

  /** Returns the title of this activity.
   */
  String get title() => _title;
  /** Sets the title of this activity.
   */
  void set title(String title) {
    document.title = _title = title != null ? title: "";
  }

  /** Called when the activity is starting.
   * Before calling this method, [mainView] will be instantiated, but
   * it won't be attached to the document until this method has returned
   * (for better performaance).
   *
   * It means you can't access [Element.node] (such as adding a listener),
   * or any methods that depends on the DOM elements of the view.
   * To access the DOM elements of the view, you have to do it in [onMount_].
   *
   * If you prefer to instantiate a different main view, you can
   * create an instance and then assign to [mainView] directly.
   *
   * + See also [run] and [onMount_].
   */
  void onCreate_() {
  }
  /**Called after [onCreate_] is called and [mainView] has been
   * added to the document.
   *
   * Tasks that depends on DOM elements can be done in this method.
   */
  void onMount_() {
  }
  /** Called when the activity is going into background.
   * For example, it is called when there is an incoming phone call.
   *
   * It is meaningful only if it is running as a native mobile application,
   * and [enableDeviceAccess] has been called.
   */
  void onPause_() {
  }
  /** Called when the activity is resumed to start interacting
   * with the user.
   */
  void onResume_() {
  }
  /** Called when the activity is destroyed.
   */
  void onDestroy_() {
  }
}
/** The current activity. */
Activity activity;

class _DialogInfo {
  final View dialog;
  final String maskClass;
  Element _maskNode;
  EventListener _listener;

  _DialogInfo(View this.dialog, String this.maskClass);
  void createMask(Element parent) {
    if (maskClass !== null) {
      _maskNode = new Element.html(
        '<div class="v- ${maskClass}" style="width:${browser.size.width}px;height:${browser.size.height}px"></div>');
      if (!browser.mobile) {
        window.on.resize.add(_listener = (event) {
          _maskNode.style.width = CSS.px(browser.size.width);
          _maskNode.style.height = CSS.px(browser.size.height);
        });
      }

      parent.$dom_appendChild(_maskNode);
    }
  }
  void removeMask() {
    if (_maskNode !== null) {
      if (_listener !== null)
        window.on.resize.remove(_listener);
      _maskNode.remove();
    }
  }
}
