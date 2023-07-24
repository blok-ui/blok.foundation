package blok.foundation.core;

import blok.context.Context;
import blok.data.Model;

@:fallback(new PortalContext({ 
  target: #if (js && !nodejs) 
    js.Browser.document.getElementById('portal') 
  #else
    new blok.html.server.Element({ id: 'portal' }) 
  #end 
}))
class PortalContext extends Model implements Context {
  @:constant public final target:Dynamic;
}
