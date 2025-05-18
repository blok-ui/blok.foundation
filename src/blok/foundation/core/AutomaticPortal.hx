package blok.foundation.core;

import blok.*;

/**
	The AutomaticPortal will attempt to place a child in the target provided
	by a PortalContext *or* it will create a new container primitive, mount
	it in the Root, and use that as the target. This is a safe alternative
	to relying on PortalContext.
**/
class AutomaticPortal extends Component {
	public inline static function wrap(child) {
		return node({child: child});
	}

	@:children @:attribute final child:Child;

	function render():Child {
		var target = PortalContext
			.maybeFrom(this)
			.map(portal -> portal.target)
			.or(createPortalInRoot);
		return Portal.wrap(target, child);
	}

	function createPortalInRoot() {
		var root = Root.from(this);
		var container = root.adaptor.createContainerPrimitive();
		root.adaptor.siblings(root.primitive).insert(container);
		addDisposable(() -> root.adaptor.removePrimitive(container));
		return container;
	}
}
