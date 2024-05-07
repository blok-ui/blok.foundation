package blok.foundation.core;

import blok.context.Context;

@:fallback(new PortalContext(
  #if (js && !nodejs) 
    js.Browser.document.getElementById('portal') 
  #else
    new blok.html.server.ElementPrimitive('div', { id: 'portal' }) 
  #end 
))
class PortalContext implements Context {
  public final target:Dynamic;

  public function new(target) {
    this.target = target;
  }

  public function dispose() {
    // noop
  }
}
