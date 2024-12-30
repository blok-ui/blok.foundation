package blok.foundation.core;

import blok.context.Context;

@:fallback(new FocusContext())
class FocusContext implements Context {
	#if (js && !nodejs)
	var previous:Null<js.html.Element> = null;
	#end

	public function new() {}

	public function focus(primitive:Dynamic) {
		#if (js && !nodejs)
		var el:js.html.Element = primitive;
		if (previous == null) {
			previous = el.ownerDocument.activeElement;
		}
		el.focus();
		#end
	}

	public function returnFocus() {
		#if (js && !nodejs)
		if (previous != null) {
			previous.focus();
			previous = null;
		}
		#end
	}

	public function dispose() {}
}
