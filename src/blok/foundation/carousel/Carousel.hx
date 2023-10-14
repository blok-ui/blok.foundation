package blok.foundation.carousel;

import blok.ui.*;

class Carousel<T> extends Component {
  /**
    The class for the wrapping viewport.
  **/
  @:attribute final className:String = null;

  /**
    The items the carousel will slide between. These will be rendered
    by the `slide` attribute.
  **/
  @:attribute final items:Array<T>;

  /**
    The index of the first slide.
  **/
  @:attribute final initialIndex:Int = 0;

  /**
    The amount of time it should take to transition to the next/previous
    slide. To turn off animation, set this to `0`. This will also conform
    to `prefers-reduced-motion`.
  **/
  @:attribute final duration:Int = 200;
  
  /**
    If `true`, slides will be removed as they pass out of the viewport and
    will not be rendered until they enter. This is useful for carousels with
    large numbers of slides.
  **/
  @:attribute final onlyRenderActiveSlide:Bool = false;

  /**
    The function that will render each carousel item.
  **/
  @:children @:attribute final slide:(item:T, carousel:CarouselContext<T>)->Child;

  /**
    Controls that will be placed after the Carousel viewport in the DOM,
    if present.
  **/
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
              position: position,
              child: onlyRenderActiveSlide
                ? Scope.wrap(_ -> {
                  var pos = carousel.getPosition();
                  if (pos.current - 1 == position || pos.current == position || pos.current + 1 == position) {
                    slide(item, carousel);
                  } else {
                    null;
                  }
                })
                : Scope.wrap(_ -> slide(item, carousel))
            })
          ]
        }),
        controls != null ? controls(carousel) : null
      )
    );
  }
}
