package blok.foundation.carousel;

import blok.foundation.animation.*;
import blok.html.Html;
import blok.signal.Graph;
import blok.ui.*;

using Lambda;

class CarouselViewport extends Component {
  @:constant final children:Children;
  @:constant final className:String = null;
  @:constant final duration:Int = 200;

  #if (js && !nodejs)
  function getOffset(position:Int) {
    var slides = filterChildrenOfType(CarouselSlide, true);
    return slides.find(slide -> slide.position == position)
      ?.getRealNode()
      ?.as(js.html.Element)
      ?.offsetLeft
      ?? 0.0;
  }

  function updateViewportTransform() {
    var carousel = CarouselContext.from(this);
    var currentOffset = untrackValue(() -> getOffset(carousel.getPosition().current));
    var target = findChildOfType(Animated, true)
      .flatMap(component -> component.getRealNode().as(js.html.Element).toMaybe())
      .orThrow('Could not find Animated child -- `updateViewportTransform` may have been called before the component rendered');
    
    target.style.transform = 'translate3d(-${currentOffset}px, 0px, 0px)';
  }

  function setup() {
    var window = js.Browser.window;
    window.addEventListener('resize', updateViewportTransform);
    addDisposable(() -> {
      window.removeEventListener('resize', updateViewportTransform);
    });
  }
  #else
  function getOffset(_:Int) {
    return 0.0;
  }
  #end

  function render() {
    var carousel = CarouselContext.from(this);
    var currentOffset = untrackValue(() -> getOffset(carousel.getPosition().current));
    
    return Html.div({
      className: className,
      style: 'overflow:hidden'
    }, Animated.node({
      keyframes: new Keyframes('blok.foundation.carousel', context -> {
        var pos = carousel.getPosition();
        var currentOffset = getOffset(pos.previous);
        var nextOffset = getOffset(pos.current);
  
        return [
          { transform: 'translate3d(-${currentOffset}px, 0px, 0px)' },
          { transform: 'translate3d(-${nextOffset}px, 0px, 0px)' },
        ];
      }),
      #if (js && !nodejs)
      onFinished: _ -> updateViewportTransform(),
      #end
      animateInitial: false,
      repeatCurrentAnimation: true,
      duration: duration,
      child: Html.div({
        style: 'display:flex;height:100%;width:100%;transform:translate3d(-${currentOffset}px, 0px, 0px)'
      }, ...children.toArray())
    }));
  }
}
