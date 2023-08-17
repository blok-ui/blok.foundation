package blok.foundation.keyboard;

import blok.ui.*;

class KeyboardInput extends Component {
  @:constant final child:Child;
  @:constant final preventDefault:Bool = true;
  @:constant final handler:(key:KeyType, getModifierState:(modifier:KeyModifier)->Bool)->Void;

  #if (js && !nodejs)
  function setup() {
    function listener(e:js.html.KeyboardEvent) {
      if (preventDefault) e.preventDefault();
      handler(e.key, (key:KeyModifier) -> e.getModifierState(key));
    }
    
    var el:js.html.Element = getRealNode();
    var document = el.ownerDocument;
    document.addEventListener('keydown', listener);
    addDisposable(() -> document.removeEventListener('keydown', listener));
  }
  #end
  
  function render() {
    return child;
  }
}
