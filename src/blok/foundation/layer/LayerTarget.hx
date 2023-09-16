package blok.foundation.layer;

import blok.ui.*;

class LayerTarget extends Component {
  @:constant final child:Child;

  function render() {
    return child;
  }
}
