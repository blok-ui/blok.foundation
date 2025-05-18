package blok.foundation.float;

import blok.engine.*;
import blok.foundation.core.*;

class Popover extends Component {
	@:attribute final attachment:PositionedAttachment;
	@:attribute final gap:Int = 0;
	@:attribute final getTarget:Null<() -> Dynamic> = null;
	@:children @:attribute final child:Child;

	function render() {
		return AutomaticPortal.wrap(Positioned.node({
			// getTarget: getTarget ?? () -> __slot.host.getOwnPrimitive(),
			getTarget: getTarget ?? () -> investigate()
				.findAncestorOfType(PrimitiveView)
				.map(view -> view.firstPrimitive())
				.orThrow(),
			gap: gap,
			attachment: attachment,
			child: child
		}));
	}
}
