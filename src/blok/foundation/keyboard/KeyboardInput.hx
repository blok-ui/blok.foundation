package blok.foundation.keyboard;

import blok.*;

class KeyboardInput extends Component {
	@:attribute final preventDefault:Bool = true;
	@:attribute final handler:(key:KeyType, getModifierState:(modifier:KeyModifier) -> Bool) -> Void;
	@:children @:attribute final child:Child;

	#if (js && !nodejs)
	function setup() {
		var controller = new js.html.AbortController();
		var el:js.html.Element = getPrimitive();
		var document = el.ownerDocument;

		document.addControlledEventListener('keydown', (e:js.html.KeyboardEvent) -> {
			if (preventDefault) e.preventDefault();
			handler(e.key, (key:KeyModifier) -> e.getModifierState(key));
		}, controller);

		addDisposable(() -> controller.abort());
	}
	#end

	function render() {
		return child;
	}
}
