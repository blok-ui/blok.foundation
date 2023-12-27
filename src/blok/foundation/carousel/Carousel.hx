package blok.foundation.carousel;

import blok.ui.*;

class Carousel extends Component {
  @:attribute final className:String = null;
  @:attribute final duration:Int = 200;
  @:attribute final initialIndex:Int = 0;
  @:attribute final onlyShowActiveSlides:Bool = false;
  @:attribute final controls:(carousel:CarouselContext)->Child = null;
  @:children @:attribute final slides:Array<Slide>;

  function render():Child {
    var items = [ for (index => child in slides) child.createCarouselItem(index) ];
    return CarouselContext.provide(
      () -> new CarouselContext(items.length, initialIndex, {
        onlyShowActiveSlides: onlyShowActiveSlides
      }),
      carousel -> Fragment.node(
        CarouselViewport.node({
          className: className,
          duration: duration,
          children: items
        }),
        controls != null ? controls(carousel) : null
      ) 
    );
  }
}
