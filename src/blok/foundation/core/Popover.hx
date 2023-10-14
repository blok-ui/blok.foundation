package blok.foundation.core;

import blok.ui.*;

using blok.adaptor.RealNodeHostTools;

// @todo: Is `core` the best place for this?
class Popover extends Component {
  @:attribute final attachment:PositionedAttachment;
  @:attribute final gap:Int = 0;
  @:attribute final getTarget:Null<()->Dynamic> = null;
  @:children @:attribute final child:Child;

  function render() {
    var target = PortalContext.from(this).target;
    return Portal.wrap(target, () -> Positioned.node({
      getTarget: getTarget ?? () -> this.findNearestRealNode(),
      gap: gap,
      attachment: attachment,
      child: child
    }));
  }
}
