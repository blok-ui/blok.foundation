package blok;

import blok.foundation.animation.*;
import blok.foundation.core.*;
import blok.foundation.float.*;
import blok.foundation.keyboard.*;

/**
	Lock document scrolling as long as this view is active.
**/
inline function lockScroll(child:Child) {
	return ScrollLocked.node({child: child});
}

/**
	Focus on the given node as long as this view is active.
**/
function takeFocus(child:Child) {
	return Focused.wrap(child);
}

private typedef KeyboardInputHandler = (key:KeyType, getModifierState:(modifier:KeyModifier) -> Bool) -> Void;

/**
	Attach a keyboard handler to this view.
**/
function withKeyboardInputHandler(child:Child, handler:KeyboardInputHandler, ?options:{preventDefault:Bool}) {
	return KeyboardInput.node({
		child: child,
		handler: handler,
		preventDefault: options?.preventDefault ?? true
	});
}

/**
	Place view inside a Popover.
**/
function inPopover(child:Child, attachment:PositionedAttachment, ?options:{
	?onShow:() -> Void,
	?onHide:() -> Void,
	?getTarget:() -> Dynamic,
	?gap:Int
}) {
	return Popover.node({
		child: child,
		attachment: attachment,
		onHide: options?.onHide,
		onShow: options?.onShow,
		gap: options?.gap,
		getTarget: options?.getTarget
	});
}

/**
	Animate this view.
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
	Animate this view until it is removed or re-rendered.
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
