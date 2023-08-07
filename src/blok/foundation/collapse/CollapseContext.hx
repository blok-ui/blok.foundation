package blok.foundation.collapse;

import blok.signal.Signal;
import blok.foundation.accordion.AccordionContext;
import blok.data.Model;
import blok.context.Context;

enum abstract CollapseContextStatus(Bool) {
  final Collapsed = false;
  final Expanded = true;
}

@:fallback(new CollapseContext(Expanded))
class CollapseContext implements Context {
  public final duration:Int;
  public final status:Signal<CollapseContextStatus>;
  
  final accordion:Maybe<AccordionContext> = None;

  public function new(status:CollapseContextStatus, ?duration:Int, ?accordion) {
    this.status = new Signal(status);
    this.duration = duration ?? 200;
    this.accordion = accordion ?? None; 
    this.accordion.ifExtract(Some(accordion), accordion.add(this));
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

  public function dispose() {
    accordion.ifExtract(Some(accordion), accordion.remove(this));
  }
}
