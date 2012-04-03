//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 02, 2012  6:31:09 PM
// Author: tomyeh

typedef void _AnchorHandler(View anchor, View view);

/**
 * The anchor relationship.
 */
class AnchorRelation {
	/** A list of independent views. An independent view is a view whose
	 * position doesn't depend on others.
	 */
	final List<View> indeps;
	/** A map of an anchor view and a list of views that depends on the anchor.
	 */
	final Map<View, List<View>> anchored;
	/** the parent of this relation.
	 */
	final View parent;

	/** Contructors of the anchor relation of all children of the given view.
	 */
	AnchorRelation(View view) : indeps = new List(), anchored = new Map(), parent = view {
		for (final View v in view.children) {
			final View av = v.profile.anchorView;
			if (av == null) {
				indeps.add(v);
			} else {
				if (av.parent !== view && av !== view)
					throw new UiException("Anchor can be parent or sibling, not $av");

				List<View> deps = anchored[av];
				if (deps == null)
					anchored[av] = deps = new List();
				deps.add(v);
			}
		}
	}

	/** Handles the layout of the independent views.
	 */
	void layoutIndeps(MeasureContext mctx) {
		for (final View view in indeps) {
			//TODO size: view.measure(mctx);
		}
	}
	/** Handles the layout of the anchored views.
	 */
	void layoutAnchored(MeasureContext mctx) {
		_layoutAnchored(mctx, parent);
		for (final View view in indeps)
			_layoutAnchored(mctx, view);
	}
	void _layoutAnchored(MeasureContext mctx, View anchor) {
		final List<View> views = anchored[anchor];
		if (views !== null && !views.isEmpty()) {
			for (final View view in views) {
				//TODO size first: view.measure(mctx);

				//position:
				final String loc = view.profile.location;
				final List<int> xy = _locations[loc == null || loc.isEmpty() ? "south start": loc];
				if (xy == null)
					throw new UiException("Unknown loation ${loc}");

				_anchorXHandlers[xy[0]](anchor, view);
				_anchorYHandlers[xy[1]](anchor, view);
			}

			for (final View view in views) {
				_layoutAnchored(mctx, view); //recursive
			}
		}
	}
}
final Map<String, List<int>> _locations = const {
	"north start": const [1, 0], "north center": const [2, 0], "north end": const [3, 0],
	"south start": const [1, 4], "south center": const [2, 4], "south end": const [3, 4],
	"west start": const [0, 1], "west center": const [0, 2], "west end": const [0, 3],
	"east start": const [4, 1], "east center": const [4, 2], "east end": const [4, 3],
	"top left": const [1, 1], "top center": const [2, 1], "top right": const [3, 1],
	"center left": const [1, 2], "center center": const [2, 2], "center right": const [3, 2],
	"bottom left": const [1, 3], "bottom center": const [2, 3], "bottom right": const [3, 3]
};
//TODO: use const when Dart considers Closure as constant
//TODO: handle position:fixed
List<_AnchorHandler> get _anchorXHandlers() {
	if (_cacheXAnchorHandlers == null)
		_cacheXAnchorHandlers = [
			(View anchor, View view) {
				view.left = (anchor === view.parent ? 0: anchor.left) - view.width;
			},
			(View anchor, View view) {
				view.left = anchor === view.parent ? 0: anchor.left;
			},
			(View anchor, View view) {
				view.left = (anchor === view.parent ? 0: anchor.left) + (anchor.width - view.width) ~/ 2;
			},
			(View anchor, View view) {
				view.left = (anchor === view.parent ? 0: anchor.left) + anchor.width - view.width;
			},
			(View anchor, View view) {
				view.left = (anchor === view.parent ? 0: anchor.left) + anchor.width;
			}
		];
	return _cacheXAnchorHandlers;
}
List<_AnchorHandler> _cacheXAnchorHandlers;
List<_AnchorHandler> get _anchorYHandlers() {
	if (_cacheYAnchorHandlers == null)
		_cacheYAnchorHandlers = [
			(View anchor, View view) {
				view.top = (anchor === view.parent ? 0: anchor.top) - view.height;
			},
			(View anchor, View view) {
				view.top = anchor === view.parent ? 0: anchor.top;
			},
			(View anchor, View view) {
				view.top = (anchor === view.parent ? 0: anchor.top) + (anchor.height - view.height) ~/ 2;
			},
			(View anchor, View view) {
				view.top = (anchor === view.parent ? 0: anchor.top) + anchor.height - view.height;
			},
			(View anchor, View view) {
				view.top = (anchor === view.parent ? 0: anchor.top) + anchor.height;
			}
		];
	return _cacheYAnchorHandlers;
}
List<_AnchorHandler> _cacheYAnchorHandlers;
