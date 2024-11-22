package blok.foundation.float;

import blok.ui.*;
import blok.foundation.core.*;

using blok.adaptor.PrimitiveHostTools;

class Popover extends Component {
	@:attribute final attachment:PositionedAttachment;
	@:attribute final gap:Int = 0;
	@:attribute final getTarget:Null<() -> Dynamic> = null;
	@:children @:attribute final child:Child;

	function render() {
		return AutomaticPortal.wrap(Positioned.node({
			getTarget: getTarget ?? () -> this.findNearestPrimitive(),
			gap: gap,
			attachment: attachment,
			child: child
		}));
	}
}
