package blok.foundation.carousel;

import blok.ui.*;

typedef SlideFactory = (context:CarouselContext) -> Child;

abstract Slide(SlideFactory) from SlideFactory to SlideFactory {
	public static inline function wrap(factory) {
		return new Slide(factory);
	}

	public inline function new(factory) {
		this = factory;
	}

	public inline function createCarouselItem(position:Int) {
		return CarouselItem.node({
			position: position,
			child: this
		});
	}
}
