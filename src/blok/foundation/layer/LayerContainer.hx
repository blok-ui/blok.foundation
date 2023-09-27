package blok.foundation.layer;

import blok.foundation.core.FocusContext;
import blok.ui.*;

using blok.foundation.keyboard.KeyboardModifiers;

class LayerContainer extends Component {
  @:constant final hideOnEscape:Bool;
  @:constant final child:Child;

  function render() {
    return child.withKeyboardInputHandler((key, getModifierState) -> switch key {
      case Escape if (hideOnEscape):
        LayerContext.from(this).hide();
      default:
    }, false);
  }

  #if (js && !nodejs)
  function setup() {
    var node = findChildOfType(LayerTarget, true).orThrow('Expected a LayerTarget').getRealNode();
    FocusContext.from(this).focus(node);
    addDisposable(() -> FocusContext.from(this).returnFocus());
  }
  #end
}
