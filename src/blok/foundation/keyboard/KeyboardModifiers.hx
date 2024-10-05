package blok.foundation.keyboard;

import blok.ui.*;

typedef KeyboardInputHandler = (key:KeyType, getModifierState:(modifier:KeyModifier) -> Bool) -> Void;

function withKeyboardInputHandler(child:Child, handler:KeyboardInputHandler, ?options:{preventDefault:Bool}) {
	return KeyboardInput.node({
		child: child,
		handler: handler,
		preventDefault: options?.preventDefault ?? true
	});
}
