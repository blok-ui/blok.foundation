package blok;

import blok.foundation.core.*;
import blok.foundation.keyboard.*;
import blok.foundation.float.*;
import blok.foundation.animation.*;
import blok.ui.Child;

/**
	Lock document scrolling as long as this component is active.
**/
inline function lockScroll(child:Child) {
	return ScrollLocked.node({child: child});
}

private typedef KeyboardInputHandler = (key:KeyType, getModifierState:(modifier:KeyModifier) -> Bool) -> Void;

/**
	Attach a keyboard handler to this component.
**/
function withKeyboardInputHandler(child:Child, handler:KeyboardInputHandler, ?options:{preventDefault:Bool}) {
	return KeyboardInput.node({
		child: child,
		handler: handler,
		preventDefault: options?.preventDefault ?? true
	});
}

/**
	Place component inside a Popover.
**/
function inPopover(child:Child, attachment:PositionedAttachment, ?options:{
	?getTarget:() -> Dynamic,
	?gap:Int
}) {
	return Popover.node({
		child: child,
		attachment: attachment,
		gap: options?.gap,
		getTarget: options?.getTarget
	});
}

/**
	Animate this component.
**/
function withAnimation(child:Child, id:String, factory, ?options:{
	?easing:String,
	?duration:Int
}) {
	return Animated.node({
		keyframes: new Keyframes(id, factory),
		duration: options?.duration ?? 300,
		easing: options?.easing,
		child: child
	});
}

/**
	Animate this component until it is removed or re-rendered.
**/
function withInfiniteAnimation(child:Child, id:String, factory, ?options:{
	?easing:String,
	?duration:Int
}) {
	return Animated.node({
		keyframes: new Keyframes(id, factory),
		duration: options?.duration ?? 300,
		easing: options?.easing,
		child: child,
		infinite: true
	});
}
