package blok.foundation.layer;

import blok.context.Context;
import blok.signal.Signal;

enum LayerContextStatus {
  Showing;
  Hiding;
}

@:fallback(new LayerContext())
class LayerContext implements Context {
  public final status:Signal<LayerContextStatus>;

  public function new(?status) {
    this.status = new Signal(status ?? Showing);
  }

  public function hide():Void {
    status.set(Hiding);
  }
  
  public function show():Void {
    status.set(Showing);
  }

  public function dispose() {
    // status.dispose();
  }
}
