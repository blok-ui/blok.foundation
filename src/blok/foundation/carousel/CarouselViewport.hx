package blok.foundation.carousel;

import blok.foundation.animation.*;
import blok.html.Html;
import blok.signal.*;
import blok.*;

using Lambda;

class CarouselViewport extends Component {
	@:attribute final className:String = null;
	@:attribute final duration:Int = 200;
	@:attribute final dragClamp:Int = 50;
	@:children @:attribute final children:Children;

	#if (js && !nodejs)
	final controller = new js.html.AbortController();

	var startDrag:Float = -1;
	var previousDrag:Float = 0;
	var dragOffset:Float = 0;

	function getTarget() {
		return investigate()
			.findComponent(Animated, true)
			.flatMap(component -> component.investigate().getPrimitive().as(js.html.Element).toMaybe())
			.orThrow('Could not find Animated child -- `getTarget` may have been called before the component rendered');
	}

	function isValidInteraction(e:js.html.Event) {
		// @todo: Somehow we need to check if the direct interaction we're doing is selecting text.
		// This is made complicated by the fact that just checking if the target element contains a
		// text node will always be true, so we need a more complex test.
		return switch Std.downcast(e, js.html.TouchEvent) {
			case null:
				var mouse = e.as(js.html.MouseEvent);
				var check = mouse?.buttons == 1 && mouse?.button == 0;
				check;
			case touch:
				// @todo: not sure if the following is enough
				touch.touches.length == 1;
		}
	}

	function getInteractionPosition(e:js.html.Event) {
		return switch Std.downcast(e, js.html.TouchEvent) {
			case null:
				e.as(js.html.MouseEvent).clientX;
			case touch:
				touch.changedTouches.item(0).clientX;
		}
	}

	function onDragStart(e:js.html.Event) {
		if (!isValidInteraction(e)) return;

		e.preventDefault();
		startDrag = getInteractionPosition(e);
		previousDrag = startDrag;

		// @todo: The Haxe API seems incomplete and does not have a `signal` option
		// here, hence the `cast`.
		js.Browser.window.addEventListener('mousemove', onDragUpdate, cast {signal: controller.signal});
		js.Browser.window.addEventListener('mouseup', onDragEnd, cast {signal: controller.signal});
		js.Browser.window.addEventListener('touchmove', onDragUpdate, cast {signal: controller.signal});
		js.Browser.window.addEventListener('touchend', onDragEnd, cast {signal: controller.signal});
	}

	function onDragUpdate(e:js.html.Event) {
		if (!investigate().isMounted()) return;
		if (!isValidInteraction(e)) return;

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
		if (!investigate().isMounted()) return;
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
		return Runtime.current().untrack(() -> carousel.getPosition().current);
	}

	function getOffset(position:Int) {
		var slides = investigate().filterComponents(CarouselItem, true);
		return slides.find(slide -> slide.position == position)?.investigate()?.getPrimitive()?.as(js.html.Element)?.offsetLeft ?? 0.0;
	}

	function updateViewportTransform() {
		var offset = getOffset(getCurrentPosition()) + dragOffset;
		getTarget().style.transform = 'translate3d(-${offset}px, 0px, 0px)';
	}

	function resetViewportTransform() {
		if (!investigate().isMounted()) return;
		dragOffset = 0;
		updateViewportTransform();
	}

	function setup() {
		var window = js.Browser.window;

		window.addEventListener('resize', resetViewportTransform, cast {signal: controller.signal});

		addDisposable(() -> controller.abort());
	}
	#else
	function getOffset(_:Int) {
		return 0.0;
	}
	#end

	function render() {
		var carousel = CarouselContext.from(this);
		var currentOffset = Runtime.current().untrack(() -> getOffset(carousel.getPosition().current));

		return Html.div({
			#if (js && !nodejs)
			onMouseDown: onDragStart, onTouchStart: onDragStart,
			#end
			className: className,
			style: 'overflow:hidden'
		}, Animated.node({
			keyframes: new Keyframes('blok.foundation.carousel', _ -> {
				var pos = carousel.getPosition();
				#if (js && !nodejs)
				var currentOffset = getOffset(pos.previous) + dragOffset;
				#else
				var currentOffset = getOffset(pos.previous);
				#end
				var nextOffset = getOffset(pos.current);

				return [
					{transform: 'translate3d(-${currentOffset}px, 0px, 0px)'},
					{transform: 'translate3d(-${nextOffset}px, 0px, 0px)'},
				];
			}),
			#if (js && !nodejs)
			onFinished: _ -> resetViewportTransform(),
			#end
			animateInitial: false,
			repeatCurrentAnimation: true,
			// @todo: Duration should be based off the width of the screen.
			duration: duration,
			child: Html.div({
				style: 'display:flex;height:100%;width:100%;transform:translate3d(-${currentOffset}px, 0px, 0px)'
			}, ...children.toArray())
		}));
	}
}
