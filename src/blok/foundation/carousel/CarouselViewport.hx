package blok.foundation.carousel;

import blok.foundation.animation.*;
import blok.html.Html;
import blok.signal.Graph.untrackValue;
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
    findChildOfType(Animated, true).extract(Some(target));
    var currentOffset = untrackValue(() -> getOffset(CarouselContext.from(this).getPosition().current));
    target.getRealNode().as(js.html.Element).style.transform = 'translate3d(-${currentOffset}px, 0px, 0px)';
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
    var currentOffset = untrackValue(() -> getOffset(CarouselContext.from(this).getPosition().current));
    return Html.div({
      className: className,
      style: 'overflow:hidden'
    }, Animated.node({
      keyframes: new Keyframes('blok.foundation.carousel', context -> {
        var pos = CarouselContext.from(this).getPosition();
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
      // onFinished: context -> {
      //   var currentOffset = untrackValue(() -> getOffset(CarouselContext.from(this).getPosition().current));
      //   context.getRealNode().as(js.html.Element).style.transform = 'translate3d(-${currentOffset}px, 0px, 0px)';
      // },
      animateInitial: false,
      repeatCurrentAnimation: true,
      duration: duration,
      child: Html.div({
        style: 'display:flex;height:100%;width:100%;transform:translate3d(-${currentOffset}px, 0px, 0px)'
      }, ...children.toArray())
    }));
  }
}
