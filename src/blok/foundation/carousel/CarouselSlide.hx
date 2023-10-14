package blok.foundation.carousel;

import blok.html.Html;
import blok.ui.*;

class CarouselSlide<T> extends Component {
  @:attribute public final position:Int;
  @:attribute final item:T;
  @:children @:attribute final renderSlide:(item:T, carousel:CarouselContext<T>)->Child;

  function render() {
    var carousel = CarouselContext.from(this);
    return Html.div({
      style: 'flex:0 0 100%'
    }, Scope.wrap(_ -> {
      var pos = carousel.getPosition();
      if (pos.current - 1 == position || pos.current == position || pos.current + 1 == position) {
        renderSlide(item, carousel);
      } else {
        null;
      }
    }));
  }
}
