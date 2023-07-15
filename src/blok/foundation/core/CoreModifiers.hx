package blok.foundation.core;

import blok.ui.Child;

inline function lockScroll(child:Child) {
  return ScrollLocked.node({ child: child });
}

function inPopover(child:Child, attachment:PositionedAttachment, ?options:{
  ?getTarget:()->Dynamic,
  ?gap:Int
}) {
  return Popover.node({
    child: child,
    attachment: attachment,
    gap: options?.gap,
    getTarget: options?.getTarget
  });
}
