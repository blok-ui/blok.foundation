package blok.foundation.core;

import blok.html.Html;
import blok.ui.*;

enum abstract TouchSlideDirection(Int) {
  final X;
  final Y;
}

class TouchSlideTrap extends Component {
  @:attribute final className:String = null;
  @:attribute final direction:TouchSlideDirection = X;
  @:attribute final clamp:Int = 50;
  @:attribute final onSlide:(amount:Int)->Void;
  @:children @:attribute final children:Children;

  function render() {
    var start = -1;
    return Html.div({
      className: className,
      onTouchStart: e -> {
        start = e.as(js.html.TouchEvent)?.changedTouches.item(0).clientX;
      },
      onTouchEnd: e -> {
        if (start == -1) return;

        var item = e.as(js.html.TouchEvent)?.changedTouches?.item(0);
        var end = (switch direction {
          case X: item?.clientX;
          case Y: item?.clientY;
        }) ?? 0;
        var amount = start - end;
        
        start = -1;
        
        // clamp:
        if (Math.abs(amount) < clamp) return;
        
        onSlide(amount);
      }
    }, ...children.toArray());
  }
}