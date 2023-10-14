package blok.foundation.carousel;

import blok.ui.*;

class Carousel<T> extends Component {
  @:attribute final className:String = null;
  @:attribute final items:Array<T>;
  @:attribute final initialIndex:Int = 0;
  @:attribute final duration:Int = 200;
  @:attribute final slide:(item:T, carousel:CarouselContext<T>)->Child;
  @:attribute final controls:(carousel:CarouselContext<T>)->Child = null;

  function render() {
    return CarouselContext.provide(
      () -> new CarouselContext(items, initialIndex),
      carousel -> Fragment.node(
        CarouselViewport.node({
          className: className,
          duration: duration,
          children: [ for (position => item in items)
            CarouselSlide.node({
              item: item,
              renderSlide: slide,
              position: position
            }, position) 
          ]
        }),
        controls != null ? controls(carousel) : null
      )
    );
  }
}
