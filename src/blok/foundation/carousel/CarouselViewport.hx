package blok.foundation.carousel;

import blok.foundation.animation.*;
import blok.html.Html;
import blok.signal.*;
import blok.*;

using blok.foundation.core.DomTools;
using Lambda;

class CarouselViewport extends Component {
	@:attribute final className:String = null;
	@:attribute final dragClamp:Int = 50;
	@:attribute final duration:Int = 200;
	@:children @:attribute final children:Children;

	#if (js && !nodejs)
	final controller = new js.html.AbortController();
	var localController:Maybe<js.html.AbortController> = None;

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

		var el:js.html.Element = investigate().getPrimitive();
		var local = switch localController {
			case Some(value):
				value.abort();
				new js.html.AbortController();
			case None:
				new js.html.AbortController();
		}

		localController = Some(local);

		e.preventDefault();
		startDrag = getInteractionPosition(e);
		previousDrag = startDrag;

		el.addControlledEventListener('mousemove', onDragUpdate, local);
		el.addControlledEventListener('mouseup', onDragEnd, local);
		el.addControlledEventListener('touchmove', onDragUpdate, local);
		el.addControlledEventListener('touchend', onDragEnd, local);
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

		switch localController {
			case Some(local):
				local.abort();
				localController = None;
			case None:
		}

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

		addDisposable(() -> {
			controller.abort();
			localController.inspect(controller -> controller.abort());
		});
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
			// @todo: Develop the APIs needed to let us change this based on viewport size.
			duration: duration,
			child: Html.div({
				style: 'display:flex;height:100%;width:100%;transform:translate3d(-${currentOffset}px, 0px, 0px)'
			}, ...children.toArray())
		}));
	}
}
