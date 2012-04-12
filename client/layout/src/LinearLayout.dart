//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 15, 2012  4:48:10 PM
// Author: tomyeh

/**
 * The linear layout.
 */
class LinearLayout extends AbstractLayout {
	String getDefaultProfileProperty(View view, String name) {
		switch (name) {
		case "height":
			if (_isHorizontal(view))
				return "content";
			//fall thru
		case "width":
			return "flex"; //no matter horizontal or vertical
		}
		return "";
	}

	static bool _isHorizontal(view) => view.layout.orient != "vertical";  //horizontal is default
	static _LinearLayout _getRealLayout(view)
	=> _isHorizontal(view) ? new _HLayout(): new _VLayout();

	int measureWidth(MeasureContext mctx, View view) {
		int width = mctx.widths[view];
		if (width !== null || mctx.widths.containsKey(view))
			return width;

		return mctx.widths[view] = _getRealLayout(view).measureWidth(mctx, view);
	}
	int measureHeight(MeasureContext mctx, View view) {
		int height = mctx.heights[view];
		if (height !== null || mctx.heights.containsKey(view))
			return height;

		return mctx.heights[view] = _getRealLayout(view).measureHeight(mctx, view);
	}
	void layout(MeasureContext mctx, View view) {
		if (view.firstChild !== null) {
			final AnchorRelation ar = new AnchorRelation(view);

			//1) layout independents
			_getRealLayout(view).layout(mctx, view, ar.indeps);

			//2) do anchored
			ar.layoutAnchored(mctx);

			//3) pass control to children
			for (final View child in view.children)
				child.doLayout(mctx);
		}
	}

	//Utilities//
	static final int DEFAULT_AMOUNT = 30;
	static final int DEFAULT_SPACING = 2;
	static _AmountInfo getDefaultAmountInfo(String info, int defValue) {
		final _AmountInfo amt = new _AmountInfo(info);
		if (amt.type == _AmountInfo.NONE) {
			amt.type = _AmountInfo.FIXED;
			amt.value = defValue;
		}
		return amt;
	}
}
interface _LinearLayout {
	int measureWidth(MeasureContext mctx, View view);
	int measureHeight(MeasureContext mctx, View view);
	void layout(MeasureContext mctx, View view, List<View> children);
}
