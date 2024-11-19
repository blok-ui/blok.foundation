package blok.foundation.carousel;

import blok.context.Context;
import blok.debug.Debug;
import blok.signal.Signal;

typedef CarouselContextOptions = {
	public final onlyShowActiveSlides:Bool;
}

@:fallback(error('No CarouselContext found'))
class CarouselContext implements Context {
	public final options:CarouselContextOptions;
	public final count:Int;

	final index:Signal<Int>;

	var previousIndex:Int;

	public function new(count, index, ?options:CarouselContextOptions) {
		this.count = count;
		this.index = new Signal(index);
		this.previousIndex = index;
		this.options = options == null ? {onlyShowActiveSlides: false} : options;
	}

	public function getPosition():{current:Int, previous:Int} {
		return {
			current: index(),
			previous: previousIndex
		};
	}

	public function hasNext() {
		return index.peek() < (count - 1);
	}

	public function hasPrevious() {
		return index.peek() > 0;
	}

	public function next() {
		index.update(index -> {
			var next = index + 1;
			if (next > count - 1) return index;
			previousIndex = index;
			return next;
		});
	}

	public function previous() {
		index.update(index -> {
			var prev = index - 1;
			if (prev < 0) return index;
			previousIndex = index;
			return prev;
		});
	}

	public function dispose() {}
}
