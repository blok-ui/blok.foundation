package blok.foundation.core;

import blok.context.Context;

@:fallback(instance())
class PortalContext implements Context {
	public static function instance() {
		static var context:Null<PortalContext> = null;

		if (context == null) context = new PortalContext(
			#if (js && !nodejs)
			js.Browser.document.getElementById('portal')
			#else
			new blok.html.server.ElementPrimitive('div', {id: 'portal'})
			#end
		);

		return context;
	}

	public final target:Dynamic;

	public function new(target) {
		this.target = target;
	}

	public function dispose() {
		// noop
	}
}
