package blok.foundation.carousel;

import blok.foundation.animation.*;
import blok.html.Html;
import blok.signal.Graph;
import blok.ui.*;

using Lambda;

class CarouselViewport extends Component {
  @:attribute final className:String = null;
  @:attribute final duration:Int = 200;
  @:attribute final dragClamp:Int = 50;
  @:children @:attribute final children:Children;

  // @todo: These controls have some issues. First, we need to make 
  // sure that only left-clicks (or single finger touches) have an effect.
  // ...and that's all I can think of right now? I'm sure there's more.
  //
  // We should make the drag behavior optional, I suppose.

  #if (js && !nodejs)
  var startDrag:Float = -1;
  var previousDrag:Float = 0;
  var dragOffset:Float = 0;

  function getTarget() {
    return findChildOfType(Animated, true)
      .flatMap(component -> component.getRealNode().as(js.html.Element).toMaybe())
      .orThrow('Could not find Animated child -- `getTarget` may have been called before the component rendered');
  }

  function getInteractionPosition(e:js.html.Event) {
    return switch Std.downcast(e, js.html.TouchEvent) {
      case null: e.as(js.html.MouseEvent).clientX;
      case touch: touch.changedTouches.item(0).clientX;
    }
  }

  function onDragStart(e:js.html.Event) {
    // @todo: check if the event is a left mouse click or a one-finger
    // touch, and only activate then.
    //
    // @todo: Potentially check the event target and don't drag if it's 
    // text.

    e.preventDefault();
    startDrag = getInteractionPosition(e);
    previousDrag = startDrag;
    js.Browser.window.addEventListener('mousemove', onDragUpdate);
    js.Browser.window.addEventListener('mouseup', onDragEnd);
    js.Browser.window.addEventListener('touchmove', onDragUpdate);
    js.Browser.window.addEventListener('touchend', onDragEnd);
  }

  function onDragUpdate(e:js.html.Event) {
    // @todo: If we're dealing with touch events make sure we're not
    // reacting to another finger on the screen.

    var context = CarouselContext.from(this);
    var currentDrag = getInteractionPosition(e);
    var offset = previousDrag - currentDrag;

    if (startDrag > currentDrag && context.hasNext()) {
      dragOffset += offset;
      updateViewportTransform();
    }
  
    if (startDrag < currentDrag && context.hasPrevious()) {
      dragOffset += offset;
      updateViewportTransform();
    }

    previousDrag = currentDrag;
  }

  function onDragEnd(e:js.html.Event) {
    e.preventDefault();

    js.Browser.window.removeEventListener('mousemove', onDragUpdate);
    js.Browser.window.removeEventListener('mouseup', onDragEnd);
    js.Browser.window.removeEventListener('touchmove', onDragUpdate);
    js.Browser.window.removeEventListener('touchend', onDragEnd);
    
    var endDrag = getInteractionPosition(e);
    var context = CarouselContext.from(this);
    var amount = startDrag - endDrag;
    
    if (Math.abs(amount) < dragClamp) {
      dragOffset = 0;
      updateViewportTransform();
      return;
    }

    if (startDrag > endDrag && context.hasNext()) {
      context.next();
      return;
    }
  
    if (startDrag < endDrag && context.hasPrevious()) {
      context.previous();
      return;
    }

    resetViewportTransform();
  }

  function getCurrentPosition() {
    var carousel = CarouselContext.from(this);
    return untrackValue(() -> carousel.getPosition().current);
  }

  function getOffset(position:Int) {
    var slides = filterChildrenOfType(CarouselItem, true);
    return slides.find(slide -> slide.position == position)
      ?.getRealNode()
      ?.as(js.html.Element)
      ?.offsetLeft
      ?? 0.0;
  }

  function updateViewportTransform() {
    var offset = getOffset(getCurrentPosition()) + dragOffset;
    getTarget().style.transform = 'translate3d(-${offset}px, 0px, 0px)';
  }

  function resetViewportTransform() {
    dragOffset = 0;
    updateViewportTransform();
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
      #if (js && !nodejs)
      onMouseDown: onDragStart,
      onTouchStart: onDragStart,
      #end
      className: className,
      style: 'overflow:hidden'
    }, Animated.node({
      keyframes: new Keyframes('blok.foundation.carousel', context -> {
        var pos = carousel.getPosition();
        #if (js && !nodejs)
        var currentOffset = getOffset(pos.previous) + dragOffset;
        #else
        var currentOffset = getOffset(pos.previous);
        #end
        var nextOffset = getOffset(pos.current);
  
        return [
          { transform: 'translate3d(-${currentOffset}px, 0px, 0px)' },
          { transform: 'translate3d(-${nextOffset}px, 0px, 0px)' },
        ];
      }),
      #if (js && !nodejs)
      onFinished: _ -> resetViewportTransform(),
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
