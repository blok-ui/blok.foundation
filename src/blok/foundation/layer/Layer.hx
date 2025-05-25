package blok.foundation.layer;

import blok.*;
import blok.Provider;
import blok.foundation.animation.*;
import blok.foundation.keyboard.*;

final DefaultShowAnimation = new Keyframes('show', context -> [{opacity: 0}, {opacity: 1}]);
final DefaultHideAnimation = new Keyframes('hide', context -> [{opacity: 1}, {opacity: 0}]);

class Layer extends Component {
	@:attribute final onShow:() -> Void = null;
	@:attribute final onHide:() -> Void = null;
	@:attribute final hideOnEscape:Bool = true;
	@:attribute final showAnimation:Keyframes = DefaultShowAnimation;
	@:attribute final hideAnimation:Keyframes = DefaultHideAnimation;
	@:attribute final transitionSpeed:Int = 150;
	@:children @:attribute final child:Child;

	function showRealNode() {
		#if (js && !nodejs)
		var el:js.html.Element = investigate().getPrimitive();
		el.style.visibility = 'visible';
		#end
	}

	function hideRealNode() {
		#if (js && !nodejs)
		var el:js.html.Element = investigate().getPrimitive();
		el.style.visibility = 'hidden';
		#end
	}

	function render():Child {
		var layer = new LayerContext();
		var body = if (hideOnEscape) KeyboardInput.node({
			handler: (key, getModifierState) -> switch key {
				case Escape:
					layer.hide();
				default:
			},
			preventDefault: false,
			child: child
		}) else child;

		return Provider
			.provide(layer)
			.child(Animated.node({
				keyframes: layer.status.map(status -> switch status {
					case Showing:
						showAnimation;
					case Hiding:
						hideAnimation;
				}),
				duration: transitionSpeed,
				onStart: _ -> switch layer.status.peek() {
					case Showing:
						showRealNode();
					case Hiding:
				},
				onFinished: _ -> switch layer.status.peek() {
					case Showing:
						if (onShow != null) onShow();
					case Hiding:
						hideRealNode();
						if (onHide != null) onHide();
				},
				onDispose: _ -> {
					if (onHide != null) onHide();
				},
				child: body
			}));
	}
}
