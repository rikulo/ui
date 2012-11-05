//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  9:56:30 AM
// Author: tomyeh
part of rikulo_layout;

/**
 * The layout mananger that manages the layout controllers ([Layout]).
 * There is exactly one layout manager per application.
 */
class LayoutManager extends RunOnceViewManager {
  final Map<String, Layout> _layouts;
  final Set<String> _imgWaits;
  final List<Task> _afters;
  int _inLayout = 0, _inCallback = 0;

  LayoutManager(): super(null), _layouts = {}, _imgWaits = new Set(), _afters = [] {
    addLayout("linear", new LinearLayout());
    addLayout("tile", new TileLayout());

    final freeLayout = new FreeLayout();
    addLayout("none", freeLayout);
    addLayout("", freeLayout);
  }

  /** Adds the layout for the given name.
   */
  Layout addLayout(String name, Layout clayout) {
    final Layout old = _layouts[name];
    _layouts[name] = clayout;
    return old;
  }
  /** Removes the layout of the given name if any.
   */
  Layout removeLayout(String name) {
    return _layouts.remove(name);
  }
  /** Returns the layout of the given name, or null if not found.
   */
  Layout getLayout(String name) {
    return _layouts[name];
  }
  /** Returns the type of the given layout, or null if it is not registered.
   */
  String getType(Layout layout) {
    for (final nm in _layouts.keys)
      if (layout == _layouts[nm])
        return nm;
  }

  /** Handles the layout of the given view.
   */
  void requestLayout(View view, bool immediate, bool descendantOnly) {
    if (!descendantOnly) {
      final View parent = view.parent;
      //Start the layout from parent only if necessary
      //Currently, we start from parent if in some layout, not anchored/popup
      if (view.profile.anchorView == null
      && parent != null && !parent.layout.type.isEmpty)
        view = parent; //start from parent (slower performance but safer)
    }

    if (immediate) flush(view, true); //yes, force the depended task to flush too
    else queue(view);
  }

  /** Returns whether the layout manager is handling the offset and dimension.
   *
   * Notice that it is also false in the event listener
   * (including 'layout' and 'preLayout').
   */
  bool get inLayout => _inLayout > 0 && _inCallback <= 0;

  //@override
  void flush([View view, bool force=false]) {
    //ignore flush if not empty (_onImageLoaded will invoke it later)
    if (_imgWaits.isEmpty)
      super.flush(view, force);
    else if (view != null)
      queue(view); //do it later
  }

  //@override
  void handle_(View view) {
    ++_inLayout;
    try {
      final mctx = new MeasureContext();
      mctx.preLayout(view); //note: onLayout is called by doLayout

      final parent = view.parent;
      if (parent == null) { //root without anchor
        //including anchored
        rootLayout(mctx, view);
      } else if (view.profile.anchorView != null) {
        new AnchorRelation(parent)
          ._layoutAnchored(mctx, view.profile.anchorView, view);
      } else if (parent.layout.type.isEmpty) {
        mctx.setWidthByProfile(view, () => parent.innerWidth);
        mctx.setHeightByProfile(view, () => parent.innerHeight);
      }

      doLayout(mctx, view);
    } finally {
      if (--_inLayout <= 0 && isQueueEmpty() && !_afters.isEmpty) {
        final List<Task> afters = new List.from(_afters);
        _afters.clear();
        for (final Task task in afters)
          task();
      }
    }
  }
  /** Schedules a task to be run after the layout is done.
   * If there is no pending layouts, it will be executed immediately.
   */
  void afterLayout(Task task) {
    if (_inLayout <= 0 && isQueueEmpty())
      task();
    else
      _afters.add(task);
  }

  /** Handles the layout of the given view.
   */
  void doLayout(MeasureContext mctx, View view) {
    if (view.visible) {
      view.layout.handler.doLayout(mctx, view);
      ++_inCallback;
      try {
        view.onLayout_(mctx);
      } finally {
        --_inCallback;
      }
    }
  }

  /** Wait until the given image is loaded.
   * If the width and height of the image is not known in advance, this method
   * shall be called to make the layout manager wait until the image is loaded.
   *
   * Currently, [Image] will invoke this method automatically
   * if the width or height of the image is not specified.
   */
  void waitImageLoaded(String imgURI) {
    if (imgURI != null && !imgURI.isEmpty && !_imgWaits.contains(imgURI)) {
      _imgWaits.add(imgURI);
      final ImageElement img = new Element.tag("img");
      var func = (event) { //DOM event
        _onImageLoaded(imgURI);
      };
      img.on.load.add(func);
      img.on.error.add(func);
      img.src = imgURI;
    }
  }
  void _onImageLoaded(String imgURI) {
    _imgWaits.remove(imgURI);
    if (_imgWaits.isEmpty)
      flush(); //flush all
  }
}

/** The layout manager.
 *
 * You can assign your own implementation if you'd like.
 */
LayoutManager layoutManager = new LayoutManager();
