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
		final int appid = application.uuid;
		if (appid > 0)
			uuidPrefix = "${StringUtil.encodeId(appid, 'v')}_";
	}
	static final String _PREFIX_COUNT = "data-rikuloPrefixCount";
}
ViewConfig viewConfig;
