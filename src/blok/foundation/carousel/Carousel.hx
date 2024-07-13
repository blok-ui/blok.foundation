package blok.foundation.carousel;

import blok.context.Provider;
import blok.ui.*;

class Carousel extends Component {
  @:attribute final className:String = null;
  @:attribute final duration:Int = 200;
  @:attribute final dragClamp:Int = 50;
  @:attribute final initialIndex:Int = 0;
  @:attribute final onlyShowActiveSlides:Bool = false;
  @:attribute final controls:(carousel:CarouselContext)->Child = null;
  @:children @:attribute final slides:Array<Slide>;

  function render():Child {
    var items = [ for (index => child in slides) child.createCarouselItem(index) ];
    return Provider
      .provide(() -> new CarouselContext(items.length, initialIndex, {
        onlyShowActiveSlides: onlyShowActiveSlides
      }))
      .child(context -> {
        var carousel = CarouselContext.from(context);
        return Fragment.of([
          CarouselViewport.node({
            className: className,
            duration: duration,
            dragClamp: dragClamp,
            children: items
          }),
          controls != null ? controls(carousel) : null
        ]);
      });
  }
}
