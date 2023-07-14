package blok.foundation.layer;

import blok.context.Context;
import blok.data.Record;

enum LayerContextStatus {
  Showing;
  Hiding;
}

@:fallback(new LayerContext({}))
class LayerContext extends Record implements Context {
  @:signal public final status:LayerContextStatus = Showing;

  public function hide():Void {
    status.set(Hiding);
  }
  
  public function show():Void {
    status.set(Showing);
  }
}
