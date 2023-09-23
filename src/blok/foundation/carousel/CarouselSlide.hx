package blok.foundation.carousel;

import blok.html.Html;
import blok.ui.*;

class CarouselSlide extends Component {
  @:constant public final position:Int;
  @:constant final child:Child;

  function render() {
    return Html.div({
      style: 'flex:0 0 100%'
    }, child);
  }
}
