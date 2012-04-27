//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Apr 26, 2012  6:20:13 PM
// Author: tomyeh

/**
 * The configuration of views.
 */
class ViewConfig {
	/** The prefix used for [View.vclass].
	 * <p>Default: "v-".
	 */
	String vclassPrefix = "v-"; //TODO: built into View when Dart's mirror is done
	/** The prefix used for [View.uuid].
	 * <p>Default: an unique string in a window to avoid conficts among
	 * multiple Rikulo applications in the same page, if any.
	 */
	String uuidPrefix = "v_";

	/** Resets the states.
	 * It is used only by the simulator, such that [uuidPrefix] for an application
	 * won't be affected by whether there is a simulator.
	 * The application shall not invoke this method.
	 */
	void reset() {
		document.body.$dom_removeAttribute(_PREFIX_COUNT);
	}

	ViewConfig() {
		final Element body = document.body;
		if (body !== null) {
			String sval = body.$dom_getAttribute(_PREFIX_COUNT);
			if (sval !== null) {
				final int val = Math.parseInt(sval);
				uuidPrefix = "${StringUtil.encodeId(val, 'v')}_";
				body.$dom_setAttribute(_PREFIX_COUNT, (val + 1).toString());
			} else {
				body.$dom_setAttribute(_PREFIX_COUNT, "1");
			}
		}
	}
	static final String _PREFIX_COUNT = "data-rikuloPrefixCount";
}
ViewConfig viewConfig;
