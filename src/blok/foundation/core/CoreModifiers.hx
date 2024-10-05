package blok.foundation.core;

import blok.ui.Child;

inline function lockScroll(child:Child) {
	return ScrollLocked.node({child: child});
}
