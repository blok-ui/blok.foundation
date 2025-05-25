package blok.foundation.float;

import blok.engine.*;
import blok.foundation.core.*;
import blok.foundation.animation.*;
import blok.foundation.layer.*;

class Popover extends Component {
	@:attribute final showAnimation:Keyframes = null;
	@:attribute final hideAnimation:Keyframes = null;
	@:attribute final transitionSpeed:Int = null;
	@:attribute final hideOnEscape:Bool = true;
	@:attribute final onShow:() -> Void = null;
	@:attribute final onHide:() -> Void = null;
	@:attribute final attachment:PositionedAttachment;
	@:attribute final gap:Int = 0;
	@:attribute final getTarget:Null<() -> Any> = null;
	@:children @:attribute final child:Child;

	function render() {
		return AutomaticPortal.wrap(Layer.node({
			showAnimation: showAnimation,
			hideAnimation: hideAnimation,
			hideOnEscape: hideOnEscape,
			transitionSpeed: transitionSpeed,
			onShow: onShow,
			onHide: onHide,
			child: Positioned.node({
				getTarget: getTarget ?? () -> investigate()
					.findAncestorOfType(PrimitiveView)
					.map(view -> view.firstPrimitive())
					.orThrow(),
				gap: gap,
				attachment: attachment,
				child: child
			})
		}));
	}
}
