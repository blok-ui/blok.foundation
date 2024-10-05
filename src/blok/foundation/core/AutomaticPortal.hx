package blok.foundation.core;

import blok.ui.*;

/**
	The AutomaticPortal will attempt to place a child in the target provided
	by a PortalContext *or* it will create a new container primitive, mount
	it in the Root, and use that as the target.

	This likely has some major problems, but it's here as a starting point.
**/
class AutomaticPortal extends Component {
	public inline static function wrap(child) {
		return node({child: child});
	}

	@:children @:attribute final child:() -> Child;

	var managedTarget:Maybe<Dynamic> = None;

	function render():Child {
		var target = switch managedTarget {
			case None:
				PortalContext
					.maybeFrom(this)
					.map(portal -> portal.target)
					.or(() -> {
						var adaptor = getAdaptor();
						var target = adaptor.createContainerPrimitive({'id': 'blok_portal__${new UniqueId()}'});
						var root = findAncestorOfType(Root).orThrow();

						adaptor.insertPrimitive(target, null, () -> root.getPrimitive());
						addDisposable(() -> adaptor.removePrimitive(target, null));

						managedTarget = Some(target);

						target;
					});
			case Some(target):
				target;
		}
		return Portal.wrap(target, child);
	}
}
