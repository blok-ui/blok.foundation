package blok.foundation.keyboard;

import blok.ui.*;

class KeyboardInput extends Component {
	@:attribute final child:Child;
	@:attribute final preventDefault:Bool = true;
	@:attribute final handler:(key:KeyType, getModifierState:(modifier:KeyModifier) -> Bool) -> Void;

	#if (js && !nodejs)
	function setup() {
		function listener(e:js.html.KeyboardEvent) {
			if (preventDefault) e.preventDefault();
			handler(e.key, (key:KeyModifier) -> e.getModifierState(key));
		}

		var el:js.html.Element = getPrimitive();
		var document = el.ownerDocument;
		document.addEventListener('keydown', listener);
		addDisposable(() -> document.removeEventListener('keydown', listener));
	}
	#end

	function render() {
		return child;
	}
}
