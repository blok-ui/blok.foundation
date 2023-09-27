package blok.foundation.layer;

import blok.foundation.animation.*;
import blok.html.Html;
import blok.ui.*;

final DefaultShowAnimation = new Keyframes('show', context -> [ { opacity: 0 }, { opacity: 1 } ]);
final DefaultHideAnimation = new Keyframes('hide', context -> [ { opacity: 1 }, { opacity: 0 } ]);

class Layer extends Component {
  @:constant final onShow:()->Void = null;
  @:constant final onHide:()->Void;
  @:constant final hideOnClick:Bool = true;
  @:constant final hideOnEscape:Bool = true;
  @:constant final child:Child;
  @:constant final className:String = null;
  @:constant final transitionSpeed:Int = 150;
  @:constant final showAnimation:Keyframes = DefaultShowAnimation;
  @:constant final hideAnimation:Keyframes = DefaultHideAnimation;
  
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
