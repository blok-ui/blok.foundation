package blok.foundation.core;

import blok.context.Context;

@:fallback(FocusContext.instance())
class FocusContext implements Context {
	static public function instance() {
		static var context:Null<FocusContext> = null;
		if (context == null) context = new FocusContext();
		return context;
	}

	#if (js && !nodejs)
	var previous:Null<js.html.Element> = null;
	#end

	public function new() {}

	public function focus(object:Dynamic) {
		#if (js && !nodejs)
		var el:js.html.Element = object;
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
