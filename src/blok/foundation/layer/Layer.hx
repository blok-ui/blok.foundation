package blok.foundation.layer;

import blok.html.View;
import blok.foundation.animation.*;
import blok.html.Html;
import blok.ui.*;

final DefaultShowAnimation = new Keyframes('show', context -> [ { opacity: 0 }, { opacity: 1 } ]);
final DefaultHideAnimation = new Keyframes('hide', context -> [ { opacity: 1 }, { opacity: 0 } ]);

class Layer extends Component {
  @:attribute final onShow:()->Void = null;
  @:attribute final onHide:()->Void;
  @:attribute final hideOnClick:Bool = true;
  @:attribute final hideOnEscape:Bool = true;
  @:attribute final child:Child;
  @:attribute final className:String = null;
  @:attribute final transitionSpeed:Int = 150;
  @:attribute final showAnimation:Keyframes = DefaultShowAnimation;
  @:attribute final hideAnimation:Keyframes = DefaultHideAnimation;
  
  function render() {
    return LayerContext.provide(() -> new LayerContext(), layer -> {
      var body = Html.div({
        className: className,
        style: 'position:fixed;inset:0px;overflow-x:hidden;overflow-y:scroll;',
        onClick: e -> if (hideOnClick) {
          e.preventDefault();
          layer.hide();
        }
      }, LayerTarget.node({ child: child }));
      var animation = Animated.node({
        keyframes: layer.status.map(status -> switch status { 
          case Showing: 
            showAnimation;
          case Hiding: 
            hideAnimation;
        }),
        duration: transitionSpeed,
        onFinished: _ -> switch layer.status.peek() {
          case Showing:
            if (onShow != null) onShow();
          case Hiding:
            if (onHide != null) onHide();
        },
        onDispose: _ -> if (onHide != null) onHide(),
        child: body
      });
      return LayerContainer.node({
        hideOnEscape: hideOnEscape,
        child: animation
      });
    });
  }
}
