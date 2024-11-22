package blok.foundation.layer;

import blok.signal.Computation;
import blok.context.Provider;
import blok.foundation.animation.*;
import blok.html.Html;
import blok.ui.*;

final DefaultShowAnimation = new Keyframes('show', context -> [{opacity: 0}, {opacity: 1}]);
final DefaultHideAnimation = new Keyframes('hide', context -> [{opacity: 1}, {opacity: 0}]);

class Layer extends Component {
	@:attribute final onShow:() -> Void = null;
	@:attribute final onHide:() -> Void;
	@:attribute final hideOnClick:Bool = true;
	@:attribute final hideOnEscape:Bool = true;
	@:attribute final child:Child;
	@:attribute final className:String = null;
	@:attribute final transitionSpeed:Int = 150;
	@:attribute final showAnimation:Keyframes = DefaultShowAnimation;
	@:attribute final hideAnimation:Keyframes = DefaultHideAnimation;

	function showRealNode() {
		#if (js && !nodejs)
		var el:js.html.Element = getPrimitive();
		el.style.visibility = 'visible';
		#end
	}

	function hideRealNode() {
		#if (js && !nodejs)
		var el:js.html.Element = getPrimitive();
		el.style.visibility = 'hidden';
		#end
	}

	function render():Child {
		var layer = new LayerContext();
		var body = Html.div({
			className: className,
			style: 'position:fixed;inset:0px;overflow-x:hidden;overflow-y:scroll;',
			onClick: e -> if (hideOnClick) {
				e.preventDefault();
				layer.hide();
			}
		}, LayerTarget.node({child: child}));
		var animation = Animated.node({
			keyframes: new Computation(() -> {
				switch layer.status() {
					case Showing:
						showAnimation;
					case Hiding:
						hideAnimation;
				}
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
		});

		return Provider
			.provide(layer)
			.child(LayerContainer.node({
				hideOnEscape: hideOnEscape,
				child: animation
			}));
	}
}
