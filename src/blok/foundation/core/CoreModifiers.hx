package blok.foundation.core;

import blok.Child;

inline function lockScroll(child:Child) {
	return ScrollLocked.node({child: child});
}
