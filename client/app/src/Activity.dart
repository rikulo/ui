//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Mar 09, 2012  7:47:30 PM
// Author: tomyeh

/** An interface to handle visual effect of switching main view from [oldView]
 * to [newView]. It is usually implemented by determining a [Motion]. At the 
 * end of the effect, the callback [end] has to be invoked.
 */
typedef void ViewSwitchEffect(View oldView, View newView, void end());

/**
 * An activity is a UI that the user can interact with.
 * Each activity has a main view called [mainView]. It is the root of
 * the hierarchy tree of views that builds the UI for an activity.
 *
 * To instantiate UI, you have to extend this class and override [onCreate_] to
 * compose your UI and attach it to [mainView] (or replace it).
 *
 *     class HelloWorld extends Activity {
 *       void onCreate_() {
 *         title = "Hello World!";
 *     
 *         TextView welcome = new TextView("Hello World!");
 *         welcome.profile.text = "anchor:  parent; location: center center";
 *         mainView.addChild(welcome);
 *       }
 *     }
 *
 * By default, [mainView] will occupy the whole screen. If you want it to be a part
 * of the screen, you can define an element in the HTML page (that loads the dart
 * application) and assign it the dimension you want and an id called `v-main`. For example,
 *
 *     <link rel="stylesheet" type="text/css" href="../../resources/css/view.css" />
 *     <div id="v-main" style="width:100%;height:200px"></div>
 *     <script type="application/dart" src="HelloWorld.dart"></script>
 *     <script src="../../resources/js/dart.js"></script>
 *
 * If you want to embed multiple application in the same HTML page, you can assign
 * the elements with a different ID, and then invoke [run] with the ID you assigned.
 */
class Activity {
  String _title = "";
  View _mainView;
  final List<_DialogInfo> _dlgInfos;
  final List<Mask> _masks;
  Element _container;
  bool _creating = true;

