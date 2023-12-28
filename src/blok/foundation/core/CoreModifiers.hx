package blok.foundation.core;

// import blok.foundation.core.TouchSlideTrap;
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

// /**
//   Wrap the `child` in a div that captures a touch-and-slide
//   event.
// **/
// function inTouchSlideTrap(child:Child, onSlide, ?options:{
//   ?className:String,
//   ?direction:TouchSlideDirection,
//   ?clamp:Int
// }) {
//   return TouchSlideTrap.node({
//     className: options?.className,
//     direction: options?.direction,
//     clamp: options?.clamp,
//     onSlide: onSlide,
//     children: child
//   });
// }
