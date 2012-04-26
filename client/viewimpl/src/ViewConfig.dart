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

	ViewConfig() {
		final Element body = document.body;
		if (body !== null) {
			String sval = body.$dom_getAttribute(_KEY_COUNT);
			if (sval !== null) {
				final int val = Math.parseInt(sval);
				uuidPrefix = "v${val}_";
				body.$dom_setAttribute(_KEY_COUNT, (val + 1).toString());
			} else {
				body.$dom_setAttribute(_KEY_COUNT, "1");
			}
		}
	}
	static final String _KEY_COUNT = "data-rikuloAppCount";
}
ViewConfig get viewConfig() {
	if (_cachedVConfig === null)
		_cachedVConfig = new ViewConfig();
	return _cachedVConfig;
}
ViewConfig _cachedVConfig;
