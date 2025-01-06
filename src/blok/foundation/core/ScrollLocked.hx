package blok.foundation.core;

import blok.*;

class ScrollLocked extends Component {
	@:children @:attribute final child:Child;

	function render() {
		return child;
	}

	#if (js && !nodejs)
	function setup() {
		var body = js.Browser.document.body;
		var beforeWidth = body.offsetWidth;

		body.style.overflow = 'hidden';

		var afterWidth = body.offsetWidth;
		var offset = afterWidth - beforeWidth;

		if (offset > 0) {
			body.style.overflow = 'hidden';
			body.style.paddingRight = '${offset}px';
		}

		addDisposable(() -> {
			body.style.overflow = null;
			body.style.paddingRight = null;
		});
	}
	#end
}
