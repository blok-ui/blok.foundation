package blok.foundation.keyboard;

import blok.ui.*;

function withKeyboardInputHandler(
  child:Child,
  handler:(key:KeyType, getModifierState:(modifier:KeyModifier)->Bool)->Void,
  ?preventDefault
) {
  return KeyboardInput.node({
    child: child,
    handler: handler,
    preventDefault: preventDefault ?? true
  });
}
