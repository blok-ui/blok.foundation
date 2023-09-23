package blok.foundation.carousel;

import Blok.Scope;
import blok.foundation.animation.*;
import blok.html.Html;
import blok.ui.*;

using Lambda;

// @todo: I think this is causing some weird issues with Suspense,
// as we can perhaps cause race conditions when we `commit` the
// CarouselContext (maybe??).
class CarouselViewport extends Component {
  @:observable final children:Array<Child>;
  @:observable final direction:CarouselTransitionDirection = CarouselTransitionDirection.Pending;
  @:constant final onTransitionComplete:()->Void;
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
  #else
  function getOffset(_:Int) {
    return 0.0;
  }
  #end

  function render() {
    var dir = direction();

    return Html.div({
      className: className,
      style: 'overflow:hidden'
    }, Animated.node({
      keyframes: new Keyframes('blok.foundation.carousel', context -> {
        var currentOffset = getOffset(0);
        var nextOffset = switch dir {
          case Pending: getOffset(0);
          case Next: getOffset(1);
          case Previous: getOffset(-1);
        };
        return [
          { transform: 'translate3d(-${currentOffset}px, 0px, 0px)' },
          { transform: 'translate3d(-${nextOffset}px, 0px, 0px)' },
        ];
      }),
      onFinished: context -> {
        var currentOffset = getOffset(0);
        context.getRealNode().as(js.html.Element).style.transform = 'translate3d(-${currentOffset}px, 0px, 0px)';
        onTransitionComplete();
      },
      animateInitial: false,
      repeatCurrentAnimation: true,
      duration: duration,
      child: Scope.wrap(_ -> Html.div({
        style: 'display:flex;height:100%;width:100%;transform:translate3d(-${getOffset(0)}px, 0px, 0px)'
      }, ...children()))
    }));
  }
}
