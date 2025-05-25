package blok.foundation.core;

class Focused extends Component {
	public static inline function wrap(child:Child) {
		return node({child: child});
	}

	@:children @:attribute final child:Child;

	#if (js && !nodejs)
	// @todo: Is this the right place for this?
	function setup() {
		investigate()
			.findChild(view -> view.currentNode() == child, true)
			.inspect(view -> {
				view.visitPrimitives(primitive -> {
					FocusContext.from(this).focus(view.firstPrimitive());
					addDisposable(() -> FocusContext.from(this).returnFocus());
					false;
				});
			});
	}
	#end

	public function render():Child {
		return child;
	}
}
