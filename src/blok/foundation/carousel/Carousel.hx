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
          direction: carousel.direction,
          onTransitionComplete: () -> carousel.commit(),
          children: carousel.slice.map(items -> [ for (position => item in items)
            CarouselSlide.node({
              child: item == null ? Placeholder.node() : slide(item, carousel),
              position: position - 2
            }, carousel.getIndex(item).unwrap()) 
          ])
        }),
        controls != null ? controls(carousel) : null
      )
    );
  }
}