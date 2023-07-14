package blok.foundation.collapse;

import blok.foundation.accordion.AccordionContext;
import blok.data.Record;
import blok.context.Context;

enum abstract CollapseContextStatus(Bool) {
  final Collapsed = false;
  final Expanded = true;
}

@:fallback(new CollapseContext({ status: Expanded }))
class CollapseContext extends Record implements Context {
  @:constant final accordion:Maybe<AccordionContext> = None;
  @:constant public final duration:Int = 200;
  @:signal public final status:CollapseContextStatus;
  @:computed final init:Nothing = {
    accordion.ifExtract(Some(accordion), accordion.add(this));
    Nothing;
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
