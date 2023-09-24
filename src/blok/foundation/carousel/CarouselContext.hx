package blok.foundation.carousel;

import Blok.Signal;
import blok.debug.Debug;
import blok.context.Context;

@:fallback(error('No CarouselContext found'))
class CarouselContext<T> implements Context {
  final items:Array<T>;
  final index:Signal<Int>;
  
  var previousIndex:Int;
  
  public function new(items, index) {
    this.items = items;
    this.index = new Signal(index);
    this.previousIndex = index;
  }

  public function getPosition():{ current:Int, previous:Int } {
    return {
      current: index(),
      previous: previousIndex
    }
  } 

  public function next() {
    index.update(index -> {
      var next = index + 1;
      if (next > items.length - 1) return index;
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
    index.dispose();
  }
}