package blok.foundation.carousel;

import blok.signal.Computation;
import blok.Context;
import blok.Owner;
import blok.debug.Debug;
import blok.signal.Signal;

typedef CarouselContextOptions = {
	public final onlyShowActiveSlides:Bool;
}

@:fallback(error('No CarouselContext found'))
class CarouselContext implements Context {
	public final options:CarouselContextOptions;
	public final count:Int;
	public final hasNext:Computation<Bool>;
	public final hasPrevious:Computation<Bool>;
	public final index:Signal<Int>;

	final owner:Owner = new Owner();
	var previousIndex:Int;

	public function new(count, index, ?options:CarouselContextOptions) {
		this.count = count;
		this.index = new Signal(index);
		this.previousIndex = index;
		this.options = options == null ? {onlyShowActiveSlides: false} : options;

		var prev = Owner.setCurrent(owner);
		this.hasNext = new Computation(() -> this.index() < (count - 1));
		this.hasPrevious = new Computation(() -> this.index() > 0);
		Owner.setCurrent(prev);
	}

	public function getPosition():{current:Int, previous:Int} {
		return {
			current: index(),
			previous: previousIndex
		};
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

	public function dispose() {
		owner.dispose();
	}
}
