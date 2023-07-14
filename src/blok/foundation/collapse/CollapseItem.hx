package blok.foundation.collapse;

import blok.foundation.animation.*;
import blok.ui.*;

class CollapseItem extends Component {
  @:constant final child:Child;

  function render() {
    var collapse = CollapseContext.from(this);
    return Animated.node({
      keyframes: collapse.status.map(status -> switch status {
        case Collapsed: new Keyframes('in', context -> [
          { height: getHeight(context), offset: 0 },
          { height: 0, offset: 1 }
        ]);
        case Expanded: new Keyframes('out', context -> [
          { height: 0, offset: 0 },
          { height: getHeight(context), offset: 1 }
        ]);
      }),
      onFinished: context -> {
        #if (js && !nodejs)
        var el:js.html.Element = getRealNode();
        switch collapse.status.peek() {
          case Collapsed: el.style.height = '0';
          case Expanded: el.style.height = 'auto';
        }
        #end
      },
      duration: collapse.duration,
      child: child
    });
  }
}

private function getHeight(context:ComponentBase) {
  #if (js && !nodejs)
  var el:js.html.Element = context.getRealNode();
  return el.scrollHeight + 'px';
  #else
  return 'auto';
  #end
}
