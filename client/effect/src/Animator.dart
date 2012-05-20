//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 18, 2012  7:12:55 PM
// Author: tomyeh

/** An animation callbak.
 * To start an animation, you can add a callback to [Animator], such that
 * the callback will be called periodically until the callback returns false.
 *
 * <p>To add an animation, please invoke [Animator.add]. If the callback
 * returns false, it will be removed from the animator automatially.
 * If you'd like, you can remove it manually by use of [Animator.remove].
 *
 * <p>[time] is the milliseconds from 1970-01-01 (UTC).
 * In other words, it is the same as <code>new Date.now().value</code>.
 * [elapsed] is the number of milliseconds elapsed since the previous
 * invocation.
 */
typedef bool Animate(int time, int elapsed);

/**
 * The animator used to play [Animate].
 */
interface Animator default _Animator {
	Animator();

	/** Adds an animation callback, such that it will be
	 * called periodically.
	 * <p>Notice it is suggested not to add the same animation callback twice
	 * (though this method doesn't check if there is a duplicate).
	 */
	void add(Animate animate);
	/** Removes this animation callback.
	 * <p>It is called automatically, if the callback returns false.
	 */
	void remove(Animate animate);
	/** Returns a readonly collection of all animation callbacks.
	 */
	Collection<Animate> get animates();
}

class _Animator implements Animator {
	final List<Animate> _anims;
	//Used to hold new added animation callback when callbacks are processed
	//(to avoid dead loop).
	List<Animate> _tmpAdded;
	//Used to hold deleted animation callback when callbacks are processed
	//(so the for loop is faster to operate)
	Set<Animate> _tmpRemoved;
	Function _callback;
	int _prevTime;

	_Animator(): _anims = new List() {
		_callback = (num now) {
			if (!_anims.isEmpty()) {
				final int inow = now === null ? _now(): now.toInt();
				final int diff = inow - _prevTime;
				_prevTime = inow;

				_beforeCallback();
				try {
					//Note: _anims won't be changed by [add]/[remove]
					//after _beforeCallback is called
					for (int j = 0, len = _anims.length; j < len; ++j) {
						if (!_tmpRemoved.contains(_anims[j]) && !_anims[j](inow, diff)) {
							_anims.removeRange(j, 1);
							--j;
							--len;
						}
					}
				} finally {
					_afterCallback();
				}

				if (!_anims.isEmpty())
					window.requestAnimationFrame(_callback);
			}
		};
	}
	void _beforeCallback() {
		_tmpAdded = new List();
		_tmpRemoved = new Set();
	}
	void _afterCallback() {
		final List<Animate> added = _tmpAdded;
		final Set<Animate> removed = _tmpRemoved;
		_tmpAdded = null;
		_tmpRemoved = null;

		for (final Animate animate in added) {
			add(animate);
		}
		for (final Animate animate in removed) {
			remove(animate);
		}
	}

	void add(Animate animate) {
		if (_tmpAdded !== null) {
			//don't add it immediately to avoid dead loop if app doesn't do it wrong
			_tmpRemoved.remove(animate);
			_tmpAdded.add(animate);
			return;
		}

		_anims.add(animate);
		if (_anims.length == 1) {
			_prevTime = _now();
			window.requestAnimationFrame(_callback);
		}
	}
	void remove(Animate animate) {
		int j = _anims.indexOf(animate);
		if (_tmpRemoved !== null) {
			//don't remove from _anims since _callback assumes it
			if (j < 0) {
				j = _tmpAdded.indexOf(animate);
				if (j >= 0)
					_tmpAdded.removeRange(j, 1);
				return;
			}

			_tmpRemoved.add(animate);
			return;
		}

		if (j >= 0)
			_anims.removeRange(j, 1);
	}
	Collection<Animate> get animates() => _anims;	//TODO: readonly

	static int _now() => new Date.now().value;
}
