package blok.foundation.carousel;

import blok.ui.*;
import blok.html.*;

class CarouselSlide extends Component {
  @:attribute public final position:Int;
  @:children @:attribute final child:Child;

  function render() {
    return Html.div({ style: 'flex:0 0 100%' }, child);
  }
}
