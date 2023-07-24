package blok.foundation.collapse;

import blok.foundation.accordion.AccordionContext;
import blok.data.Model;
import blok.context.Context;

enum abstract CollapseContextStatus(Bool) {
  final Collapsed = false;
  final Expanded = true;
}

@:fallback(new CollapseContext({ status: Expanded }))
class CollapseContext extends Model implements Context {
  @:constant 
  @:json(
    from = if (value == null) None else Some(new AccordionContext(value)),
    to = switch value {
      case None: null;
      case Some(value): { sticky: @:privateAccess value.sticky };
    }
  )
  final accordion:Maybe<AccordionContext> = None;
  @:constant public final duration:Int = 200;
  @:signal public final status:CollapseContextStatus;

  public function new() {
    accordion.ifExtract(Some(accordion), accordion.add(this));
  }

  public function toggle() {
    switch status.peek() {
      case Expanded: collapse();
      case Collapsed: expand();
    }
  }

  public function expand() {
    status.set(Expanded);
  }

  public function collapse() {
    status.set(Collapsed);
  }

  override function dispose() {
    accordion.ifExtract(Some(accordion), accordion.remove(this));
  }
}
