package blok.foundation.carousel;

import blok.signal.Graph;
import blok.core.DisposableCollection;
import blok.signal.*;
import blok.debug.Debug.error;
import blok.context.Context;

@:fallback(error('No CarouselContext found'))
class CarouselContext<T> implements Context {
  public final index:Signal<Int>;
  public final direction:Signal<CarouselTransitionDirection> = new Signal<CarouselTransitionDirection>(Pending);
  public final slice:Computation<Array<Null<T>>>;
  
  final items:Array<T>;
  final disposables = new DisposableCollection();

  public function new(items, index = 0) {
    this.items = items;
    
    var previous = setCurrentOwner(Some(disposables));

    this.index = new Signal(index);
    this.slice = new Computation(() -> {
      var i = this.index();
      return [
        items[i - 2],
        items[i - 1],
        items[i],
        items[i + 1],
        items[i + 2]
      ];
    });

    setCurrentOwner(previous);
  }

  public function commit() {
    Action.run(() -> switch direction.peek() {
      case Pending:
      case Next:
        direction.set(Pending);
        index.update(index -> {
          var next = index + 1;
          if (next > items.length - 1) return index;
          return next;
        });
      case Previous:
        direction.set(Pending);
        index.update(index -> {
          var prev = index - 1;
          if (prev < 0) return index;
          return prev;
        });
    });
  }

  public function getIndex(item:T):Maybe<Int> {
    var i = items.indexOf(item);
    if (i == -1) return None;
    return Some(i);
  }

  public function next() {
    if (index.peek() == items.length - 1) return;
    if (direction.peek() != Pending) return;
    direction.set(Next);
  }

  public function previous() {
    if (index.peek() == 0) return;
    if (direction.peek() != Pending) return;
    direction.set(Previous);
  }

  public function dispose() {
    index.dispose();
    direction.dispose();
  }
}
