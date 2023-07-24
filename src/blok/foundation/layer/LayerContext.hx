package blok.foundation.layer;

import blok.context.Context;
import blok.data.Model;

enum LayerContextStatus {
  Showing;
  Hiding;
}

@:fallback(new LayerContext({}))
class LayerContext extends Model implements Context {
  @:signal 
  @:json(
    from = value == true ? LayerContextStatus.Showing : LayerContextStatus.Hiding,
    to = switch value {
      case Showing: true;
      case Hiding: false;
    }
  )
  public final status:LayerContextStatus = Showing;

  public function hide():Void {
    status.set(Hiding);
  }
  
  public function show():Void {
    status.set(Showing);
  }
}
