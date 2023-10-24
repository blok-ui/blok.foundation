package blok.foundation.keyboard;

import blok.ui.*;

function withKeyboardInputHandler(
  child:Child,
  handler:(key:KeyType, getModifierState:(modifier:KeyModifier)->Bool)->Void,
  ?options:{ preventDefault:Bool }
) {
  return KeyboardInput.node({
    child: child,
    handler: handler,
    preventDefault: options?.preventDefault ?? true
  });
}
