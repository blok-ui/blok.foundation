package blok.foundation.layer;

import blok.ui.*;
import blok.foundation.core.*;

using blok.adaptor.RealNodeHostTools;
using blok.foundation.core.CoreModifiers;

class Popover extends Component {
  @:constant final child:Child;
  @:constant final gap:Int = 0;
  @:constant final attachment:PositionedAttachment;
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