  Activity() : _dlgInfos = [], _masks = [] {
    _title = application.name; //also force "get application" to be called
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
  View get mainView => _mainView;
  /** Sets the main view.
   */
  void set mainView(View main) {
    setMainView(main);
  }
  /** Sets the main view with an effect.
   */
  void setMainView(View main, [ViewSwitchEffect efactory]) {
    if (main == null)
      throw const UIException("mainView can't be null");
    final View prevroot = _mainView;
    _mainView = main;
    if (prevroot != null) {
      if (!ViewImpl.isSizedByApp(main, Dir.HORIZONTAL)) {
        main.width = browser.size.width; //better to browser's size than prevroot's
        ViewImpl.sizedInternally(main, Dir.HORIZONTAL);
      }
      if (!ViewImpl.isSizedByApp(main, Dir.VERTICAL)) {
        main.height = browser.size.height;
        ViewImpl.sizedInternally(main, Dir.VERTICAL);
      }

      if (prevroot.inDocument) {
        Mask mask = efactory != null ? new Mask() : null;
        main.addToDocument(before: prevroot.node,
          shallLayout: !_creating || efactory != null);
          //no need to layout if no effect and in onCreate_
        if (efactory != null) {
          efactory(prevroot, main, () {
            prevroot.removeFromDocument();
            mask.destroy();
          });
        } else {
          prevroot.removeFromDocument();
        }
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
  View get currentDialog => _dlgInfos.isEmpty() ? null: _dlgInfos[0].dialog;
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

    final Element parent = new DivElement();
    parent.style.position = "relative";
      //we have to create a relative element to enclose dialog
      //since layout assumes it (test case: TestPartial.html)
    _mainView.node.parent.nodes.add(parent);
    dlgInfo.createMask(parent);
    dlgInfo.dialog.addToDocument(parent);
    //TODO: effect

    broadcaster.sendEvent(new PopupEvent(dialog));
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
    if (dialog == null) {
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

    final Element parent = dlgInfo.dialog.node.parent;
    dlgInfo.dialog.removeFromDocument();
    dlgInfo.removeMask();
    parent.remove();
    broadcaster.sendEvent(new PopupEvent(null));
    return true;
  }

  /** Returns the DOM element that contains this activity.
   * It is null (by default).
   *
   * If there is a DOM element that matches the `containerId` argument when [run] is
   * called. The DOM element is assumed to be the container, and the activity
   * will be limited to it.
   */
  Element get container => _container;

  /** Starts the activity.
   * By default, it creates [mainView] (if it was not created yet)
   * and has it to occupies the whole screen.
   *
   * + [containerId] specifies the element's ID that the activity shall be displayed
   * inside it. If the DOM element specified in [containerId] is found, [mainView]
   * will only occupy the DOM element. It is useful if you'd like
   * to have the activity occupying only a part of the screen. The DOM element
   * containing this activity will be stored in [container].
   */
  void run([String containerId="v-main"]) {
    if (activity != null) //TODO: switching activity (from another activity)
      throw const UIException("Only one activity is allowed");
    if (_mainView != null)
      throw const UIException("run() called twice?");

    activity = this;

    application._ready(() {
      _init(containerId);

      onCreate_();
      _creating = false;
      _mainView.requestLayout(immediate: true); //to avoid 'flash' (caused by timeout)
    });
  }
  /** Initializes the browser window, such as registering the events.
   */
  void _init(String containerId) {
    _container = containerId != null ? document.query("#$containerId"): null;

    Set<String> clses = _container != null ? _container.classes: document.body.classes;
    clses.add("rikulo");
    clses.add(browser.name);
    clses.add(browser.touch ? "touch": "desktop");
    if (browser.ios) clses.add("ios");
    else if (browser.android) clses.add("android");

    if (_container != null)
      updateSize();

    _mainView = new Section();
    _mainView.width = browser.size.width;
    _mainView.height = browser.size.height;
    ViewImpl.sizedInternally(_mainView, Dir.HORIZONTAL);
    ViewImpl.sizedInternally(_mainView, Dir.VERTICAL);
    _mainView.addToDocument(_container != null ? _container: document.body, shallLayout: false);

    window.on.resize.add(_onResize);
    (browser.touch ? document.on.touchStart: document.on.mouseDown).add(_onTouchStart);
  }
  EventListener get _onResize {
    if (browser.android) {
    //Android: resize will be fired when virtual keyboard showed up
    //so we have to ignore this case: width must be changed, or height is larger
    //(since user might bring up kbd, rotate, and close kbd)
      Size old = new DOMQuery(window).innerSize;
      return (event) { //DOM event
          final cur = new DOMQuery(window).innerSize;
          if (old.width != cur.width || old.height < cur.height) {
            old = cur;
            updateSize();
          }
        };
    } else {
      return (event) { //DOM event
          updateSize();
        };
    }
  }
  static EventListener get _onTouchStart {
    return (event) { //DOM event
        broadcaster.sendEvent(new PopupEvent(event.target));
      };
  }

  /** Updates the browser's size. It is called when the browser's size
   * is changed (including device's orientation is changed).
   *
   * Notice that it is called automatically, so the application rarely need to call it.
   */
  void updateSize() {
    final oldsz = new Size.from(browser.size);
    final DOMQuery qcave = new DOMQuery(_container != null ? _container: window);
    browser.size = new Size(qcave.innerWidth, qcave.innerHeight);
    if (oldsz != browser.size) {
    //Note: we have to check if the size is changed, since deviceOrientation
    //is fired continuously once the listener is added
      if (_mainView != null) {
        bool changed = false;
        if (!ViewImpl.isSizedByApp(_mainView, Dir.HORIZONTAL)) {
          _mainView.width = browser.size.width;
          ViewImpl.sizedInternally(_mainView, Dir.HORIZONTAL);
          changed = true;
        }
        if (!ViewImpl.isSizedByApp(_mainView, Dir.VERTICAL)) {
          _mainView.height = browser.size.height;
          ViewImpl.sizedInternally(_mainView, Dir.VERTICAL);
          changed = true;
        }
        if (changed)
          _mainView.requestLayout();
      }
      for (_DialogInfo dlgInfo in _dlgInfos) {
        dlgInfo.resizeMask();
        dlgInfo.dialog.requestLayout();
      }
      for (Mask mask in _masks)
        mask.resize();
    }
  }

  /** Returns the title of this activity.
   */
  String get title => _title;
  /** Sets the title of this activity.
   */
  void set title(String title) {
    document.title = _title = title != null ? title: "";
  }

  /** Called when the activity is starting.
   * You can override this method to create the user interface.
   *
   * The UI you compose will be available to the user after you add it to
   * the hierarchy tree of [mainView].
   *
   * If you prefer to instantiate a different main view, you can
   * create a hierarchy tree of views, and then assign to [mainView] directly.
   * Thus, the hierarchy tree available to the user will become the one you assigned.
   *
   * ##Relation with DOM
   *
   * Before calling this method, [mainView] has been attached to the document.
   * It means all the views added the hierarchy tree of [mainView] will be
   * attached automatically.
   *
   * ##Performance Tips
   *
   * The performance is a little better if you compose UI without adding them
   * to the document first. To do so, you can simply add UI to [mainView] as
   * the last statement. However, the performance improvement is hardly
   * observable unless the UI is very complex (such as hundreds of views).
   */
  void onCreate_() {
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

  _DialogInfo(View this.dialog, String this.maskClass);
  void createMask(Element parent) {
    if (maskClass != null) {
      final Size sz = browser.size;
      _maskNode = new Element.html(
        '<div class="v- ${maskClass}" style="width:${sz.width}px;height:${sz.height}px"></div>');
      if (activity.container != null) {
        _maskNode.style.position = "absolute";
      }

      parent.$dom_appendChild(_maskNode);
    }
  }
  void resizeMask() {
    if (_maskNode != null) {
      _maskNode.style.width = CSS.px(browser.size.width);
      _maskNode.style.height = CSS.px(browser.size.height);
    }
  }
  void removeMask() {
    if (_maskNode != null) {
      _maskNode.remove();
    }
  }
}

/** An utility class for masking a certain area in browser window.
 */
class Mask {
  
  Element _node;
  final Element _masked;
  
  /** Create a mask to cover either full screen or a given [region].
   */
  Mask([Rectangle region, String maskClass]) : 
  this._init(region, null, maskClass);
  
  /// The Element used as mask.
  Element get node => _node;
  
  /** Create a mask to cover a given [element].
   */
  Mask.element(Element element, [String maskClass]) : 
  this._init(new DOMQuery(element).rectangle, element, maskClass);
  
  Mask._init(Rectangle region, Element element, String maskClass) : 
  _masked = element {
    
    final String c = maskClass == null ? "" : maskClass;
    _node = new Element.html('<div class="v- $c" style="position:absolute;"></div>');
    _updateRegion(_getRealRegion(region, element));
    
    activity._masks.add(this);
    
    Element ct = activity.container != null ? activity.container : document.body;
    ct.$dom_appendChild(_node);
  }
  
  static Rectangle _getRealRegion(Rectangle range, Element element) =>
      range != null ? range : element != null ? new DOMQuery(element).rectangle : 
        new Rectangle(0, 0, browser.size.width, browser.size.height);
  
  void _updateRegion(Rectangle range) {
    if (_node != null) {
      _node.style.left = CSS.px(range.left.toInt());
      _node.style.top = CSS.px(range.top.toInt());
      _node.style.width = CSS.px(range.width.toInt());
      _node.style.height = CSS.px(range.height.toInt());
    }
  }
  
  /** Re-calculate and update the mask position and size.
   */
  void resize() {
    if (_node != null && _masked != null)
      _updateRegion(new DOMQuery(_masked).rectangle);
  }
  
  /** Remove the mask.
   */
  void destroy() {
    if (_node != null)
      _node.remove();
    _node = null;
    
    List<Mask> list = activity._masks;
    list.removeRange(list.indexOf(this), 1);
  }
  
}

