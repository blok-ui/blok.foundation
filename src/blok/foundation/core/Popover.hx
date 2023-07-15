package blok.foundation.core;

import blok.ui.*;

using blok.adaptor.RealNodeHostTools;

// @todo: Is `core` the best place for this?
class Popover extends Component {
  @:constant final child:Child;
  @:constant final attachment:PositionedAttachment;
  @:constant final gap:Int = 0;
  @:constant final getTarget:Null<()->Dynamic> = null;

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
