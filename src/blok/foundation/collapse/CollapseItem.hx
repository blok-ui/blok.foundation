package blok.foundation.collapse;

import blok.foundation.animation.*;
import blok.*;

class CollapseItem extends Component {
	@:context final collapse:CollapseContext;
	@:children @:attribute final child:Child;
	@:computed final keyframes:Keyframes = switch collapse.status() {
			case Collapsed: new Keyframes('in', context -> [{height: getHeight(context), offset: 0}, {height: 0, offset: 1}]);
			case Expanded: new Keyframes('out', context -> [{height: 0, offset: 0}, {height: getHeight(context), offset: 1}]);
		}

	function render() {
		return Animated.node({
			animateInitial: false,
			keyframes: keyframes,
			onFinished: context -> {
				#if (js && !nodejs)
				var el:js.html.Element = getPrimitive();
				switch collapse.status.peek() {
					case Collapsed: el.style.height = '0';
					case Expanded: el.style.height = 'auto';
				}
				#end
			},
			duration: collapse.duration,
			child: child
		});
	}
}

private function getHeight(context:View) {
	#if (js && !nodejs)
	var el:js.html.Element = context.getPrimitive();
	return el.scrollHeight + 'px';
	#else
	return 'auto';
	#end
}
