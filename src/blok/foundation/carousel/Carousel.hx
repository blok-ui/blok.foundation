package blok.foundation.carousel;

import blok.ui.*;

class Carousel<T> extends Component {
  @:constant final className:String = null;
  @:constant final items:Array<T>;
  @:constant final initialIndex:Int = 0;
  @:constant final duration:Int = 200;
  @:constant final slide:(item:T, carousel:CarouselContext<T>)->Child;
  @:constant final controls:(carousel:CarouselContext<T>)->Child = null;

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
