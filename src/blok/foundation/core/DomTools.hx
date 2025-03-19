package blok.foundation.core;

import haxe.Constraints;
import js.html.*;

inline function addControlledEventListener(node:Node, name:String, listener:Function, controller:AbortController) {
	// @todo: The Haxe API seems incomplete and does not have the `signal`
	// option available, hence the need for `cast`.
	node.addEventListener(name, listener, cast {signal: controller.signal});
}
