package blok.foundation.layer;

import blok.context.Context;
import blok.signal.Signal;

enum LayerContextStatus {
	Showing;
	Hiding;
}

@:fallback(new LayerContext())
class LayerContext implements Context {
	public var status(get, never):ReadOnlySignal<LayerContextStatus>;

	inline function get_status() return statusSignal;

	final statusSignal:Signal<LayerContextStatus>;

	public function new(?status) {
		statusSignal = new Signal(status ?? Showing);
	}

	public function hide():Void {
		statusSignal.set(Hiding);
	}

	public function show():Void {
		statusSignal.set(Showing);
	}

	public function dispose() {}
}
