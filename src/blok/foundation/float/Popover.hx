package blok.foundation.float;

import blok.*;
import blok.foundation.core.*;

class Popover extends Component {
	@:attribute final attachment:PositionedAttachment;
	@:attribute final gap:Int = 0;
	@:attribute final getTarget:Null<() -> Dynamic> = null;
	@:children @:attribute final child:Child;

	function render() {
		return AutomaticPortal.wrap(Positioned.node({
			getTarget: getTarget ?? () -> __slot.host.getOwnPrimitive(),
			gap: gap,
			attachment: attachment,
			child: child
		}));
	}
}
