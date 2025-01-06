package blok.foundation.layer;

import blok.foundation.core.FocusContext;
import blok.*;

using blok.foundation.keyboard.KeyboardModifiers;

class LayerContainer extends Component {
	@:attribute final hideOnEscape:Bool;
	@:children @:attribute final child:Child;

	function render() {
		if (hideOnEscape) return child.withKeyboardInputHandler((key, getModifierState) -> switch key {
			case Escape:
				LayerContext.from(this).hide();
			default:
		}, {preventDefault: false});

		return child;
	}

	#if (js && !nodejs)
	function setup() {
		var node = findChildOfType(LayerTarget, true).orThrow('Expected a LayerTarget').getPrimitive();
		FocusContext.from(this).focus(node);
		addDisposable(() -> FocusContext.from(this).returnFocus());
	}
	#end
}
