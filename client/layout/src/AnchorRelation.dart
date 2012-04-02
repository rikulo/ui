//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 02, 2012  6:31:09 PM
// Author: tomyeh

/**
 * The anchor relationship.
 */
class AnchorRelation {
	final List<View> independences;
	final Map<View, List<View>> dependences;

	/** Contructors of the anchor relation of all children of the given view.
	 */
	AnchorRelation(View view) : independences = new List(), dependences = new Map() {
		for (final View v in view.children) {
			final View av = v.profile.anchorView;
			if (av == null) {
				independences.add(v);
			} else {
				List<View> deps = dependences[av];
				if (deps == null)
					dependences[av] = deps = new List();
				deps.add(v);
			}
		}
	}

	/** Handles the layout of the given list of views.
	 */
	void layout(List<View> views, Anchor anchor,
	[bool noSize=false, noPosition=false]) {
		for (final View view in views) {
			print("layout $view");
		}
	}
}
