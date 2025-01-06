package blok.foundation.layer;

import blok.*;

class LayerTarget extends Component {
	@:children @:attribute final child:Child;

	function render() {
		return child;
	}
}
