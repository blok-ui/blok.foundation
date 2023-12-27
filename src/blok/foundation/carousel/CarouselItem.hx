package blok.foundation.carousel;

import blok.html.Html;
import blok.ui.*;

class CarouselItem extends Component {
  @:attribute public final position:Int;
  @:children @:attribute final child:(carousel:CarouselContext)->Child;

  function render():Child {
    var carousel = CarouselContext.from(this);
    var body = if (carousel.options.onlyShowActiveSlides) Scope.wrap(_ -> {
      var pos = carousel.getPosition();
      return if (pos.current - 1 == position || pos.current == position || pos.current + 1 == position) {
        child(carousel);
      } else {
        Placeholder.node();
      }
    }) else child(carousel);

    return Html.div({ style: 'flex:0 0 100%' }, body);
  }
}
