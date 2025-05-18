package blok.foundation.layer;

import blok.*;
import blok.Provider;
import blok.foundation.animation.*;
import blok.html.Html;

final DefaultShowAnimation = new Keyframes('show', context -> [{opacity: 0}, {opacity: 1}]);
final DefaultHideAnimation = new Keyframes('hide', context -> [{opacity: 1}, {opacity: 0}]);

class Layer extends Component {
	@:attribute final onShow:() -> Void = null;
	@:attribute final onHide:() -> Void;
	@:attribute final hideOnClick:Bool = true;
	@:attribute final hideOnEscape:Bool = true;
	@:attribute final className:String = null;
	@:attribute final transitionSpeed:Int = 150;
	@:attribute final showAnimation:Keyframes = DefaultShowAnimation;
	@:attribute final hideAnimation:Keyframes = DefaultHideAnimation;
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

		return Provider
			.provide(layer)
			.child(LayerContainer.node({
				hideOnEscape: hideOnEscape,
				child: Animated.node({
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
					child: Html.div({
						className: className,
						style: 'position:fixed;inset:0px;overflow-x:hidden;overflow-y:scroll;',
						onClick: e -> if (hideOnClick) {
							e.preventDefault();
							layer.hide();
						}
					}).child(LayerTarget.node({child: child}))
				})
			}));
	}
}
