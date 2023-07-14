package blok.foundation.layer;

import blok.ui.*;
import blok.foundation.layer.Layer;
import blok.foundation.core.FocusContext;

class LayerContainer extends Component {
  @:constant final hideOnEscape:Bool;
  @:constant final child:Child;

  function render() {
    return child;
  }

  #if (js && !nodejs)
  function setup() {
    var document = js.Browser.document;

    function onEscape(e:js.html.KeyboardEvent) switch e.key {
      case 'Escape' if (hideOnEscape):
        e.preventDefault();
        LayerContext.from(this).hide();
      default:
    }

    document.addEventListener('keydown', onEscape);
    var node = findChildOfType(LayerTarget, true).orThrow('Expected a LayerTarget').getRealNode();
    FocusContext.from(this).focus(node);

    addDisposable(() -> {
      document.removeEventListener('keydown', onEscape);
      FocusContext.from(this).returnFocus();
    });
  }
  #end
}
